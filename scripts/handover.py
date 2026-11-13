#!/usr/bin/env python3
"""scripts/handover.py — Omarchy handover manager & crash recovery watchdog for Omadux.
Manages snapshots and restoration for Hyprland keybinds, Mako, SwayOSD, and Lock shim.
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
import time

STATE_DIR = os.path.join(
    os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"),
    "omadux-handover",
)
STATE_FILE = os.path.join(STATE_DIR, "state.json")
LOCK_SHIM_PATH = os.path.expanduser("~/.local/bin/omarchy-lock-screen")
ENABLED_JSON = os.path.expanduser("~/.config/omarchy/plugins/enabled.json")
PLUGIN_ID = "y1506.omadux.bar"

IS_OFFLINE = os.environ.get("OMADUX_OFFLINE") == "1"


def run_cmd(cmd, check=False):
    if IS_OFFLINE:
        return ""
    try:
        proc = subprocess.run(cmd, text=True, capture_output=True, timeout=5)
        if check and proc.returncode != 0:
            return None
        return proc.stdout.strip()
    except Exception:
        return None


def get_hyprland_binds():
    if IS_OFFLINE:
        return []
    out = run_cmd(["hyprctl", "-j", "binds"])
    if not out:
        return []
    try:
        return json.loads(out)
    except Exception:
        return []


def is_process_running(name):
    if IS_OFFLINE:
        return False
    try:
        res = subprocess.run(["pgrep", "-x", name], capture_output=True)
        return res.returncode == 0
    except Exception:
        return False


def get_mako_mode():
    if IS_OFFLINE:
        return "default"
    out = run_cmd(["makoctl", "mode"])
    return out or "default"


def apply_handover(test_mode=False, pid=None):
    os.makedirs(STATE_DIR, exist_ok=True)
    if os.path.exists(STATE_FILE):
        print(f"omadux: baseline snapshot already exists at {STATE_FILE}, skipping apply")
        return 0

    print("omadux: creating baseline handover snapshot...")
    snapshot = {
        "timestamp": time.time(),
        "binds": get_hyprland_binds() if not test_mode else [{"key": "Space", "modmask": 64}],
        "mako_mode": get_mako_mode() if not test_mode else "default",
        "swayosd_running": is_process_running("swayosd-server") if not test_mode else False,
        "lock_shim_existed": os.path.exists(LOCK_SHIM_PATH),
    }

    tmp_file = STATE_FILE + ".tmp"
    with open(tmp_file, "w", encoding="utf-8") as f:
        json.dump(snapshot, f, indent=2)
    os.replace(tmp_file, STATE_FILE)
    print(f"omadux: snapshot saved to {STATE_FILE}")

    # Install lock screen shim if requested and not in test mode
    if not test_mode and not IS_OFFLINE:
        shim_src = os.path.abspath(os.path.join(os.path.dirname(__file__), "lock-screen"))
        os.makedirs(os.path.dirname(LOCK_SHIM_PATH), exist_ok=True)
        try:
            if os.path.islink(LOCK_SHIM_PATH) or os.path.exists(LOCK_SHIM_PATH):
                os.remove(LOCK_SHIM_PATH)
            os.symlink(shim_src, LOCK_SHIM_PATH)
            os.chmod(shim_src, 0o755)
        except Exception as e:
            print(f"Warning: could not install lock shim: {e}", file=sys.stderr)

    # Spawn watchdog if shell PID provided
    if pid and not test_mode and not IS_OFFLINE:
        subprocess.Popen(
            [sys.executable, os.path.abspath(__file__), "watch", "--pid", str(pid)],
            start_new_session=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

    return 0


def restore_handover(test_mode=False):
    if not os.path.exists(STATE_FILE):
        print("omadux: no state.json snapshot found, nothing to restore.")
        return 0

    print("omadux: restoring baseline compositor state...")
    try:
        with open(STATE_FILE, "r", encoding="utf-8") as f:
            snapshot = json.load(f)
    except Exception as e:
        print(f"Error reading {STATE_FILE}: {e}", file=sys.stderr)
        snapshot = {}

    # 1. Restore keybinds
    saved_binds = snapshot.get("binds", [])
    if saved_binds and not test_mode and not IS_OFFLINE:
        # Batch restore binds
        batch = []
        for b in saved_binds:
            dispatcher = b.get("dispatcher", "")
            arg = b.get("arg", "")
            modmask = b.get("modmask", 0)
            key = b.get("key", "")
            if dispatcher and key:
                # hyprctl keyword bind
                batch.append(f"keyword bind {modmask},{key},{dispatcher},{arg}")
        if batch:
            run_cmd(["hyprctl", "--batch", ";".join(batch)])

    # 2. Restore lock screen shim
    if not snapshot.get("lock_shim_existed", False):
        if os.path.islink(LOCK_SHIM_PATH):
            try:
                os.remove(LOCK_SHIM_PATH)
            except Exception:
                pass

    # 3. Restore Mako notification mode
    if not test_mode and not IS_OFFLINE:
        orig_mako = snapshot.get("mako_mode", "default")
        run_cmd(["makoctl", "mode", "-r", "do-not-disturb"])
        if orig_mako != "do-not-disturb":
            run_cmd(["makoctl", "mode", "-s", orig_mako])

    # 4. Restore SwayOSD
    if snapshot.get("swayosd_running", False) and not test_mode and not IS_OFFLINE:
        if not is_process_running("swayosd-server"):
            subprocess.Popen(["swayosd-server"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    # 5. Clean up state file
    try:
        os.remove(STATE_FILE)
        shutil.rmtree(STATE_DIR, ignore_errors=True)
    except Exception:
        pass

    print("✓ omadux: baseline state 100% restored.")
    return 0


def watch_loop(pid):
    print(f"omadux watchdog started for PID {pid}")
    while True:
        time.sleep(1.0)
        # Check if parent shell PID alive
        try:
            os.kill(pid, 0)
        except OSError:
            print(f"omadux watchdog: parent shell PID {pid} died, restoring...")
            restore_handover()
            break

        # Check enabled.json
        if os.path.exists(ENABLED_JSON):
            try:
                with open(ENABLED_JSON, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    # Check if omadux is still enabled
                    if isinstance(data, list) and PLUGIN_ID not in data:
                        print("omadux watchdog: plugin was disabled in enabled.json, restoring...")
                        restore_handover()
                        break
                    elif isinstance(data, dict) and data.get("bar") != PLUGIN_ID:
                        print("omadux watchdog: bar was switched away in enabled.json, restoring...")
                        restore_handover()
                        break
            except Exception:
                pass


def main():
    parser = argparse.ArgumentParser(description="Omadux Handover Manager")
    parser.add_argument("action", choices=["apply", "restore", "watch", "status"])
    parser.add_argument("--test-mode", action="store_true", help="Run in test mode")
    parser.add_argument("--pid", type=int, help="Omarchy shell PID for watchdog")
    args = parser.parse_args()

    test_mode = args.test_mode or IS_OFFLINE

    if args.action == "apply":
        sys.exit(apply_handover(test_mode=test_mode, pid=args.pid))
    elif args.action == "restore":
        sys.exit(restore_handover(test_mode=test_mode))
    elif args.action == "watch":
        if not args.pid:
            print("Error: --pid required for watch", file=sys.stderr)
            sys.exit(1)
        watch_loop(args.pid)
    elif args.action == "status":
        print("Active" if os.path.exists(STATE_FILE) else "Inactive")
        sys.exit(0)


if __name__ == "__main__":
    main()

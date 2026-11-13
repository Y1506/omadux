# Omadux (`y1506.omadux.bar`)

**Omadux** is a zero-destructive, hotswappable full-shell `bar` plugin for Omarchy. It brings the entire **DUX Shell** (`dux-shell` + `dms` Go daemon + `DCommon`) into the Omarchy / Quattro (`omarchy-shell`) runtime with live Material 3 theme sync, dynamic keybind takeovers, and dual-plugin hosting.

---

## Architecture & Design Rules

1. **Zero-Destructive Compositor Safety:**
   - **Never edits on disk:** `omadux` never writes to `~/.config/hypr/*.conf` or `/usr/share/omarchy/default/hypr/*`.
   - **Dynamic runtime takeovers:** All modal keybinds (`Super+Space` for launcher, `Super+Alt+Space` for settings, etc.) are rebound at runtime via `hyprctl keyword unbind/bind`.
   - **100% Baseline Restoration:** `scripts/handover.py` takes an immutable baseline snapshot before applying changes and spawns a detached watchdog. When the plugin is disabled or `omarchy-shell` exits, all original bindings, Mako notifications, and SwayOSD are 100% restored within 1 second.
2. **Safe Deployment Isolation:**
   - External application configuration deployment in DUX's `dms` backend (`core/internal/matugen` and `core/internal/config/deployer.go`) is strictly gated by `OMADUX_DISABLE_EXTERNAL_DEPLOY=1` and `enableExternalAppTheming: false` (default `false`).
3. **In-Process Quattro Integration:**
   - Resolves Quickshell namespace collisions by rewriting DUX's internal `import qs.*` into relative directory imports + `qmldir` singletons, while preserving Omarchy's host singletons (`qs.Core`, `qs.Ui`).
4. **Dual Plugin Support:**
   - Hosts native DUX plugins alongside third-party Omarchy `bar-widget` plugins via `PluginBarFacade.qml` and `BarWidgetSlot.qml` inside `DBar`.
5. **Theme & Wallpaper Synchronization:**
   - `scripts/omadux sync` converts active Omarchy `colors.toml` and wallpaper paths into a full Material 3 / Dank16 palette at `~/.cache/DankMaterialShell/omarchy-theme.json`.

---

## Directory Structure

```text
omadux/
├── manifest.json                 # Omarchy bar plugin manifest (id: "y1506.omadux.bar")
├── Bar.qml                       # Quattro root entry point & IPC handler
├── qmldir                        # Root module declaration
├── install.sh                    # Builds bin/dms, links CLI, installs theme hook
├── uninstall.sh                  # Restores handovers, stops dms, cleans up hooks
├── omadux.lua                    # Look'n'feel reference for borders & blur
├── bin/                          # Holds compiled `dms` daemon
├── core/                         # Patched Go backend source
├── quickshell/                   # Vendored & namespace-rewritten QML tree
├── omarchy/                      # Handovers, KbService, theme sync, and facade
├── scripts/                      # Handover, OSD, Mako, Lock, and Theme CLI helpers
└── tests/                        # Full verification suite
```

---

## Installation & Usage

### 1. Build & Install
```bash
./install.sh
```

### 2. Enable in Omarchy
```bash
omarchy plugin enable y1506.omadux.bar
```

### 3. Uninstall & Restore
```bash
./uninstall.sh
```

---

## Verification Test Suite

Run all automated verification tests:
```bash
bash tests/test-build.sh
bash tests/test-imports.sh
omarchy plugin validate .
bash tests/test-dms-process.sh
bash tests/test-restore.sh
bash tests/test-omadux-theme.sh
bash tests/test-facade.sh
bash tests/test-root-bar.sh
python3 scripts/upstream-check
```

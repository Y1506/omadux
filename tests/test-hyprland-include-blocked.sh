#!/bin/bash
set -euo pipefail

echo "==> Testing that ConfigIncludeResolve refuses to modify hyprland.lua under Omarchy"
node -e '
const fs = require("fs");
const vm = require("vm");
const resolve = {};
vm.createContext(resolve);
const code = fs.readFileSync("quickshell/Common/ConfigIncludeResolve.js", "utf8").replace(/^\.pragma.*$/m, "");
vm.runInContext(code, resolve);

const kinds = ["outputs", "binds", "cursor", "layout", "input", "animations", "windowrules"];
const home = process.env.HOME || "/home/y1506";

// Test 1: User ~/.config/hypr/hyprland.lua path
for (const kind of kinds) {
    const script = resolve.repairScriptFor(kind, "hyprland", home + "/.config", "/tmp/backup", "hyprland.lua", "dms");
    if (script && script.length > 0) {
        console.error(`FAIL: repairScriptFor("${kind}", "hyprland") modified ~/.config/hypr/hyprland.lua:`, script);
        process.exit(1);
    }
}

// Test 2: In Quickshell runtime
resolve.Quickshell = { env: () => "/usr/share/omarchy" };
for (const kind of kinds) {
    const script = resolve.repairScriptFor(kind, "hyprland", "/tmp/any_dir", "/tmp/backup", "hyprland.lua", "dms");
    if (script && script.length > 0) {
        console.error(`FAIL: repairScriptFor in Quickshell returned non-empty script:`, script);
        process.exit(1);
    }
}

console.log("PASS: Hyprland configuration is strictly protected from dms modification");
'

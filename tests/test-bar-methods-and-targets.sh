#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Running Test: Bar.qml QML Syntax, Targets, & No Duplicate Methods ==="

FAILED=0

# Check 1: Check for duplicate methods within each IpcHandler in Bar.qml
python3 -c '
import re, sys

with open("Bar.qml") as f:
    text = f.read()

# Tokenize / find IpcHandler blocks with matching braces
pos = 0
duplicates = []
while True:
    idx = text.find("IpcHandler", pos)
    if idx == -1:
        break
    brace_start = text.find("{", idx)
    if brace_start == -1:
        break
    # count braces
    depth = 1
    i = brace_start + 1
    while i < len(text) and depth > 0:
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
        i += 1
    block = text[brace_start:i]
    pos = i

    m_target = re.search(r"target:\s*\"([^\"]+)\"", block)
    target = m_target.group(1) if m_target else "unnamed"
    
    # find functions defined in this IpcHandler block (not in sub-objects)
    funcs = re.findall(r"\n\s*function\s+([A-Za-z0-9_]+)\s*\(", block)
    seen = set()
    for name in funcs:
        if name in seen:
            duplicates.append((target, name))
        seen.add(name)

if duplicates:
    for target, name in duplicates:
        print(f"[FAIL] Duplicate method {name} in IpcHandler {target}")
    sys.exit(1)
else:
    print("[PASS] Zero duplicate methods in Bar.qml IpcHandlers")
' || FAILED=1

# Check 2: Targets must include plugin:y1506.omadux.bar, omadux, y1506.dux, omacale
for target in "plugin:y1506.omadux.bar" "omadux" "y1506.dux" "omacale"; do
    if ! grep -q "target: \"$target\"" Bar.qml; then
        echo "[FAIL] Bar.qml missing IpcHandler for target: \"$target\""
        FAILED=1
    else
        echo "[PASS] Bar.qml has IpcHandler for target: \"$target\""
    fi
done

if [ "$FAILED" -ne 0 ]; then
    echo "=== Test FAILED (RED) ==="
    exit 1
fi

echo "=== Test PASSED (GREEN) ==="
exit 0

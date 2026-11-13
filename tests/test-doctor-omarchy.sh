#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

echo "==> Running dms doctor test for Omarchy mode..."

cd "$REPO_ROOT"

if [[ ! -x "$REPO_ROOT/bin/dms" ]]; then
    echo "ERROR: bin/dms does not exist or is not executable" >&2
    exit 1
fi

"$REPO_ROOT/bin/dms" doctor -j | python3 -c "
import sys, json

try:
    data = json.load(sys.stdin)
except Exception as e:
    print('Failed to parse doctor json from stdin:', e)
    sys.exit(1)

summary = data.get('summary', {})
errors = summary.get('errors', 0)
results = data.get('results', [])

error_items = [r for r in results if r.get('status') == 'error']

print(f'Doctor Summary: {summary}')
if error_items:
    print('Doctor reported the following errors:')
    for item in error_items:
        print(f\"  - [{item.get('category')}] {item.get('name')}: {item.get('message')} ({item.get('details', '')})\")

if errors > 0 or len(error_items) > 0:
    print(f'TEST FAILED: dms doctor reported {errors} error(s)')
    sys.exit(1)

print('TEST PASSED: dms doctor reported 0 errors!')
"

echo "✓ dms doctor test passed on Omarchy."

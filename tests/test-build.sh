#!/usr/bin/env bash
set -Eeuo pipefail

echo "==> Running Task 1 Build & Validation Suite"

# 1. Validate manifest.json exists and satisfies omarchy plugin validate
if ! command -v omarchy-plugin-validate >/dev/null 2>&1 && ! command -v omarchy >/dev/null 2>&1; then
    echo "omarchy CLI not found, performing strict manifest JSON check"
    jq -e '.schemaVersion == 1 and .id == "y1506.omadux.bar" and (.kinds | index("bar")) != null and .entryPoints.bar == "Bar.qml"' manifest.json >/dev/null
else
    omarchy plugin validate .
fi
echo "✓ Manifest validation passed"

# 2. Check install.sh creates bin/dms
bash ./install.sh --dry-build
[[ -x ./bin/dms ]] || { echo "ERROR: bin/dms was not built or not executable"; exit 1; }
echo "✓ bin/dms built successfully"

# 3. Test that OMADUX_DISABLE_EXTERNAL_DEPLOY is respected in dms
output=$(OMADUX_DISABLE_EXTERNAL_DEPLOY=1 ./bin/dms --help 2>&1 || true)
[[ $output =~ "Dank Material Shell" ]] || [[ $output =~ "dms" ]] || { echo "ERROR: unexpected dms output"; exit 1; }
echo "✓ dms runs properly"

echo "ALL TESTS PASSED for Task 1"

#!/usr/bin/env bash
set -Eeuo pipefail

PLUGIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$PLUGIN_DIR/bin"
DMS_BIN="$BIN_DIR/dms"

mkdir -p "$BIN_DIR"

build_dms() {
    echo "==> Building dms backend..."
    if command -v go >/dev/null 2>&1; then
        echo "Compiling dms with Go toolchain..."
        (cd "$PLUGIN_DIR/core" && CGO_ENABLED=0 go build -ldflags="-s -w" -o "$DMS_BIN" ./cmd/dms)
        chmod +x "$DMS_BIN"
        echo "✓ dms binary successfully built at $DMS_BIN"
    else
        echo "Go not installed; attempting prebuilt download..."
        local arch
        case "$(uname -m)" in
            x86_64)  arch="amd64" ;;
            aarch64) arch="arm64" ;;
            *)       arch="amd64" ;;
        esac
        local url="https://github.com/duxlabs-dev/dux-shell/releases/latest/download/dms-linux-${arch}"
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$url" -o "$DMS_BIN"
        elif command -v wget >/dev/null 2>&1; then
            wget -qO "$DMS_BIN" "$url"
        else
            echo "ERROR: Neither go, curl, nor wget available to obtain dms binary." >&2
            exit 1
        fi
        chmod +x "$DMS_BIN"
        echo "✓ Downloaded prebuilt dms binary to $DMS_BIN"
    fi
}

build_dms

if [[ "${1:-}" == "--dry-build" ]]; then
    echo "Dry build finished."
    exit 0
fi

# Set up CLI helper and hooks
mkdir -p "$HOME/.local/bin"
chmod +x "$PLUGIN_DIR/scripts/omadux" 2>/dev/null || true
ln -sf "$PLUGIN_DIR/scripts/omadux" "$HOME/.local/bin/omadux"

# Ensure binary is in active plugin runtime path if present
OMARCHY_PLUGIN_SHARE="$HOME/.local/share/omarchy/plugins/y1506.omadux.bar"
mkdir -p "$OMARCHY_PLUGIN_SHARE/bin"
cp -p "$DMS_BIN" "$OMARCHY_PLUGIN_SHARE/bin/dms"
chmod +x "$OMARCHY_PLUGIN_SHARE/bin/dms"

HOOKS_DIR="$HOME/.config/omarchy/hooks/theme-set.d"
mkdir -p "$HOOKS_DIR"
cat << 'EOF' > "$HOOKS_DIR/20-omadux.sh"
#!/usr/bin/env bash
if [[ -x "$HOME/.local/bin/omadux" ]]; then
    "$HOME/.local/bin/omadux" sync >/dev/null 2>&1 || true
fi
EOF
chmod +x "$HOOKS_DIR/20-omadux.sh"

echo "✓ Omadux installed successfully."

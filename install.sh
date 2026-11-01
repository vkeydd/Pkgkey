#!/bin/sh
# ==============================================================================
# Bootstrap Installer for pkgkey (pkey) v0.5.0
# Repository: https://github.com/vkeydd/Pkgkey
# Supports: curl, wget, busybox wget
# ==============================================================================
set -e

REPO_USER="vkeydd"
REPO_NAME="Pkgkey"
BRANCH="main"

PKEY_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/pkey"

TARGET_DIR="${HOME}/.local/bin"
TARGET_BIN="${TARGET_DIR}/pkey"
PROFILE_FILE="${HOME}/.profile"
CONFIG_DIR="${HOME}/.local/share/pkgkey/packages"

echo "==> Preparing pkgkey (pkey) environment..."
mkdir -p "$TARGET_DIR"
mkdir -p "$CONFIG_DIR"

echo "==> Fetching pkey binary from GitHub repository..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$PKEY_URL" -o "$TARGET_BIN"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$TARGET_BIN" "$PKEY_URL"
elif command -v busybox >/dev/null 2>&1; then
    busybox wget -qO "$TARGET_BIN" "$PKEY_URL"
else
    echo "Error: Neither curl, wget, nor busybox was found on your system." >&2
    echo "Please install curl or wget to continue." >&2
    exit 1
fi

# Ensure execute permission
chmod +x "$TARGET_BIN"

# Configure PATH in ~/.profile if needed
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
case ":$PATH:" in
    *:"$TARGET_DIR":*)
        echo "==> ~/.local/bin is already in your PATH."
        ;;
    *)
        if [ -f "$PROFILE_FILE" ]; then
            if ! grep -qs '\$HOME/\.local/bin' "$PROFILE_FILE" && ! grep -qs "$HOME/.local/bin" "$PROFILE_FILE"; then
                echo "" >> "$PROFILE_FILE"
                echo "# Added by pkgkey bootstrap installer" >> "$PROFILE_FILE"
                echo "$PATH_LINE" >> "$PROFILE_FILE"
                echo "==> Appended ~/.local/bin to $PROFILE_FILE"
            fi
        else
            echo "$PATH_LINE" > "$PROFILE_FILE"
            echo "==> Created $PROFILE_FILE and added ~/.local/bin to PATH"
        fi
        ;;
esac

echo "==> pkgkey  v0.6 installed successfully!"
echo "==> Run 'source ~/.profile' (or restart your shell), then type 'pkey -h' to get started."

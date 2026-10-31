#!/bin/sh

set -e



REPO_USER="vkeydd"

REPO_NAME="Pkgkey"

BRANCH="main"



PKEY_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/pkey"



TARGET_DIR="${HOME}/.local/bin"

TARGET_BIN="${TARGET_DIR}/pkey"

PROFILE_FILE="${HOME}/.profile"

CONFIG_DIR="${HOME}/.local/share/pkgkey/packages"



echo "==> Installing pkgkey (pkey) v0.5.0..."



mkdir -p "$TARGET_DIR"

mkdir -p "$CONFIG_DIR"



echo "==> Fetching pkey binary from repository..."

if command -v curl >/dev/null 2>&1; then

    curl -fsSL "$PKEY_URL" -o "$TARGET_BIN"

elif command -v wget >/dev/null 2>&1; then

    wget -qO "$TARGET_BIN" "$PKEY_URL"

elif command -v busybox >/dev/null 2>&1; then

    busybox wget -qO "$TARGET_BIN" "$PKEY_URL"

else

    echo "Error: Neither curl, wget, nor busybox was found on the system." >&2

    exit 1

fi



chmod +x "$TARGET_BIN"



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



echo "==> Installation completed successfully!"

echo "==> Run 'source ~/.profile' or restart your shell, then type 'pkey -h' to begin."

EOF



chmod +x install.sh

chmod +x pkey

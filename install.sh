#!/bin/sh
# ==============================================================================
# Project Name : PkgKey Unified Installer
# Description  : Interactive installer for choosing and downloading either 
#                rootless (pkey) or system-wide (rkey) package managers.
# ==============================================================================

set -e

REPO_USER="vkeydd"
REPO_NAME="Pkgkey"
BRANCH="main"

print_banner() {
    echo "===================================================================="
    echo "          Welcome to PkgKey Ecosystem Unified Installer             "
    echo "===================================================================="
}

print_menu() {
    echo ""
    echo "Please select the installation type:"
    echo ""
    echo "  [1] pkey (Rootless / User-Level)"
    echo "      - Does NOT require root privileges."
    echo "      - Installs binaries to: ~/.local/bin"
    echo "      - Stores databases under: ~/.local/share/pkgkey/packages"
    echo ""
    echo "  [2] rkey (System-Wide / Root-Level)"
    echo "      - REQUIRES root (sudo) privileges."
    echo "      - Installs binaries to: /rkey/bin"
    echo "      - Stores databases under: /rkey/share/rkey/packages"
    echo ""
    printf "Enter your choice [1 or 2]: "
}

fetch_file() {
    url="$1"
    output="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$output"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$output" "$url"
    elif command -v busybox >/dev/null 2>&1; then
        busybox wget -qO "$output" "$url"
    else
        echo "Error: Neither curl, wget, nor busybox was found on your system." >&2
        exit 1
    fi
}

print_banner
print_menu
read -r choice </dev/tty
case "$choice" in
    1)
        echo ""
        echo "==> Installing pkey (Rootless / User-Level)..."
        
        TARGET_DIR="${HOME}/.local/bin"
        TARGET_BIN="${TARGET_DIR}/pkey"
        CONFIG_DIR="${HOME}/.local/share/pkgkey/packages"
        PROFILE_FILE="${HOME}/.profile"
        
        mkdir -p "$TARGET_DIR"
        mkdir -p "$CONFIG_DIR"
        
        PKEY_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/pkey"
        echo "==> Fetching pkey from GitHub repository..."
        fetch_file "$PKEY_URL" "$TARGET_BIN"
        chmod +x "$TARGET_BIN"
        
        # Configure PATH in ~/.profile if needed
        PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'
        case ":$PATH:" in
            *:"$TARGET_DIR":*) ;;
            *)
                if [ -f "$PROFILE_FILE" ]; then
                    if ! grep -qs '\$HOME/\.local/bin' "$PROFILE_FILE" && ! grep -qs "$HOME/.local/bin" "$PROFILE_FILE"; then
                        echo "" >> "$PROFILE_FILE"
                        echo "# Added by pkgkey bootstrap installer" >> "$PROFILE_FILE"
                        echo "$PATH_LINE" >> "$PROFILE_FILE"
                    fi
                else
                    echo "$PATH_LINE" > "$PROFILE_FILE"
                fi
                ;;
        esac

        # Configure Smart API Wrapper in ~/.profile if not present
        if ! grep -q "# Pkey Smart API Wrapper" "$PROFILE_FILE" 2>/dev/null; then
            echo "==> Configuring ~/.profile with smart API wrapper for pkey..."
            cat << 'EOF' >> "$PROFILE_FILE"

# Pkey Smart API Wrapper
pkey() {
    case "$1" in
        -i|install) ;;
        *) 
            command "$HOME/.local/bin/pkey" "$@"
            return
            ;;
    esac

    shift
    local target="$1"
    shift
    
    if [ -z "$target" ]; then
        command "$HOME/.local/bin/pkey" -i
        return
    fi

    local resolved_url="$target"

    case "$target" in
        http://*|https://*)
            resolved_url="$target"
            ;;
        gh:*|github:*)
            local repo="${target#*:}"
            local api_url="https://api.github.com/repos/$repo/releases/latest"
            resolved_url=$(curl -s "$api_url" | grep "tarball_url" | head -n 1 | cut -d '"' -f 4)
            [ -z "$resolved_url" ] || [ "$resolved_url" = "null" ] && resolved_url="https://github.com/$repo/archive/refs/heads/main.tar.gz"
            ;;
        gl:*|gitlab:*)
            local repo="${target#*:}"
            local enc_repo=$(echo "$repo" | sed 's/\//%2F/g')
            local api_url="https://gitlab.com/api/v4/projects/$enc_repo/releases"
            resolved_url=$(curl -s "$api_url" | grep "tar.gz" | head -n 1 | cut -d '"' -f 4)
            [ -z "$resolved_url" ] || [ "$resolved_url" = "null" ] && resolved_url="https://gitlab.com/$repo/-/archive/main.tar.gz"
            ;;
        cb:*|codeberg:*)
            local repo="${target#*:}"
            local api_url="https://codeberg.org/api/v1/repos/$repo/releases"
            resolved_url=$(curl -s "$api_url" | grep "zipball_url" | head -n 1 | cut -d '"' -f 4)
            [ -z "$resolved_url" ] || [ "$resolved_url" = "null" ] && resolved_url="https://codeberg.org/$repo/archive/main.tar.gz"
            ;;
        *)
            local api_url="https://api.github.com/repos/$target/releases/latest"
            resolved_url=$(curl -s "$api_url" | grep "tarball_url" | head -n 1 | cut -d '"' -f 4)
            [ -z "$resolved_url" ] || [ "$resolved_url" = "null" ] && resolved_url="https://github.com/$repo/archive/refs/heads/main.tar.gz"
            ;;
    esac

    echo "==> [API Resolver] Target: $resolved_url"
    "$HOME/.local/bin/pkey" -i "$resolved_url" "$@"
}
EOF
        fi
        
        echo ""
        echo "===================================================================="
        echo "✅ pkey installed successfully!"
        echo "Run 'source ~/.profile', then type 'pkey -h' to get started."
        echo "===================================================================="
        ;;
        
    2)
        echo ""
        echo "==> Installing rkey (System-Wide / Root-Level)..."
        
        if [ "$(id -u)" -ne 0 ]; then
            echo "Error: rkey installation requires root privileges. Please run with sudo." >&2
            exit 1
        fi
        
        TARGET_DIR="/rkey/bin"
        TARGET_BIN="${TARGET_DIR}/rkey"
        CONFIG_DIR="/rkey/share/rkey/packages"
        
        mkdir -p "$TARGET_DIR"
        mkdir -p "$CONFIG_DIR"
        
        RKEY_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/rkey"
        echo "==> Fetching rkey from GitHub repository..."
        fetch_file "$RKEY_URL" "$TARGET_BIN"
        chmod +x "$TARGET_BIN"
        
        echo ""
        echo "===================================================================="
        echo "✅ rkey installed successfully!"
        echo "Binary location: ${TARGET_BIN}"
        echo "Make sure to add /rkey/bin to your system PATH."
        echo "===================================================================="
        ;;
        
    *)
        echo "Error: Invalid selection. Please choose 1 or 2." >&2
        exit 1
        ;;
esac

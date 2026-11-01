# PkgKey Ecosystem (`pkey` & `rkey`)

[![Version](https://shields.io)](https://github.com)
[![License: MIT](https://shields.io)](LICENSE)
[![POSIX Compliant](https://shields.io)]()

> A minimalist, POSIX-compliant dual-mode package management ecosystem for Linux systems, inspired by `pkgutils` and CRUX, featuring user-space rootless (`pkey`) and system-wide root-level (`rkey`) execution layers.

`PkgKey` evolved into a light, independent, LFS-ready package management framework. It provides complete transparency and precise tracking of software installed either in user space (`~/.local`) or across the entire system (`/rkey`).

---

## 🚀 Key Features

* **Dual-Mode Architecture:** 
  * **`pkey` (Rootless):** Installs binaries, scripts, and libraries strictly under `~/.local` (no root access required).
  * **`rkey` (System-Wide):** Manages global system packages under `/rkey` (requires root privileges).
* **Interactive Unified Installer:** A single bootstrap script (`install.sh`) that guides you through selecting and setting up your preferred mode.
* **Built-In Fetcher:** Uses an internal download utility (`*key_fetch`) that seamlessly cascades through `curl`, `wget`, and `busybox wget` to remove external hard dependencies.
* **Staged Build Isolation:** Features a `DESTDIR`-style staged installation model to guarantee complete containment and zero pollution of your environment.
* **Auto-Heuristic Compilation:** Automatically detects build systems (`Autotools`, `CMake`, `Makefile`, single C files) or uses custom `.pkgkey`/`.rkey` micro-recipes.
* **Atomic File Registry:** Maintains a clear file list for every installed package, enabling safe and complete uninstalls.

---

## 📦 Get Started

You can bootstrap the `PkgKey` interactively using either `curl` or `wget`:

### Via `curl`
```sh
curl -fsSL https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh | sh | sh
```

### Via `wget`
```sh
wget -qO- https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh | sh
```

---

## 🛠️ Command Reference (`pkey` / `rkey`)

Both tools share the exact same clean CLI:

| Command | Short | Description | Example |
| :--- | :--- | :--- | :--- |
| **fetch** | | Download a remote file using internal fetcher | `pkey fetch https://example.com` |
| **install** | `-i` | Install a prebuilt binary, script, or standalone archive | `pkey -i neofetch https://.../neofetch` |
| **compile-install** | `-ci` | Download, compile from source, and install automatically | `pkey -ci cpufetch https://.../v1.04.tar.gz` |
| **update** | `-u` | Re-fetch and update installed package(s) | `pkey -u cpufetch` |
| **remove** | `-R` | Safely uninstall package & clean tracking registry | `pkey -R cpufetch` |
| **list** | `-l` | List all installed packages in the system database | `pkey -l` |
| **version** | `-v` | Show version information | `pkey -v` |
| **help** | `-h` | Display full help and usage instructions | `pkey -h` |

---

## 📜 Custom Micro-Recipes (`.pkgkey` / `.rkey`)

For packages requiring special build steps, you can pass a recipe script to compile-install (`-ci`):

```sh
# Example: custom_tool.pkgkey (or custom_tool.rkey)
NAME="custom_tool"
URL="https://example.com"

build() {
    DESTDIR="$1"
    make DESTDIR="$DESTDIR" PREFIX="$HOME/.local" install
}
```

To run your custom recipe:

```sh
pkey -ci custom_tool.pkgkey
# or system-wide:
sudo rkey -ci custom_tool.rkey
```

---

## 📁 Directory Structure

### User Space (`pkey`)
```text
~/.local/
├── bin/
│   └── pkey                              # Rootless CLI executable
└── share/
    └── pkgkey/
        ├── packages/                     # Package database registry
        │   └── neofetch.files
        └── cpufetch.url                  # Tracked source URLs for updates
```

### System Space (`rkey`)
```text
/rkey/
├── bin/
│   └── rkey                              # System-wide CLI executable
└── share/
    └── rkey/
        ├── packages/                     # System package registry
        │   └── fastfetch.files
        └── fastfetch.url                 # Tracked source URLs for updates
```

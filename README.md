# pkgkey (CLI: `pkey`)

[![Version](https://img.shields.io/badge/version-0.5.0-blue.svg)](https://github.com/vkeydd/Pkgkey)
[![License: ISC](https://img.shields.io/badge/License-ISC-brightgreen.svg)](LICENSE)
[![POSIX Compliant](https://img.shields.io/badge/POSIX-compliant-orange.svg)]()

> A minimalist, rootless, user-level (`~/.local`) package manager for Linux systems, inspired by `pkgutils` and CRUX.

`pkgkey` (invoked via `pkey`) evolved from an AppImage manager into a light, independent, LFS-ready package management framework. It provides complete transparency and precise tracking of software installed in user space without requiring `sudo` privileges.

---

## Key Features

* **Rootless Operation:** Installs binaries, scripts, and libraries strictly under `~/.local` (no root access required).
* **Built-in Fetcher:** Uses an internal download utility (`pkgkey_fetch`) that seamlessly cascades through `curl`, `wget`, and `busybox wget` to remove external hard dependencies.
* **Staged Build Isolation:** Features a `DESTDIR`-style staged installation model to guarantee complete containment and zero pollution of your system environment.
* **Auto-Heuristic Compilation:** Automatically detects build systems (`Autotools`, `CMake`, `Makefile`, single C files) or uses custom `.pkgkey` micro-recipes.
* **Atomic File Registry:** Maintains a clear file list for every installed package (`~/.local/share/pkgkey/packages/<name>.files`), enabling safe and complete uninstalls.

---

## One-Line Installation

You can bootstrap `pkgkey` directly to your `~/.local/bin` using either `curl` or `wget`:

### Via `curl`
```sh
curl -fsSL [https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh](https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh) | sh


### Via 'wget'
wget -qO- [https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh](https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh) | sh

---

Note: The installer automatically checks and appends ~/.local/bin to your PATH inside ~/.profile if it is not already present.

# Command Reference

pkey <command> [arguments]
### Command	Short	Description	Example

fetch	—	Download a remote file using pkgkey internal fetcher	pkey fetch https://example.com/file.tar.gz

install  	-i	Install a prebuilt binary, script, or standalone archive	pkey -i neofetch https://.../neofetch

compile-install	-ci	Download, compile from source, and install automatically	pkey -ci cpufetch https://.../v1.04.tar.gz

update	        -u	Re-fetch and update installed package(s)	pkey -u cpufetch

remove	        -R	Safely uninstall package & clean tracking registry	pkey -R cpufetch

list	        -l	List all installed packages in the system database	pkey -l

version	        -v	Show version information	pkey -v

help	        -h	Display full help and usage instructions	pkey -h


## How It Works

# Package Registry Model
When you install a tool using pkey, it creates two registry tracking points:

    ~/.local/share/pkgkey/packages/<name>.files: A plain-text list of every installed file path.

    ~/.local/share/pkgkey/<name>.url: (Optional) The original source location for seamless pkey -u updates.
## Custom Micro-Recipes (.pkgkey)
 For packages requiring special build steps, you can pass a .pkgkey script to pkey -ci:
# Example: custom_tool.pkgkey

NAME="custom_tool"

URL="[https://example.com/src.tar.gz](https://example.com/src.tar.gz)"



build() {

    DESTDIR="$1"

    make DESTDIR="$DESTDIR" PREFIX="$HOME/.local" install

}


# then run
pkey -ci custom_tool.pkgkey



# File System Layout


~/.local/
├── bin/
│   └── pkey                              # Main CLI executable
└── share/
    └── pkgkey/
        ├── packages/                     # Package database registry
        │   ├── neofetch.files
        │   └── cpufetch.files
        └── cpufetch.url                  # Tracked source URLs for updates 

# pkgkey (pkey)

`pkgkey` (CLI: `pkey`) is a minimalist, POSIX-compliant, user-level (`~/.local`) package management system inspired by classic Unix tooling (`pkgutils`, CRUX). Designed with simplicity, zero external dependencies, and complete transparency in mind, it operates entirely without root (`sudo`) privileges and manages packages using a clean, file-based registry.

Originally designed for lightweight binary tracking, `pkgkey` has evolved into a fully-capable, stand-alone tool suitable for Linux From Scratch (LFS) environments and non-root desktop environments.

---

## Key Features

* **Rootless & Non-Privileged:** Installs programs directly to `~/.local` without touching root system directories.
* **Zero Dependencies (Built-in Fetcher):** Uses an internal `pkgkey_fetch` abstraction layer that automatically falls back across `curl`, `wget`, or `busybox wget`.
* **Staged Builds (`DESTDIR` Model):** Performs source builds inside an isolated staging area to guarantee 100% accurate file tracking upon installation.
* **Auto-Detection Build Engine:** Compiles software from source automatically by detecting Autotools (`./configure`), CMake, Makefiles, or single C source files.
* **Micro-Recipes:** Supports optional `.pkgkey` recipe files for custom multi-step source compilation.
* **Atomic Tracking & Removal:** Every installed file is logged inside `~/.local/share/pkgkey/packages/<name>.files` for clean and complete uninstallation (`pkey -R`).

---

## Quick Installation (Bootstrap)

You can install `pkgkey` using either `curl` or `wget`. The bootstrap installer automatically configures `~/.local/bin` and updates your `$PATH` inside `~/.profile`.

### Using `curl`:
```sh
curl -fsSL [https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh](https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh) | sh
Or using Wget:
wget -qO- [https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh](https://raw.githubusercontent.com/vkeydd/Pkgkey/main/install.sh) | sh

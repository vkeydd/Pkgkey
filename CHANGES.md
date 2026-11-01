# Changelog

All notable changes to this project will be documented in this file.

## [0.6]
### 🚀 Major Improvements & Features
# Advanced Micro-Recipe Support (.pkgkey): Fully integrated micro-recipe workflow (-ci)
allowing seamless compilation and custom staging steps for 
complex packages (e.g., cmatrix, cbonsai) that do not conform to standard root-directory layouts.
# Robust Local Compilation
(make & -ci): Streamlined the local build workflow to autodetect build 
systems (./configure, CMakeLists.txt, Makefile) with precise staging and robust error handling.


### 🛠️ Bug Fixes & Refinements
# Silent Failure Prevention: Added explicit error handling and diagnostic messaging to build
system detection fallbacks, preventing silent exits when no supported build system or
source file is found.
# Path & Wrapper Resolution: Fixed binary staging paths for packages requiring custom
installation targets (such as moving from nested src/ directories to root outputs),
## [0.5.9] 
### Added
- Robust remote compilation fallback: Automatically scrape and stage compiled binaries from Makefiles lacking a standard `install` target.
- Enhanced binary health and path checks for user-level packages.

### Fixed
- Fixed `-i` (install) archive extraction behavior to prevent root directory pollution under `~/.local/`, forcing direct targets into `~/.local/bin/`.
- Removed non-command library names (`ncurses`) from default `REQUIRES` checks to eliminate false-positive dependency errors.
- Corrected trailing syntax errors in the main command router.

### Tested
- Successfully integrated and stabilized compilation workflows for complex terminal tools like `sl`, `cmatrix`, and `asciiquarium`.

## [0.5.7] 
### Added
- Automatic dependency checker for direct CLI compiles (`-ci`).
- Smart `autoreconf` detection for GitHub source archives lacking `./configure`.

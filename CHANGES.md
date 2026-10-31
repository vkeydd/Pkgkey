# Changelog

All notable changes to this project will be documented in this file.

## [0.5.9] - 2026-06-06
### Added
- Robust remote compilation fallback: Automatically scrape and stage compiled binaries from Makefiles lacking a standard `install` target.
- Enhanced binary health and path checks for user-level packages.

### Fixed
- Fixed `-i` (install) archive extraction behavior to prevent root directory pollution under `~/.local/`, forcing direct targets into `~/.local/bin/`.
- Removed non-command library names (`ncurses`) from default `REQUIRES` checks to eliminate false-positive dependency errors.
- Corrected trailing syntax errors in the main command router.

### Tested
- Successfully integrated and stabilized compilation workflows for complex terminal tools like `sl`, `cmatrix`, and `asciiquarium`.

## [0.5.7] - 2026-06-06
### Added
- Automatic dependency checker for direct CLI compiles (`-ci`).
- Smart `autoreconf` detection for GitHub source archives lacking `./configure`.

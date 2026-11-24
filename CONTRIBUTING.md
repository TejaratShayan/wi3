# Contributing to wi3

Thank you for your interest in contributing to **wi3**!

## Ways to Contribute

- **Bug reports**: Open an issue describing your WSL/Ubuntu version, the module or helper affected, and steps to reproduce.
- **Feature requests**: Suggest new modules, keybindings, or WSLg/Xephyr improvements.
- **Pull requests**: Fix bugs, improve documentation, or add new modules.

## Project Conventions

1. **Idempotent modules**: Every script in `modules/NN-name.sh` must be safe to re-run without breaking an existing setup.
2. **Use shared helpers**: Source `"$ROOT/lib/common.sh"` and use `apt_install`, `link_file`, `step`, `info`, `ok`, `warn`, and `die`.
3. **Strict bash mode**: Start shell scripts with `#!/usr/bin/env bash` and `set -euo pipefail`.
4. **No hardcoded secrets**: Never commit VPN credentials, private certificates, or machine-specific paths. Use environment variables or `~/.config/...` / `~/.zshrc.local`.
5. **Config symlinks vs. copies**:
   - Symlink static configs with `link_file`.
   - Copy once (if missing) for apps that rewrite their own config files (e.g., `flameshot`, `fcitx5`).
6. **Keep docs in sync**: Update `README.md` and `docs/HELPERS.md` when adding or changing modules, scripts, or keybindings.

## Adding a New Module

1. Create `modules/NN-your-module.sh` (using the next available two-digit prefix).
2. Add any config files under `config/<tool>/` and helper scripts under `bin/`.
3. Test running your module directly and re-running it:
   ```bash
   ./install.sh NN-your-module
   ./install.sh NN-your-module
   ```
4. Optionally lint shell scripts with `shellcheck` if installed:
   ```bash
   shellcheck install.sh lib/common.sh modules/*.sh
   ```

## Submitting a Pull Request

1. Fork the repository and create a feature branch (`git checkout -b feat/my-change`).
2. Commit your changes with clear, concise messages.
3. Push to your fork and open a Pull Request against `main`.

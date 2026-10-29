# Dotfiles

Personal dotfiles for an **Ubuntu 22.04 WSL-on-Windows** environment (with Hyprland Wayland compositor configs kept here as well).

This directory is a plain collection of config files — **not** managed via symlinks or a dotfile manager. Configs are applied by copying them into `$HOME` or `~/.config`.

## Layout

| Path              | Role                                                                                                                   |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `.zshrc`          | Primary shell config — the hub that ties everything together                                                           |
| `.gitconfig`      | Git identity (real name/email + Windows paths), delta diff pager, meld difftool/mergetool (bridged to Windows), aliases |
| `tmux.conf`       | Tmux configuration (status line, keybindings, mouse); installed as `~/.tmux.conf`                                       |
| `.vimrc`          | Legacy Vim config, kept alongside the Neovim setup                                                                     |
| `update.sh`       | System maintenance: apt, snap, rustup, cargo, npm, claude, pi                                                          |
| `exa-wrapper.sh`  | Wrapper translating `ls` flags to `exa` flags; aliased to `ls` only when `exa` is installed (legacy — see below)       |
| `meld-wrapper.sh` | Bridges git diff/merge tool `meld` to Windows `meld.exe` via `wslpath` + `powershell.exe` (Windows paths hardcoded)    |
| `wezterm.lua`     | WezTerm config — default domain `WSL:Ubuntu-22.04`, Dracula+ scheme, DankMono Nerd Font                                |
| `kitty.conf`      | Minimal kitty config — FiraCode Nerd Font, includes `theme.conf` (not committed)                                       |
| `alacritty.toml`  | Alacritty config (TOML format)                                                                                         |
| `starship.toml`   | Starship prompt (icon style, ~9 ms/render); installed as `~/.config/starship/starship.toml`                             |
| `wsl.conf`        | WSL: `network.generateResolvConf=false`, `boot.systemd=true`                                                           |
| `.wslgconfig`     | WSLg: `WESTON_RDP_MONITOR_REFRESH_RATE=120`                                                                            |
| `hypr/`           | Hyprland Wayland compositor config (split across files, `source =` includes)                                           |
| `nvim/`           | Full Lua-based Neovim config (lazy.nvim plugin manager)                                                                |
| `pi/`             | Restore set for `~/.pi/agent` (pi coding agent config) — see below                                                     |
| `.gitignore`      | Ignores `.pi/` (pi's project-config dir, which fills up with runtime state)                                           |

## Installation

These configs are plain copies — there is no dotfile manager or symlink/install script. Apply them by hand using the steps below.

### 0. Local values to set before use

Committed secrets are blanked, not placeholder-substituted — supply them from your own environment:

- `.zshrc` — API keys are empty strings in the repo (`OPENROUTER_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`, `CHUTES_OPENAI_API_KEY`, `MINIMAX_API_KEY`); export the real values locally (untracked file or shell export). Also set `VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH` to your Windows path.
- `.gitconfig` — carries a real `user.name` / `user.email` (and Windows-specific paths); change them if this isn't you.
- `meld-wrapper.sh` — hardcodes a Windows path to `meld.exe`; adjust it to your own `scoop` shims path.

### 1. Prerequisites

Install the tools each component depends on (adjust to what you have):

```bash
sudo apt install zsh tmux neovim ripgrep fd-find bat tree git git-delta python3 nodejs npm
```

> If `git-delta` isn't in your distro's repos, install delta instead via
> `cargo install git-delta` (or download a release from
> https://github.com/dandavison/delta).

Plus user-level tools (install your preferred method):

- **oh-my-zsh** — `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`; powerlevel10k is only used if `~/.p10k.zsh` exists
- **starship** — *required*: `.zshrc` runs `eval "$(starship init zsh)"` unconditionally, so every shell prints an error without it
- **fzf** — sourced from `~/.fzf.zsh`, drives the `fd`/`bat`/`tree` previews
- **delta** (git pager) — required by `.gitconfig` (`core.pager = delta`); see the apt/cargo note above
- **rbenv** — also initialised unconditionally in `.zshrc`
- **GitHub CLI (`gh`)** — required by `.gitconfig`'s credential helper (`!/usr/bin/gh auth git-credential`)
- **exa** — *optional/legacy*: unmaintained (successor: `eza`). `.zshrc` only aliases `ls` to `exa-wrapper.sh` when `command -v exa` succeeds, otherwise it falls back to `/bin/ls`
- **meld** — on the Windows side (e.g. `scoop install meld`), for the git difftool bridge
- **syncthing.exe** — on the Windows side, auto-launched by `.zshrc` tmux bootstrap

### 2. Copy config files into place

```bash
DOTFILES="$HOME/personal/dotfiles"

# Shell / git / tmux / vim
cp "$DOTFILES/.zshrc"      ~/.zshrc
cp "$DOTFILES/.gitconfig"  ~/.gitconfig
cp "$DOTFILES/tmux.conf"   ~/.tmux.conf
cp "$DOTFILES/.vimrc"      ~/.vimrc

# Wrapper scripts (referenced via ~/ paths) — keep them executable
cp "$DOTFILES/exa-wrapper.sh"   ~/exa-wrapper.sh
cp "$DOTFILES/meld-wrapper.sh"  ~/meld-wrapper.sh
chmod +x ~/exa-wrapper.sh ~/meld-wrapper.sh

# Editors / terminals (XDG config home)
mkdir -p ~/.config/nvim ~/.config/kitty ~/.config/alacritty ~/.config/hypr ~/.config/starship
cp    "$DOTFILES/nvim"/*            ~/.config/nvim/
cp    "$DOTFILES/kitty.conf"        ~/.config/kitty/kitty.conf
cp    "$DOTFILES/alacritty.toml"    ~/.config/alacritty/alacritty.toml
cp    "$DOTFILES/starship.toml"     ~/.config/starship/starship.toml
cp -r "$DOTFILES/hypr"/*            ~/.config/hypr/
```

The remaining files live on the **Windows / system** side, not `$HOME`:

- `wezterm.lua` → `C:\Users\<you>\.config\wezterm\wezterm.lua` (see the header comment in the file)
- `wsl.conf` → `/etc/wsl.conf`, then from Windows run `wsl --shutdown` and restart WSL
- `.wslgconfig` → `C:\Users\<you>\.wslgconfig`

### 3. Post-install

```bash
source ~/.zshrc     # or start a new shell
nvim                # first run installs plugins via lazy.nvim
```

Opening tmux will auto-create the `syncthing` and `default` sessions (see `.zshrc`).

## The `pi/` backup

`dotfiles/pi/` is a restore set for `~/.pi/agent`, the config directory of the [pi](https://github.com/earendil-works/pi) coding agent. `pi/MANIFEST.md` holds the full inventory and the numbered steps to rebuild it on a new machine.

It stores only files that have **no git remote**; everything else is re-cloned from https URLs pinned to full SHAs. Credentials and sessions are never stored — re-authenticate after restoring.

The directory is `pi/`, deliberately **not** `.pi/`: `.pi/` is pi's own project-config location, and running pi in this repo would populate it with ~89M of runtime state. The root `.gitignore` blocks it for that reason.

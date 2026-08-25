# Dotfiles

Personal dotfiles for an **Ubuntu 22.04 WSL-on-Windows** environment (with Hyprland Wayland compositor configs kept here as well).

This directory is a plain collection of config files — **not** managed via symlinks or a dotfile manager. Configs are applied by copying them into `$HOME` or `~/.config`.

## Layout

| Path              | Role                                                                                                                   |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `.zshrc`          | Primary shell config — the hub that ties everything together                                                           |
| `.gitconfig`      | Git identity (redacted placeholders), delta diff pager, meld difftool/mergetool (bridged to Windows), aliases          |
| `.tmux.conf`      | Tmux configuration (status line, keybindings, mouse)                                                                   |
| `.vimrc`          | Legacy Vim config, kept alongside the Neovim setup                                                                     |
| `update.sh`       | System maintenance: apt, snap, rustup, cargo, npm, claude                                                              |
| `exa-wrapper.sh`  | Wrapper translating `ls` flags to `exa` flags; used via `alias ls=~/exa-wrapper.sh`                                    |
| `meld-wrapper.sh` | Bridges git diff/merge tool `meld` to Windows `meld.exe` via `wslpath` + `powershell.exe` (Windows user path redacted) |
| `wezterm.lua`     | WezTerm config — default domain `WSL:Ubuntu-22.04`, Dracula+ scheme, DankMono Nerd Font                                |
| `kitty.conf`      | Minimal kitty config — FiraCode Nerd Font, includes `theme.conf`                                                       |
| `alacritty.toml`  | Alacritty config (TOML format)                                                                                         |
| `wsl.conf`        | WSL: `network.generateResolvConf=false`, `boot.systemd=true`                                                           |
| `.wslgconfig`     | WSLg: `WESTON_RDP_MONITOR_REFRESH_RATE=120`                                                                            |
| `hypr/`           | Hyprland Wayland compositor config (split across files, `source =` includes)                                           |
| `nvim/`           | Full Lua-based Neovim config (lazy.nvim plugin manager)                                                                |

## Installation

These configs are plain copies — there is no dotfile manager or symlink/install script. Apply them by hand using the steps below.

### 0. Replace placeholders before use

- `gitconfig` — set `user.name` / `user.email` (currently `YOUR_NAME` / `your.email@example.com`)
- `.zshrc` — fill in the `YOUR_*_API_KEY` values; set `VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH` to your real Windows path
- `meld-wrapper.sh` — replace `YOUR_WINDOWS_USERNAME` with your actual Windows username

### 1. Prerequisites

Install the tools each component depends on (adjust to what you have):

```bash
sudo apt install zsh tmux neovim ripgrep fd-find bat tree git git-delta python3 nodejs npm
```

> If `git-delta` isn't in your distro's repos, install delta instead via
> `cargo install git-delta` (or download a release from
> https://github.com/dandavison/delta).

Plus user-level tools (install your preferred method):

- **oh-my-zsh** + **powerlevel10k** (or starship) — `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- **fzf**, **exa**, **starship** — see each project's install docs
- **delta** (git pager) — required by `.gitconfig` (`core.pager = delta`); see the apt/cargo note above
- **meld** — on the Windows side (e.g. `scoop install meld`), for the git difftool bridge
- **syncthing.exe** — on the Windows side, auto-launched by `.zshrc` tmux bootstrap

### 2. Copy config files into place

```bash
DOTFILES="$HOME/personal/dotfiles"

# Shell / git / tmux / vim
cp "$DOTFILES/.zshrc"      ~/.zshrc
cp "$DOTFILES/.gitconfig"  ~/.gitconfig
cp "$DOTFILES/.tmux.conf"  ~/.tmux.conf
cp "$DOTFILES/.vimrc"      ~/.vimrc

# Wrapper scripts (referenced via ~/ paths) — keep them executable
cp "$DOTFILES/exa-wrapper.sh"   ~/exa-wrapper.sh
cp "$DOTFILES/meld-wrapper.sh"  ~/meld-wrapper.sh
chmod +x ~/exa-wrapper.sh ~/meld-wrapper.sh

# Editors / terminals (XDG config home)
mkdir -p ~/.config/nvim ~/.config/kitty ~/.config/alacritty ~/.config/hypr
cp    "$DOTFILES/nvim"/*            ~/.config/nvim/
cp    "$DOTFILES/kitty.conf"        ~/.config/kitty/kitty.conf
cp    "$DOTFILES/alacritty.toml"    ~/.config/alacritty/alacritty.toml
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

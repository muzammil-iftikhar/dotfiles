# Dotfiles

Personal dotfiles for an **Ubuntu 22.04 WSL-on-Windows** environment (with Hyprland Wayland compositor configs kept here as well).

This directory is a plain collection of config files — **not** managed via symlinks or a dotfile manager. Configs are applied by copying them into `$HOME` or `~/.config`.

## Layout

| Path              | Role                                                                                                                   |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `.zshrc`          | Primary shell config — the hub that ties everything together (see below)                                               |
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

## Components

### Shell — `.zshrc`

- oh-my-zsh with powerlevel10k instant prompt and starship prompt
- **tmux bootstrap**: if not in tmux, auto-creates a `syncthing` session (`syncthing.exe serve`) and a `default` session
- Plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, ubuntu, fzf, zsh-z, sudo, copyfile, jsontools, copybuffer, docker, fancy-ctrl-z, dirhistory, extract, kubectl, copypath, command-not-found, colored-man-pages, terraform, tmux
- fzf integration with `fd` + `bat` previews and `tree` preview
- `pathadd` helper builds PATH from `.local/bin`, `.yarn/bin`, `.rvm/bin`, mason, `.rbenv/bin`, `.npm-global/bin`, `/snap/bin`, Windows scoop shims, bun
- `EDITOR=nvim`, `XDG_CONFIG_HOME=$HOME/.config`
- `JAVA_HOME` derived from `readlink -f $(which java)`

### Git — `.gitconfig`

- `core.pager = delta` with side-by-side diff, `mantis-shrimp` features, navigation
- `difftool = meld` via `$HOME/meld-wrapper.sh` (mergetool block commented out)
- `merge.conflictstyle=diff3`, `merge.ff=false`, `init.defaultBranch=main`, `fetch.prune=true`
- `credential.helper=store`, `core.autocrlf=input`
- `[user]` identity is redacted with placeholders (`YOUR_NAME` / `your.email@example.com`) — replace before use

### Neovim — `nvim/`

- `init.lua` → `require("user")`; `lua/user/` holds options, lazy, keymaps, and behavior modules
- lazy.nvim bootstrap with 29 plugin configs in `lua/plugins/`: lsp, treesitter, telescope, harpoon, gitsigns, oil, copilot, lualine, autopairs_and_cmp, spectre, leap, wilder, comment, dressing, todo_comments, nvim-tmux-navigator, markdown-preview, and more
- Custom filetype detection for OCaml/Reason/Groovy in `after/`
- `lazy-lock.json` pins plugin versions

### Hyprland — `hypr/`

`hyprland.conf` is the entry point that `source`s the rest:

- **`exec-once`**: waybar, blueman-applet, udiskie, nm-applet, dunst, cliphist, polkit auth, wallpaper/battery scripts (from `$scrPath = $HOME/.local/share/bin`)
- `animations.conf`, `keybindings.conf`, `windowrules.conf`, `monitors.conf`, `userprefs.conf`, `nvidia.conf`
- `themes/common.conf`, `themes/theme.conf` (Rose-Pine pink/purple palette with blur and `layerrule = blur,waybar`), `themes/colors.conf` (placeholder)
- `userprefs.conf` is sourced last so it can override defaults

### WSL bridge layer

- `wsl.conf` enables systemd; `.wslgconfig` sets a 120 Hz WSLg refresh rate
- `wezterm.lua` defaults to the `WSL:Ubuntu-22.04` domain
- `meld-wrapper.sh` launches Windows `meld.exe` from git
- `.zshrc` starts `syncthing.exe` and references Windows scoop shims
- `update.sh` maintains WSL-side packages

## Installation

These configs are plain copies — there is no dotfile manager or symlink/install script. Apply them by hand using the steps below.

### 0. Replace placeholders before use

- `gitconfig` — set `user.name` / `user.email` (currently `YOUR_NAME` / `your.email@example.com`)
- `.zshrc` — fill in the `YOUR_*_API_KEY` values; set `VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH` to your real Windows path
- `meld-wrapper.sh` — replace `YOUR_WINDOWS_USERNAME` with your actual Windows username

### 1. Prerequisites

Install the tools each component depends on (adjust to what you have):

```bash
sudo apt install zsh tmux neovim ripgrep fd-find bat tree git python3 nodejs npm
```

Plus user-level tools (install your preferred method):

- **oh-my-zsh** + **powerlevel10k** (or starship) — `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- **fzf**, **exa**, **delta** (git pager), **starship** — see each project's install docs
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

### 4. Optional maintenance

`update.sh` runs package updates across apt, snap, rustup, cargo, npm, and claude.

## How the pieces fit together

```
WSL bridge layer        wsl.conf · .wslgconfig · wezterm.lua · meld-wrapper.sh · update.sh
Shell / editor layer    .zshrc → exa-wrapper.sh (ls) · nvim/ (EDITOR) · .vimrc · .tmux.conf
Terminal layer          kitty.conf · wezterm.lua · alacritty.toml (parallel configs)
Wayland / desktop       hypr/ (Hyprland, split config)
Git layer               .gitconfig (delta + meld via Windows bridge)
```

Start with `.zshrc` — it is the hub that ties together the WSL environment, tmux, the exa wrapper, nvim, fzf tooling, PATH, and API keys. The `nvim/` subdirectory is the most structurally complete subsystem.

## Notes

- **No version control**: this directory has no `.git` — no history or submodules. Consider `git init` to track changes.
- **API keys in `.zshrc`** are redacted placeholders (`YOUR_*_API_KEY`) — fill them in locally
- **Git identity in `.gitconfig`** is redacted with placeholders — set `user.name` / `user.email` before committing
- **Windows user paths** in `.zshrc` (Vagrant home) and `meld-wrapper.sh` use `YOUR_WINDOWS_USERNAME` placeholder — replace with the real Windows username before use
- **Hyprland configs** (Linux-native Wayland) coexist with WSL configs; verify whether this machine dual-boots or if `hypr/` is legacy/unused.

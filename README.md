# Dotfiles

Personal configs for an **Ubuntu 24.04 WSL2-on-Windows** machine, kept here as plain copies.
There is **no dotfile manager**: nothing in this repo ever writes to `$HOME` on its own. You copy
files in by hand, or with the one-line commands below.

The repo is the backup; installing is always an explicit action you take.

## Layout

| Path | Role |
| --- | --- |
| `.zshrc` | primary shell config — the hub (oh-my-zsh, starship, PATH, tmux bootstrap) |
| `.gitconfig` | identity, delta pager, meld difftool, gh credential helper |
| `tmux.conf` | tmux config; live copy is `~/.config/tmux/tmux.conf`, with `~/.tmux.conf` symlinked to it |
| `starship.toml` | starship prompt (icon style, WSL-tuned scan timeout) |
| `exa-wrapper.sh` | `ls` shim over `exa` (optional/legacy — unmaintained, successor is `eza`) |
| `meld-wrapper.sh` | bridges git difftool/mergetool to Windows `meld.exe` via `wslpath` |
| `nvim/` | full Lua Neovim config (lazy.nvim) |
| `pi/` | restore set for `~/.pi/agent` — see below and `docs/pi-agent.md` |
| `openviking/` | config backup for `~/.openviking` + its systemd user unit |
| `extras/` | not installed by anything: Windows-side configs, `wsl.conf`, vendored `find-skills` |
| `update.sh` | system maintenance: apt, snap, rustup, cargo, npm, pi |
| `.gitignore` | blocks `.pi/` (pi's project-config dir, which fills with runtime state) |

## Install — pick only what you want

```bash
DOTFILES="$HOME/personal/dotfiles"   # or wherever you cloned it

# shell + prompt
cp "$DOTFILES/.zshrc"      ~/.zshrc
cp "$DOTFILES/starship.toml" ~/.config/starship/starship.toml

# git
cp "$DOTFILES/.gitconfig"  ~/.gitconfig

# tmux
mkdir -p ~/.config/tmux
cp "$DOTFILES/tmux.conf"   ~/.config/tmux/tmux.conf
ln -sfn ~/.config/tmux/tmux.conf ~/.tmux.conf

# neovim
mkdir -p ~/.config/nvim
cp -r "$DOTFILES/nvim/."   ~/.config/nvim/     # first launch installs plugins

# wrappers (keep them executable)
cp "$DOTFILES/exa-wrapper.sh" "$DOTFILES/meld-wrapper.sh" ~/
chmod +x ~/exa-wrapper.sh ~/meld-wrapper.sh

# pi coding agent (see docs/pi-agent.md for the full procedure)
cp -r "$DOTFILES/pi/." ~/.pi/agent/

# openviking config + user unit (then fill the blanked keys)
mkdir -p ~/.openviking ~/.config/systemd/user
cp "$DOTFILES/openviking/ov.conf" "$DOTFILES/openviking/ovcli.conf" \
   "$DOTFILES/openviking/ovcli.settings.conf" ~/.openviking/
chmod 600 ~/.openviking/ov.conf ~/.openviking/ovcli.conf
cp "$DOTFILES/openviking/openviking.service" ~/.config/systemd/user/
systemctl --user daemon-reload && systemctl --user enable --now openviking
```

## Secrets

Never committed. The repo carries them blanked; fill them in on the machine after copying.

| File | Mode | Fill in |
| --- | --- | --- |
| `~/.openviking/ov.conf` | 0600 | `server.root_api_key`, `vlm.api_key` |
| `~/.openviking/ovcli.conf` | 0600 | `api_key`, `root_api_key` |
| `~/.pi/agent/mcp.json` | — | context7 MCP server's `--api-key` |
| `~/.zshrc` | — | `OPENROUTER_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`, `CHUTES_OPENAI_API_KEY`, `MINIMAX_API_KEY` (empty strings in the repo; edit your copy directly — nothing will overwrite it) |
| `pi/settings.json` | — | no `deviceId` stored; pi generates its own |

## Refreshing the backup

The arrow only ever points `$HOME` → repo. Copy the live file over the repo copy and commit:

```bash
cp ~/.zshrc "$DOTFILES/.zshrc"
diff -q ~/.config/nvim/init.lua "$DOTFILES/nvim/init.lua"   # sanity check before committing
git add -A && git commit -m "chore: refresh from live" && git push
```

Files that rewrite themselves, so they will drift: `pi/settings.json`, `pi/AGENTS.md`
(OpenViking extension), `nvim/lazy-lock.json` (`:Lazy sync`), `~/.gitconfig` (`git config --global`).

## `extras/` — kept, never installed

| File | Where it belongs |
| --- | --- |
| `.wslconfig` | `C:\Users\<you>\.wslconfig` (mirrored networking, 9GB) — run `wsl --shutdown` after |
| `.wslgconfig` | `C:\Users\<you>\.wslgconfig` |
| `wezterm.lua` | `C:\Users\<you>\.config\wezterm\wezterm.lua` |
| `alacritty.toml` | Windows-host Alacritty config |
| `kitty.conf` | Linux-side kitty (not installed here) |
| `wsl.conf` | `/etc/wsl.conf` — needs root |
| `find-skills/` | vendored copy of the `find-skills` skill; on a machine that has `~/.agents/skills`, link it instead of copying |

## Prerequisites

`sudo apt install zsh tmux neovim git git-delta fzf ripgrep fd-find bat tree python3 nodejs npm`
plus oh-my-zsh, starship (*required* — `.zshrc` evals it unconditionally), gh (credential helper),
rbenv, and optionally exa for `exa-wrapper.sh`.

## pi agent notes

`docs/pi-agent.md` keeps the inventory of `~/.pi/agent`, the clone table with pinned SHAs, and the
restore steps.

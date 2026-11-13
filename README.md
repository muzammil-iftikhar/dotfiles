# Dotfiles

Personal configs for an **Ubuntu 24.04 WSL2-on-Windows** machine, managed with
[chezmoi](https://www.chezmoi.io). The repo is both the backup and the installer:
`chezmoi apply` copies files into place, and any single component can be installed
on its own.

```
dotfiles/                  <- this repo, also the chezmoi source directory
├── .chezmoiroot           -> "home": chezmoi only looks inside home/
├── home/                  <- the source state (target paths encoded in names)
├── extras/                <- NOT managed by chezmoi (see below)
├── docs/pi-agent.md       <- pi agent restore notes + clone SHAs
├── update.sh              <- system maintenance script
└── README.md
```

## One-time setup on a new machine

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"   # install chezmoi
export PATH="$HOME/.local/bin:$PATH"
chezmoi init --apply git@github.com:muzammil-iftikhar/dotfiles.git
```

`chezmoi init --apply` clones the repo to `~/.local/share/chezmoi` and installs
everything. To use an existing clone as the source instead, write
`~/.config/chezmoi/chezmoi.toml` (this file is per-machine and deliberately
**not** in the repo):

```toml
sourceDir = "/home/<you>/personal/dotfiles"
```

## Install one component only

Every target can be applied alone. Nothing else is touched.

| Want | Command |
| --- | --- |
| Shell + prompt | `chezmoi apply -P ~/.zshrc ~/.config/starship/starship.toml` |
| Git | `chezmoi apply -P ~/.gitconfig` |
| tmux | `chezmoi apply -P ~/.config/tmux/tmux.conf ~/.tmux.conf` |
| Neovim | `chezmoi apply -P ~/.config/nvim` |
| pi coding agent | `chezmoi apply -P ~/.pi/agent` |
| OpenViking | `chezmoi apply -P ~/.openviking ~/.config/systemd/user/openviking.service` |
| Wrappers | `chezmoi apply -P ~/exa-wrapper.sh ~/meld-wrapper.sh` |
| Everything | `chezmoi apply` |

`-P` creates missing parent directories, so these work on a machine where `~/.config`
does not exist yet. Preview without writing: `chezmoi apply --dry-run -v`, or `chezmoi diff`.

## What lives where

| Source (in `home/`) | Target | Notes |
| --- | --- | --- |
| `dot_zshrc` | `~/.zshrc` | the hub: oh-my-zsh, starship, PATH, tmux bootstrap |
| `dot_gitconfig` | `~/.gitconfig` | delta pager, meld difftool, gh credential helper |
| `dot_config/nvim/` | `~/.config/nvim/` | lazy.nvim; first launch installs plugins |
| `dot_config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | TPM plugins are cloned separately |
| `symlink_dot_tmux.conf` | `~/.tmux.conf` | symlink → `.config/tmux/tmux.conf` (relative, resolves to `~/.config/tmux/tmux.conf`) |
| `dot_config/starship/starship.toml` | `~/.config/starship/starship.toml` | icon prompt, WSL tuning |
| `dot_config/systemd/user/openviking.service` | `~/.config/systemd/user/` | user unit, no sudo |
| `dot_pi/private_agent/` | `~/.pi/agent/` | pi config + extensions; dir `0700`, `mcp.json` `0600` |
| `private_dot_openviking/` | `~/.openviking/` | dir 0700; secrets are `create_private_` files |
| `executable_exa-wrapper.sh` | `~/exa-wrapper.sh` | `ls` shim over `exa` |
| `executable_meld-wrapper.sh` | `~/meld-wrapper.sh` | meld bridge to Windows |

Two scripts run after `chezmoi apply` writes their inputs (only when their own
contents change): `run_onchange_after_pi-node-deps.sh` (`npm ci` for the three pi
trees that ship a lockfile) and `run_onchange_after_openviking-service.sh`
(`systemctl --user enable --now openviking`).

## Secrets

Files that hold API keys are declared `create_` / `create_private_`, which means
chezmoi **creates them if absent and never overwrites them afterwards**. The repo
carries them with the keys blanked:

| File | Mode | Fill in |
| --- | --- | --- |
| `~/.openviking/ov.conf` | 0600 | `server.root_api_key`, `vlm.api_key` (VLM provider) |
| `~/.openviking/ovcli.conf` | 0600 | `api_key`, `root_api_key` |
| `~/.pi/agent/mcp.json` | 0600 | context7 MCP server's `--api-key` |

On a fresh machine those files are created blank; fill them once. Fill in the
`.zshrc` key exports (`OPENROUTER_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`,
`CHUTES_OPENAI_API_KEY`, `MINIMAX_API_KEY`) the same way — they are empty strings
in the repo. `pi/settings.json` deliberately stores no `deviceId`; pi regenerates it.

## On this machine: never run `chezmoi apply`

This machine is the source of truth for the repo. `chezmoi apply` writes **repo → `$HOME`**
and overwrites live files, so it is not part of the daily flow here. On this machine the
arrow points the other way:

```bash
chezmoi re-add ~/.zshrc ~/.pi/agent/settings.json   # machine -> repo
chezmoi status                                      # what still differs
git add -A && git commit && git push                # publish
```

`chezmoi apply` is for a **new machine**, or for deliberately resetting one file to the repo
version. To test the target state without touching anything real:

```bash
chezmoi apply --destination /tmp/test-home          # throwaway home
```

## Keeping it up to date

```bash
chezmoi status            # what differs between repo and machine
chezmoi diff              # the actual differences
chezmoi re-add ~/.zshrc   # pull a file you edited live back into the repo
chezmoi update            # git pull + apply
chezmoi cd                # shell in the source dir, then git commit/push
```

`chezmoi status` being silent means the repo and this machine are identical; `chezmoi verify`
exits non-zero if anything differs, and `chezmoi doctor` checks the setup itself.

If you edited a managed file live and meant it, `chezmoi re-add <path>` pulls it into the repo.
If you meant to discard the edit, `chezmoi apply --force <path>` (plain `apply` stops and asks,
which fails in a script or an agent shell).

## `extras/` — not managed

Kept in the repo for reference, never applied by chezmoi:

| File | Where it belongs |
| --- | --- |
| `.wslconfig` | `C:\Users\<you>\.wslconfig` (mirrored networking, 9GB) |
| `.wslgconfig` | `C:\Users\<you>\.wslgconfig` (WSLg refresh rate) |
| `wezterm.lua` | `C:\Users\<you>\.config\wezterm\wezterm.lua` |
| `alacritty.toml` | Windows-host Alacritty config |
| `kitty.conf` | Linux-side kitty (kitty not installed here) |
| `find-skills/` | vendored copy of the `find-skills` skill; `~/.pi/agent/skills/find-skills` is a symlink into `~/.agents/skills`, so chezmoi must not own it |
| `wsl.conf` | `/etc/wsl.conf` — needs root, so not managed |

After changing `.wslconfig` / `.wsl.conf`, run `wsl --shutdown` from Windows.

## Prerequisites

`sudo apt install zsh tmux neovim git git-delta fzf ripgrep fd-find bat tree python3 nodejs npm`
plus oh-my-zsh, starship (*required* — `.zshrc` evals it unconditionally), gh
(credential helper), rbenv, and optionally exa (unmaintained) for `exa-wrapper.sh`.

## pi agent notes

`docs/pi-agent.md` keeps the inventory of `~/.pi/agent`, the clone table with
pinned SHAs, and the notes on what is deliberately excluded (sessions, installs,
caches, credentials).

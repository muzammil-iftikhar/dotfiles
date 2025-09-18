# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zshrc.pre.zsh"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Tmux script
if [ -z $TMUX ]; then
  # Check if 'syncthing' session exists
  if ! tmux has-session -t syncthing 2>/dev/null; then
    # Create session and run command inside it
    tmux new-session -d -s syncthing -n syncthing "syncthing.exe serve --no-browser"
  else
    # Run command in existing session without attaching
    tmux send-keys -t syncthing "syncthing.exe serve --no-browser" C-m
  fi

  # Check if 'default' session exists
  if ! tmux has-session -t default 2>/dev/null; then
    # Create and attach to 'default' session
    tmux new-session -s default
  else
    # Attach to existing 'default' session
    tmux attach-session -t default
  fi
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="sorin" # set by `omz`
# Available themes
# powerlevel10k/powerlevel10k
# robbyrussell
# gozilla

SPACESHIP_PROMPT_ORDER=(
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  python
  golang
  # rust
  lua
  docker
  docker_compose
  # aws
  # gcloud
  # azure
  # venv
  kubectl
  ansible
  terraform
  exec_time     # Execution time
  line_sep      # Line break
  char          # Prompt character
)

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting ubuntu fzf zsh-z sudo copyfile jsontools copybuffer docker fancy-ctrl-z dirhistory extract kubectl copypath command-not-found colored-man-pages terraform tmux)

# Set zsh-autosuggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=166"

source $ZSH/oh-my-zsh.sh

# Set zsh completions for gh-copilot extension
eval "$(gh copilot alias -- zsh)"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# --------------------------------------------------Env Variables Start--------------------------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
FZF_BASE="$HOME/.fzf"
export ZSHZ_UNCOMMON=1

# Fzf env variables
export FZF_DEFAULT_COMMAND="fd -t f --color=never --hidden"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
export FZF_ALT_C_COMMAND="fd -t d . --color=never --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
export FZF_DEFAULT_OPTS="--no-height --color=bg+:#343d46,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b"

export EDITOR=nvim
export XDG_CONFIG_HOME="$HOME/.config"

# Write all buffers before navigating from Vim to tmux pane
export TMUX_NAVIGATOR_SAVE_ON_SWITCH=2

# Ai env variables
export OPENROUTER_API_KEY=""
export OPENAI_API_KEY=""
export OLLAMA_API_KEY=Ollama
export ANTHROPIC_API_KEY=""
export GEMINI_API_KEY=""
export CHUTES_OPENAI_API_KEY=""

# Vagrant wsl env variables
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/Users/Muzammil Iftikhar/Desktop/virtual machines"

export PATH=$PATH:$HOME/go/bin:$HOME/.local/bin:"/mnt/c/Program Files/Oracle/VirtualBox":$HOME/.yarn/bin:$HOME/.rvm/bin:$GOPATH/bin:$HOME/.npm-global/bin:$HOME/.local/bin:/snap/bin:"/mnt/c/Windows/System32":"/mnt/c/Users/Muzammil Iftikhar/AppData/Local/Microsoft/WindowsApps/Microsoft.PowerShell_8wekyb3d8bbwe":$HOME/.local/share/nvim/mason/bin:$HOME/.rbenv/bin

# --------------------------------------------------Env Variables End--------------------------------------------------

# --------------------------------------------------Alias Start--------------------------------------------------
if command -v exa >/dev/null; then
    alias ls=~/exa-wrapper.sh
else
    alias ls='/bin/ls $LS_OPTIONS'
fi

alias nv='nvim'
# --------------------------------------------------Alias End--------------------------------------------------

# Enable terraform autocompletion
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/bin/terraform terraform

# For cargo
. "$HOME/.cargo/env"

# For ruby-rbenv
eval "$(rbenv init - zsh)"

# For startship prompt
export STARSHIP_CONFIG=/home/muzammil/.config/startship/starship.toml
eval "$(starship init zsh)"

fastfetch

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/amazon-q/shell/zshrc.post.zsh"

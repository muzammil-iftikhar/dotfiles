# Start tmux automatically if not already inside a tmux session
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic" # set by `omz`
# Available themes
# powerlevel10k/powerlevel10k
# robbyrussell
# gozilla
# spaceship

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
plugins=(git zsh-256color zsh-autosuggestions fzf zoxide sudo copyfile jsontools copybuffer docker fancy-ctrl-z dirhistory extract kubectl copypath command-not-found colored-man-pages terraform tmux)

# Set zsh-autosuggestion color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=166"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# fzf settings

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
FZF_BASE="$HOME/.fzf"
export ZSHZ_UNCOMMON=1
export FZF_DEFAULT_COMMAND="fd -t f --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :50 {}'"
export FZF_ALT_C_COMMAND="fd -t d . --color=never --hidden --strip-cwd-prefix --exclude .git"
export FZF_ALT_C_OPTS="--preview 'exa --tree --color=always {} | head -200'"
export FZF_DEFAULT_OPTS="--no-height --color=bg+:#343d46,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'exa --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# Bat default theme
# export BAT_THEME=tokyonight_night

export EDITOR=nvim

#aliases
if command -v exa >/dev/null; then
    alias ls=~/exa-wrapper.sh
else
    alias ls='/bin/ls $LS_OPTIONS'
fi

alias nv=nvim
alias snv='sudo -E -s nvim'
alias lg=lazygit
# end aliases

# Write all buffers before navigating from Vim to tmux pane
export TMUX_NAVIGATOR_SAVE_ON_SWITCH=2

export OPENAI_API_KEY=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

# vagrant settings for wsl
# export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
# export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/Users/muzam/OneDrive/Desktop/vagrant"

export VAGRANT_HOME="/home/muzammil/data/vagrant/.vagrant.d"
export VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1
export VAGRANT_DEFAULT_PROVIDER=libvirt
export CONFIGURE_ARGS="with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib64"

# ruby
export GEM_HOME="$(gem env user_gemhome)"

# rio terminal
export COLORTERM=truecolor

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

# Golang environment variables
export GOPATH=/home/muzammil/data/golang

# cmd.exe and pwsh.exe were added for vagrant
export PATH=/usr/local/go/bin:$HOME/.local/bin:"/mnt/c/Program Files/Oracle/VirtualBox":$HOME/.yarn/bin:$HOME/.rvm/bin:$GOPATH/bin:$HOME/.npm-global/bin:$HOME/.local/bin:/snap/bin:"/mnt/c/Windows/System32":"/mnt/c/Users/muzam/AppData/Local/Microsoft/WindowsApps/Microsoft.PowerShell_8wekyb3d8bbwe":$GEM_HOME/bin:$PATH
export scrPath=/home/muzammil/.local/share/bin

# For cargo
#. "$HOME/.cargo/env"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(zoxide init zsh)"

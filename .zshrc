# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="" # set by `omz`
# Available themes
# powerlevel10k/powerlevel10k
# robbyrussell
# gozilla
# sorin

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

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Open buffer line in nvim by pressing ctrl+x ctrl+e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# --------------------------------------------------Env Variables Start--------------------------------------------------
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
# export ANTHROPIC_API_KEY=""
export MAX_MCP_OUTPUT_TOKENS=50000 # This is for the claude code cli
export GEMINI_API_KEY=""
export CHUTES_OPENAI_API_KEY=""
export MINIMAX_API_KEY=""

# Vagrant wsl env variables
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/Users/Muzammil Iftikhar/Desktop/virtual machines"

# for viafone project
export KUBECONFIG="$HOME/.kube/agentos-dev"
export AZURE_CORE_COLLECT_TELEMETRY=false

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

# For ruby-rbenv
eval "$(rbenv init - zsh)"

# For starship prompt
export STARSHIP_CONFIG=/home/muzammil/.config/starship/starship.toml
eval "$(starship init zsh)"

# starship: show kubernetes context/namespace only while you need it
k8son() { export STARSHIP_K8S=1; }
k8soff() { unset STARSHIP_K8S; }

# bun completions
[ -s "/home/muzammil/.bun/_bun" ] && source "/home/muzammil/.bun/_bun"

# -------------------------------------------------- Build PATH --------------------------------------------------
pathadd() {
  case ":$PATH:" in
    *":$1:"*) ;; # already exists
    *) PATH="$1:$PATH" ;;
  esac
}
pathadd "$HOME/.local/bin"
pathadd "$HOME/.yarn/bin"
pathadd "$HOME/.rvm/bin"
pathadd "$HOME/.local/share/nvim/mason/bin"
pathadd "$HOME/.rbenv/bin"
pathadd "$HOME/.npm-global/bin"
pathadd "/snap/bin"
pathadd "/mnt/c/Users/muzam/scoop/shims"
pathadd "/mnt/c/Users/muzam/scoop/apps/vscode/current/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
pathadd "$BUN_INSTALL/bin"

# JAVA_HOME
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
pathadd "$JAVA_HOME/bin"
# -------------------------------------------------- Build PATH END ------------------------------------------------

alias claude-mem='/home/muzammil/.bun/bin/bun "/home/muzammil/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

#-------------------------------------------------- Nvm Init--------------------------------------------------  
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#-------------------------------------------------- Nvm Init End--------------------------------------------------  

#-------------------------------------------------- Tmux--------------------------------------------------  
if [[ -z "$TMUX" ]]; then
  tmux new-session -A -s default
fi
#-------------------------------------------------- Tmux End--------------------------------------------------  

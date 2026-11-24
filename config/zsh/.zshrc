# ~/.zshrc — managed by ~/setup-i3-environment (machine-specific stuff: ~/.zshrc.local)

# --- PATH --------------------------------------------------------------
typeset -U path
path=("$HOME/.local/bin" $path)

# --- History -----------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS EXTENDED_HISTORY

# --- Options -----------------------------------------------------------
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS INTERACTIVE_COMMENTS EXTENDED_GLOB NO_BEEP

# --- Completion --------------------------------------------------------
autoload -Uz compinit && compinit -d ~/.cache/zcompdump
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'

# --- Key bindings (emacs style) -----------------------------------------
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search     # Up: history matching typed prefix
bindkey '^[[B' down-line-or-beginning-search   # Down
bindkey '^[[1;5C' forward-word                 # Ctrl+Right
bindkey '^[[1;5D' backward-word                # Ctrl+Left
bindkey '^[[H' beginning-of-line               # Home
bindkey '^[[F' end-of-line                     # End
bindkey '^[[3~' delete-char                    # Delete
bindkey '^H' backward-kill-word                # Ctrl+Backspace

# --- Aliases -----------------------------------------------------------
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first'
  alias ll='eza -lh --group-directories-first --git'
  alias la='eza -lah --group-directories-first --git'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lAh'
fi
command -v batcat >/dev/null && alias bat='batcat'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y'
export BAT_THEME="ansi"

# --- Tools -------------------------------------------------------------
command -v fzf >/dev/null && source <(fzf --zsh)          # Ctrl+R history, Ctrl+T files, Alt+C cd
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=rounded \
  --color=bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,hl:#89b4fa,hl+:#89b4fa,prompt:#89b4fa,pointer:#f38ba8,marker:#a6e3a1,info:#7f849c,border:#89b4fa"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"  # z <dir>, zi (interactive)
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- Plugins (syntax highlighting must be last) --------------------------
[[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f849c'
bindkey '^ ' autosuggest-accept                 # Ctrl+Space: accept suggestion

[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Go configuration
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Added by Antigravity CLI installer
export PATH="/home/someone/.local/bin:$PATH"

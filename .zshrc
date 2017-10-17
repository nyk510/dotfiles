# プロンプト表示名
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'
PROMPT=$'\n'$GREEN'%n '$YELLOW'%~ '$'\n'$DEFAULT'%(!.#.$) '

# 履歴
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history
setopt auto_pushd
setopt pushd_ignore_dups


#lsの色付け
export LSCOLORS=gxfxcxdxbxegedabagacad
alias ls='ls -aG'

#かっこいい補完を導入する
#source .zsh/plugin/incr*.zsh
#大文字小文字の区別をなしにする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


# 補完
autoload -U compinit
compinit
zstyle ':completion:*' list-colors ''

alias gsed='/usr/local/Cellar/gnu-sed/4.2.2/bin/gsed'
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.seleniumdriver:$PATH"
export PATH=$PATH:./node_modules/.bin

eval "$(pyenv init -)"
eval "$(rbenv init -)"

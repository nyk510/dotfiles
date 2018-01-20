# プロンプト表示名
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'

# PROMPT=$'\n'$GREEN'%n '$YELLOW'%~ '$'\n'$DEFAULT'%(!.#.$) '
PROMPT='[%n@%m %~]
%(!.#.$) '

export PATH=$PATH:~/peco_linux_amd64

# 履歴
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups
setopt share_history
setopt auto_pushd
setopt pushd_ignore_dups


#lsの色付け
export LSCOLORS=gxfxcxdxbxegedabagacad

case "${OSTYPE}" in
darwin*)
  alias ls="ls -G"
  alias ll="ls -lG"
  alias la="ls -laG"
  ;;
linux*)
  alias ls='ls --color'
  alias ll='ls -l --color'
  alias la='ls -la --color'
  ;;
esac

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

peco-select-history()
{
    # peco があるかないかで分岐する
    # なければ違うアプローチをする
    if type "peco" >/dev/null 2>&1; then
        BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
        CURSOR=${#BUFFER}

        # peco で選んでる最中に Enter を押した瞬間実行する
        zle accept-line
        # 画面をクリアする
        zle clear-screen
    else
        # バージョンによって条件分岐するために使用するモジュールを開放する
        autoload -Uz is-at-least

        # 4.3.9 以降ではインクリメンタルパターンサーチが出来るので、それを利用する
        # なければデフォルトでマッピングされているものを利用する
        if is-at-least 4.3.9; then
            # zsh -la <widget> とすることで、widget に完全一致するウィジェットが
            # 存在する場合、返却値 0 で終了する
            zle -la history-incremental-pattern-search-backward && bindkey "^r" history-incremental-pattern-search-backward
        else
            history-incremental-search-backward
        fi
    fi
}

zle -N peco-select-history
bindkey '^R' peco-select-history

# git の状態を表示する
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$HOME/.seleniumdriver:$PATH"
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$HOME/.PyCharm2017.2/bin

# 依存関係のある環境変数は .zshrc に記述せず .localrc に
source ~/.localrc
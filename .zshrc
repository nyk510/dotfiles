export LANG=ja_JP.UTF-8

# run environment-dependent shell 
# like .pyenv path and so on :)
LOCALRC=~/.localrc
if [ -e $LOCALRC ]
then
    source $LOCALRC
fi

# zplug settings:
# --------------

export ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Additional completion definitions for Zsh
zplug "zsh-users/zsh-completions"
zplug "esc/conda-zsh-completion"

# zsh-syntax-highlighting must be loaded after
# excuting compinit command and sourcing other plugins.
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "zsh-users/zsh-history-substring-search", defer:3

# If this module is used in conjuncture with the syntax-highlighting module, it must be loaded after it.
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:3

# This ZSH plugin enhances the terminal environment with 256 colors.
zplug "chrissicool/zsh-256color"

zplug "plugins/git", from:oh-my-zsh
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto

# インタラクティブフィルタ
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

# Use spaceship prompt: https://github.com/denysdovhan/spaceship-prompt
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# zplug の読み込み
zplug load
alias gsed='/usr/local/Cellar/gnu-sed/4.2.2/bin/gsed'


# zsh settings:
# -----------------------

setopt auto_list             # 補完候補が複数ある時に、一覧表示
setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示

setopt print_eight_bit
setopt extended_glob
setopt globdots
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

#---------------------------------------------------------------------------
# Alias
#---------------------------------------------------------------------------

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

alias pd="pushd"
alias po="popd"
alias gd='dirs -v; echo -n "select number: "; read newdir; cd +"$newdir"'
alias gip='curl ipcheck.ieserver.net'

alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'

zle -N select-history

# use emacs key bind
# for `control + A` or `control + E`
bindkey -e


peco-select-history()
{
    # peco があるかないかで分岐する
    # なければ違うアプローチをする
    if type "peco" >/dev/null 2>&1; then
        BUFFER=$(history 1 | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$LBUFFER")
        CURSOR=${#BUFFER}
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
bindkey '^r' peco-select-history
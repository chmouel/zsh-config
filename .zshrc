#!/usr/bin/zsh
# Chmouel Boudjnah <chmouel@chmouel.com>

confdir=$HOME/.shell
[[ -d ${confdir} ]] || confdir=$HOME/.config/zsh
basehost=${HOST%%.*}
[[ $1 == 'reloading' ]] && reload=yes

autoload -U colors;colors

# We need that first
setopt nonomatch

#Local functions we want to autoload
typeset -U fpath
user_fun_path=($confdir/functions $confdir/functions/hosts/${basehost});
fpath=($user_fun_path $fpath); autoload -U compinit
for func ($user_fun_path) autoload -U $func/*(x:t)
for func ($user_fun_path/*) [[ ${func} == *.source ]] && source ${func}

# get environement and alias
[[ -f $confdir/config/environement ]] && source $confdir/config/environement
[[ -f $confdir/config/alias ]] && source $confdir/config/alias
[[ -f $confdir/hosts/$basehost.sh ]] && source $confdir/hosts/$basehost.sh

# Get zplug if it exists first
[[ -z ${reload} ]] && {
    (( ! $+functions[zplug] )) && [[ -e $HOME/.zplug/init.zsh ]] && {
        source $HOME/.zplug/init.zsh
    }
    (( $+functions[zplug] )) && source $confdir/config/packages.zsh
}


#Compinit
[[ -z $reload ]] && compinit -i

#PS1
if [[ -z $CUSTOM_PROMPT ]];then
    autoload -U promptinit
    promptinit
    prompt chmou ${userColor}
fi

#Considers only alphanumeric as work like in bash
autoload -U select-word-style
select-word-style bash

# edit-command-line
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Path
typeset -U path
path=($HOME/bin /usr/local/bin /usr/local/sbin /usr/sbin /sbin $path)

#History Settings
HISTFILE="${confdir}/cache/zsh_history"
HISTSIZE="5000000"
SAVEHIST="5000000"
export HISTSIZE HISTSIZE SAVEHIST

setopt extended_history hist_ignore_all_dups \
       append_history hist_ignore_dups hist_ignore_space \
       hist_reduce_blanks hist_save_no_dups histverify nohistbeep \
       nohistignorespace

zmodload -i zsh/complist
setopt auto_list # automatically list choices on ambiguous completion
setopt no_auto_menu # do not automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

(( $+commands[on_ac_power] )) && on_ac_power && setopt inc_append_history

#setopt
setopt nobeep COMPLETE_IN_WORD CORRECT EXTENDED_GLOB \
       AUTO_CD noFLOW_CONTROL AUTO_PUSHD noCompleteinword \
       interactivecomments nopromptcr alwaystoend

#Ignore stuff starting by _ for the completion.
export CORRECT_IGNORE="_*"

#cache completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $confdir/cache

#Completion style
zstyle ':completion:*' special-dirs true

# Completion menu
zstyle ':completion:*' menu select

# Ignore completion functions for commands you don’t have
zstyle ':completion:*:functions' ignored-patterns '_*'

#Auto quote URL
autoload -U bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# GIT support
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:*' unstagedstr '%F{red}*'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats '[%F{7}%b%f]'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$fg[cyan]%}%b%{$reset_color%}%m%u%c%{$reset_color%}"

# Kill support  https://github.com/zsh-users/zsh-completions/issues/93#issuecomment-8311702
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'NOCOLORS=1 ps -U $(whoami)|sed "/ps/d"'
zstyle ':completion:*:processes' insert-ids menu yes select
zstyle ':completion:*:processes-names' command 'NOCOLORS=1 ps xho command|sed "s/://g"'
zstyle ':completion:*:processes' sort false

#Keys
stty -ixon #disable c-q c-s
bindkey -e
bindkey -s '^Xd' "\`date '+%Y%m%d'\`\t" #`"
bindkey -s "^Xs" "^p^asudo ^e"
# M-# comment current line
bindkey '^[#' pound-insert

# Bind control-left/right properly
[[ -n ${terminfo[kLFT5]}  ]] && bindkey -- "${terminfo[kLFT5]}"  backward-word
[[ -n ${terminfo[kRIT5]}  ]] && bindkey -- "${terminfo[kRIT5]}"  forward-word
[[ -n ${terminfo[Home]}  ]] && bindkey -- "${terminfo[Home]}" beginning-of-line

#Ala emacs
zmodload -i zsh/deltochar
bindkey -e "^[z" zap-to-char

(( $+commands[dircolors] )) && _dircolors=dircolors
(( $+commands[gdircolors] )) && _dircolors=gdircolors
[[ -n ${_dircolors} &&  -z $LS_COLORS ]] && eval $(${_dircolors} -b) && \
export LS_COLOR="${LS_COLORS}:*.pyc=01;30" && \
zstyle ":completion:*" list-colors ${(s.:.)LS_COLORS}

#on ssh-copy-id compile user-at-host
compdef _user_at_host ssh-copy-id

# load zplugs
[[ -z ${reload} ]] && which zplug 2>/dev/null >/dev/null && { zplug check || zplug install; zplug load ; }

# load conifg
[[ -f $confdir/hosts/${basehost}-post.sh ]] && source $confdir/hosts/${basehost}-post.sh

#Unsetting
unset basehost confdir func user_fun_path reload _dircolors

# Emacs Tramp
if [[ "$TERM" = "dumb" ]];then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    prompt off
fi

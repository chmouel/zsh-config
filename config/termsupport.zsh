# GIT support
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:*' unstagedstr '%F{red}*'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats       '[%F{7}%b%f]'
zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:git*' formats "%{$fg[red]%}%m%c%u%{$reset_color%}[%{$fg[magenta]%}%b%{$reset_color%}]%{$reset_color%}"
zstyle ':vcs_info:git*' formats "%{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%}"


# Show untracked file
#zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
#+vi-git-untracked(){
#    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
#        git status --porcelain | grep '??' &> /dev/null ; then
#        hook_com[staged]+='T'
#    fi
#}

#usage: title short_tab_title looooooooooooooooooooooggggggg_windows_title
#http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
#Fully support screen, iterm, and probably most modern xterm and rxvt
#Limited support for Apple Terminal (Terminal can't set window or tab separately)
function title {
  CMD=$1
  [ "$DISABLE_AUTO_TITLE" != "true" ] || return
  [[ -n $SSH_CLIENT ]] && CMD="%n: ${CMD}"
  if [[ "$TERM" == screen* ]]; then
    print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
  elif [[ "$TERM" == xterm* ]] || [[ $TERM == rxvt* ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$CMD:q\a" #set icon (=tab) name (will override window name on broken terminal)
  fi
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%12<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

#Appears when you have the prompt
function precmd {
    if [[ -n ${CUSTOM_PROMPT} ]];then
        return
    fi

    vcs_info

    export RPROMPT="${vcs_info_msg_0_}${EXTRA_PROMPT}"
}

#Appears at the beginning of (and during) of command execution
function preexec {
  emulate -L zsh
  setopt extended_glob
  local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
  [[ -n $SSH_CLIENT ]] && CMD="%n@%m: ${CMD}"
  #title "$CMD" "%100>...>$2%<<"
}

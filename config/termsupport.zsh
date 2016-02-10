# GIT support
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:*' unstagedstr '%F{red}*'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats       '[%F{7}%b%f]'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$reset_color%}%{$fg[red]%}%u%{$reset_color%}[%{$fg[magenta]%}%b%{$reset_color%}]%{$reset_color%}"

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
    local venv
    #title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE

    if [[ -n ${CUSTOM_PROMPT} ]];then
        return
    fi
    git ls-files --other --exclude-standard 2> /dev/null >/dev/null
    reply=$?

    venv="[%{$fg_bold[yellow]%}${VIRTUAL_ENV##*/}%{$reset_color%}]"

    if [[ -n ${OPENSHIFT_PROMPT} ]];then
        eval $(oc config view -o json|python -c "import sys, json;x=json.load(sys.stdin);c=x['current-context']; print ' '.join([('_oc_namepsace='+lo['context']['namespace'],'_oc_cluster='+lo['context']['cluster'],'_oc_user='+lo['context']['user'].split('/')[0]) for lo in x['contexts'] if lo['name'] == c][0])")
    export OPENSHIFT_PROMPT="(%B$_oc_namepsace/${_oc_user}/${_oc_cluster}%b)"
    fi
    
    if [[ $reply == 0 ]];then
        vcs_info
        export RPROMPT=${vcs_info_msg_0_}${VIRTUAL_ENV+$venv}${OPENSHIFT_PROMPT}
    else
        export RPROMPT="${VIRTUAL_ENV+$venv}${OPENSHIFT_PROMPT}"
    fi
}

#Appears at the beginning of (and during) of command execution
function preexec {
  emulate -L zsh
  setopt extended_glob
  local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
  [[ -n $SSH_CLIENT ]] && CMD="%n@%m: ${CMD}"
  #title "$CMD" "%100>...>$2%<<"
}

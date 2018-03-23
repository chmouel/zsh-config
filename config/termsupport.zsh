# GIT support
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:*' unstagedstr '%F{red}*'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats       '[%F{7}%b%f]'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%}"

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
	local buildp
    [[ -n ${CUSTOM_PROMPT} ]] && return
    vcs_info
	buildp=${vcs_info_msg_0_}
	[[ -n ${EXTRA_PROMPT} ]] && buildp+="%B%F{yellow}|%F{normal}${EXTRA_PROMPT}"
	[[ -n ${buildp} ]] && export RPROMPT="${buildp}"
}

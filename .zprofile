if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 && -f ~/.xsession ]]; then
    source ~/.xsession
    exec sway 2>&1 >/tmp/.sway.start
fi

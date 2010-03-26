#compdef vpnc-connect
local cmds
cmds=($(sudo ls /etc/vpnc/|grep .conf|sed 's/.conf//'))
_sub_commands $cmds

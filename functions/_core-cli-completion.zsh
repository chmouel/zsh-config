#compdef core-cli
# -a ACCOUNT
# -c
# --generate-xml=
# --generate-html=

SQLITE=$(which sqlite3 || which sqlite)
    
_core-cli_profiles () {
    local ret=1

    if [[ ! -d ${HOME}/.core-cli/profile.d ]];then
        return $ret
    fi
    
    profiles=( ${HOME}/.core-cli/profile.d/*(:r:t) )
    compadd "$expl[@]" -a profiles && ret=0
    return $ret
}

_core-cli_server_hostname () {
    local ret=1

    if [[ -z ${SQLITE} ]];then
        return $ret
    fi
    
    servers=( $( python -m core.cache ) )
    
    compadd -l "$expl[@]" -a servers && ret=0
    return $ret
}

_core-cli_tickets () {
    local ret=1

    if [[ -z ${SQLITE} ]];then
        return $ret
    fi

    tickets=( $( ${SQLITE} ~/.core-cli/cache/cache.sqlite \
        "select id from object_caching where type='ticket'" ) )
    
    compadd -l "$expl[@]" -a tickets && ret=0
    return $ret
}

_core-cli_server_hostname_tickets() {
    _alternative 'hostnames:hostname:_core-cli_server_hostname' 'tickets:ticket:_core-cli_tickets'
}


_core-cli_account () {
    local ret=1

    if [[ -z ${SQLITE} ]];then
        return $ret
    fi

    accounts=( $(${SQLITE} ~/.core-cli/cache/cache.sqlite "select id from object_caching where type='account'") )
    compadd "$expl[@]" -a accounts && ret=0
    return $ret
}

_core-cli() {
    _arguments -C ${(P)args} \
        '(-v --version)'{-v,--version}'[display core-cli version]' \
        '(-h --help)'{-h,--help}'[show help]' \
        '(-i --information)'{-i,--information}'[show information]' \
        '(-N --no-cache)'{-N,--no-cache}'[do not access any cache]' \
        '(-M --list-myticket)'{-M,--list-myticket}'[List tickets in your queue]' \
        '(-Q --list-queue)'{-Q,--list-queue}'[List the team tickets queue]' \
        '(-o --last-one=)'{-o,--last-one=}'[Connect to last server number you were connecting by number]:enable:' \
        '(-I --detailled-information)'{-I,--detailled-information}'[Show detailled information]' \
        '(-L --list-history)'{-L,--list-history}'[ListHistory]' \
        '(-P --profile=)'{-P=,--profile=}'[Connect to profile]:core-cli profiles: _core-cli_profiles' \
        '(-a --account=)'{-a,--account=}'[Connect to account]:core-cli accounts: _core-cli_account' \
        '--server2ip[Convert server number to IP]' \
        '--cluster-ssh[Connect with Cluster SSH]' \
        '--rss[Output Queues as XML RSS2 feed]' \
        '--script-no-copy[Do not copy script on the server but execute assuming it there]' \
        '--list-profile[List available profile]' \
        '--ins[Display INS viewer information]' \
        '--debug[Add debug information]' \
        '--cleanup[Cleanup old entries]' \
        '--list-accounts[List Accounts you have from your cache]' \
        '--list-tickets[List Tickets you have from your cache]' \
        '--create-profile[Create a profile]' \
        '--runme-as-root-i-know-what-i-do-i-am-not-a-morron[Execute script as root]' \
        '--sku[Show SKU information when using with -i or -I.]' \
        '--networking[Show Networking information when using with -i or -I.]' \
        '--remote-information[Add Remote information from the server (ie: networking)]' \
        '--generate-html=[Generated html file]:directory:_files -g \*.html  -/' \
        '--generate-rst=[Generated rst file]:directory:_files -g \*.rst -/' \
        '--generate-xml=[Generated xml file ]:directory:_files -g \*.xml  -/' \
        '--edit-profile=[Edit Profile]:core-cli profiles: _core-cli_profiles' \
        '(-s --script=)'{-s,--script=}'[Execute a script]:directory:_files -/' \
        '(-c --copy)'{-c,--copy}'[Copy Scripts]:directory:_files -/' \
        ':core-cli servers:_core-cli_server_hostname_tickets' \
        && return
}

_core-cli "$@"
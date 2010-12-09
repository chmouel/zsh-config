#compdef euca-describe-instances euca-terminate-instances euca-get-console-output

_instances  () {
    compadd ${(M)${$(euca-describe-instances)}##i-*}
}

_instances $@

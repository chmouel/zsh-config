
install_packages() {
    local packages=(
        agkozak/zsh-z
        zsh-users/zsh-autosuggestions
        trystan2k/zsh-tab-title
        chmouel/chmoujump
    )
    local base_url=https://github.com
    local cache_dir=${ZDOTDIR}/cache/repos/
    local p
    for p in ${packages[@]};do
        local dirname=${p%%/*}
        local basename=${p##*/}
        local plugin=${cache_dir}/${p}/${basename}.plugin.zsh
        local url=${base_url}/${p}
        
        [[ -d ${cache_dir}/${p} ]] || {
            echo -e "plugin clone from ${url}"
            mkdir -p ${cache_dir}/${dirname}
            git clone --depth=1 ${url} ${cache_dir}/${p}
        }
        [[ -e ${plugin} ]] && source ${plugin}
    done
}

install_packages

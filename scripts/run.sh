#! /bin/sh

# Function to run and find all dependencies
install_dependencies () {
    echo "==== Step 1: Install Dependencies ===="
    if apk add --no-cache \
            bc \
            coredns \
            grep \
            iproute2 \
            iptables \
            iptables-legacy \
            ip6tables \
            iputils \
            kmod \
            libcap-utils \
            libqrencode-tools \
            net-tools \
            openresolv \
            wireguard-tools; then
        return 0
    else
        return 1
    fi
}

# Add Wireguard to module
add_wireguard_to_module () {
    echo "==== Step 2: Add Wireguard to module ===="
    if echo "wireguard" >> /etc/modules; then
        return 0
    else
        return 1
    fi
    
}

# Rewrite IP Tables to Legacy
rewrite_ip_tables_to_legacy () {
    echo "==== Step 3: Rewrite IP Tables to Legacy ===="
    if cd /sbin && \
        for i in ! !-save !-restore;
        do \
            rm -rf iptables$(echo "${i}" | cut -c2-) && \
            rm -rf ip6tables$(echo "${i}" | cut -c2-) && \
            ln -s iptables-legacy$(echo "${i}" | cut -c2-) iptables$(echo "${i}" | cut -c2-) && \
            ln -s ip6tables-legacy$(echo "${i}" | cut -c2-) ip6tables$(echo "${i}" | cut -c2-); \
        done; then
        return 0
    else
        return 1
    fi
}

#Rewrite Wireguard Config
rewrite_wireguard_config () {
    echo "==== Step 4: Rewrite Wireguard Config ===="
    if sed -i 's|\[\[ $proto == -4 \]\] && cmd sysctl -q net\.ipv4\.conf\.all\.src_valid_mark=1|[[ $proto == -4 ]] \&\& [[ $(sysctl -n net.ipv4.conf.all.src_valid_mark) != 1 ]] \&\& cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1|' /usr/bin/wg-quick && \
        rm -rf /etc/wireguard && \
        ln -s /config/wg_confs /etc/wireguard ; then
        return 0
    else
        return 1
    fi
}

# Clean up Temporary Folder
clean_temp () {
    echo "==== Step 5: Clean up Process ===="
    if rm -rf /tmp/*; then
        return 0
    else
        return 1
    fi
}

# Execution
{
    install_dependencies &&\
    add_wireguard_to_module &&\
    rewrite_ip_tables_to_legacy &&\
    rewrite_wireguard_config &&\
    echo "Longengie.com version: ${VERSION} Build-date: ${BUILD_DATE}" &&\
    printf "Longengie.com version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version
} || {
    echo "Building process have error! && Start clean up!"
}
clean_temp
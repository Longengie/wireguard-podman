#! /bin/sh

# This shell script use for quick build image on the platform
build_date=$(date +"%Y-%m-%d")
version=1.0.$(date +"%Y%m%d")
platform=$(arch)
dist_repository='http://dl-cdn.alpinelinux.org/alpine/v3.20/main/'
dist_repository_package='wireguard-tools'

wireguard_version=$(curl -sL "${dist_repository}${platform}/APKINDEX.tar.gz" | tar -xz -C /tmp &&\
awk '/^P:'"${dist_repository_package}"'$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://')

# Workaroud for system both 86 and 64 bit
if [[ $platform == 'x86_64' ]]; then platform='amd64'; fi;

podman build \
    --build-arg BUILD_DATE="${build_date}" \
    --build-arg VERSION="${version}" \
    --build-arg WIREGUARD_RELEASE="${wireguard_version}" \
    --platform linux/${platform}\
    -t longengie/wireguard-podman:${platform}-${version}-${wireguard_version} .

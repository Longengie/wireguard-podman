#! /bin/sh

# This shell script use for quick build image on the platform
# # Please make sure if you are from other platform, check if you have qemu-user-static
build_date=$(date +"%Y-%m-%d")
version=1.0.$(date +"%Y%m%d")
platform='amd64'
dist_repository='http://dl-cdn.alpinelinux.org/alpine/v3.20/main/'
dist_repository_package='wireguard-tools'

wireguard_version=$(curl -sL "${dist_repository}x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp &&\
awk '/^P:'"${dist_repository_package}"'$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://')


podman build \
    --build-arg BUILD_DATE="${build_date}" \
    --build-arg VERSION="${version}" \
    --build-arg WIREGUARD_RELEASE="${wireguard_version}" \
    --platform linux/${platform}\
    -t longengie/wireguard-podman:${platform}-${version}-${wireguard_version} .

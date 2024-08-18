#! /bin/sh

# This shell script use for quick build image on the platform
# Please make sure if you are from other platform, check if you have qemu-user-static
build_date=$(date +"%Y-%m-%d")
version=1.0.$(date +"%Y%m%d")
platform='arm64'
arch='aarch64'
dist_repository='http://dl-cdn.alpinelinux.org/alpine/v3.20/'
dist_repository_package='wireguard-tools'

last_release_url="${dist_repository}releases/${arch}/latest-releases.yaml"
echo $last_release_url
alpine_minor_version=$(curl -sL "${last_release_url}" | grep version -m 1\
    | awk -F: '{ print $2 }' \
    | awk '{$1=$1};1')

wireguard_url="${dist_repository}main/${arch}/APKINDEX.tar.gz"
wireguard_version=$(curl -sL "${wireguard_url}" | tar -xz -C /tmp &&\
awk '/^P:'"${dist_repository_package}"'$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://')


podman build \
    --build-arg BUILD_DATE="${build_date}" \
    --build-arg VERSION="${version}" \
    --build-arg WIREGUARD_RELEASE="${wireguard_version}" \
    --build-arg ALPINE_VERSION="${alpine_minor_version}"\
    --platform linux/${platform}\
    -t longengie/wireguard-podman:${platform}-${version}-${wireguard_version} .

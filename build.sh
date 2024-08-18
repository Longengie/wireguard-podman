#! /bin/sh

# This shell script use for quick build image on the platform
platform=$(arch)

if [ "$platform"=='x86_64' ]; then
    sh ./build-amd64.sh
    exit 0
fi;

if [ "$platform"=='riscv64' ]; then
    sh ./build-riscv64.sh
    exit 0
fi;

if [ "$platform"=='aarch64' ]; then
    sh ./build-aarch64.sh
    exit 0
fi;

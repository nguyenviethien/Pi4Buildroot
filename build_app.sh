#!/bin/bash

APP_DIR=~/Pi4App
BUILDROOT=~/Pi4Buildroot/buildroot
TOOLCHAIN=$BUILDROOT/output/host/bin/aarch64-linux-gcc
OVERLAY=$BUILDROOT/board/rpi4/rootfs_overlay/root

echo "==== Build distance_app ===="

$TOOLCHAIN -O2 $APP_DIR/main.c -o $APP_DIR/distance_app

if [ $? -ne 0 ]; then
    echo "Build failed"
    exit 1
fi

echo "==== Copy to overlay ===="

cp $APP_DIR/distance_app $OVERLAY/
chmod +x $OVERLAY/distance_app

echo "==== Rebuild image ===="

cd $BUILDROOT
make -j$(nproc)

echo "==== Done ===="

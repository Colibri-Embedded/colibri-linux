#!/bin/bash

mkdir -p downloads
mkdir -p toolchain
mkdir -p sdcard

# Download Raspberry toolchain
if [ ! -f "./downloads/tools-master.tar.gz" ]; then
wget https://github.com/raspberrypi/tools/archive/master.tar.gz -O downloads/tools-master.tar.gz
fi

# Create work link to arm-linux-gnueabihf toolchain
cd toolchain
if [ ! -d tools-master ]; then
tar xf ../downloads/tools-master.tar.gz
fi
ln -fs tools-master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64 work

rm ./work/arm-linux-gnueabihf/libc/usr/lib/arm-linux-gnueabihf/libcrypt.so

cd ./work/arm-linux-gnueabihf/libc/lib/arm-linux-gnueabihf
ln -s libcrypt.so.1 libcrypt.so

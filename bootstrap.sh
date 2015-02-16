#!/bin/bash

mkdir -p downloads
mkdir -p toolchain

# Download Raspberry toolchain
if [ !-f "./downloads/tools-master.tar.gz" ]; then
wget https://github.com/raspberrypi/tools/archive/master.tar.gz -O downloads/tools-master.tar.gz
fi

# Create work link to arm-linux-gnueabihf toolchain
cd toolchain
tar xf ../downloads/tools-master.tar.gz
ln -fvs tools-master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64 work

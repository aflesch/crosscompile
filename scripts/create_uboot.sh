#!/bin/bash

ELDKVER=5.6
UBOOT_VER=2017.09

#build fw_printenv

. /opt/eldk-$ELDKVER/powerpc/environment-setup-powerpc-linux

mkdir -p /home/uboot
cd /home/uboot
wget ftp://ftp.denx.de/pub/u-boot/u-boot-$UBOOT_VER.tar.bz2
tar -xvf u-boot-$UBOOT_VER.tar.bz2
cd u-boot-$UBOOT_VER
make cross_tools
make MPC8308RDB_defconfig
make
make cross_tools

#make u-boot
cd /home/uboot
git clone --depth=1 https://avnerf:tcbrpka68@gitlab.com/OpticalZonu/u-boot --single-branch --branch j_switch_main
cd u-boot
make ws8308_config
make LDFLAGS="-O1 --hash-style=gnu --as-needed"

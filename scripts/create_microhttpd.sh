#!/bin/bash

ELDKVER=5.6
VER=0.9.55

. /opt/eldk-$ELDKVER/powerpc/environment-setup-powerpc-linux
mkdir -p /home/microhttpd
cd /home/microhttpd
wget http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-$VER.tar.gz
tar -xvf libmicrohttpd-$VER.tar.gz
cd libmicrohttpd-$VER
./configure --prefix=/opt/eldk-$ELDKVER/powerpc/sysroots/powerpc-linux/usr --host=powerpc-linux
make
make install


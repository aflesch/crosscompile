#!/bin/bash
set -e
# Versions
ELDKVER=5.6

MICROHTTPD_SRC_VER=0.9.55
GCRYPT_SRC_VER=1.8.0
GNUTLS_SRC_VER_MAJOR=2.12
GNUTLS_SRC_VER_MINOR=24
GNUTLS_SRC_VER=$GNUTLS_SRC_VER_MAJOR.$GNUTLS_SRC_VER_MINOR
GPGERROR_SRC_VER=1.27
P11KIT_SRC_VER=0.23.2
NETTLE_SRC_VER=3.3
GMPLIB_SRC_VER=6.1.2

ROOTFS_PREFIX=/opt/eldk-$ELDKVER/powerpc/sysroots/powerpc-linux

# log something
echo [[[Creating libmicrohttps-$MICROHTTPD_SRC_VER]]]

. /opt/eldk-$ELDKVER/powerpc/environment-setup-powerpc-linux

echo [[[Downloading]]]
wget http://mirror.veriportal.com/gnu/libmicrohttpd/libmicrohttpd-$MICROHTTPD_SRC_VER.tar.gz
wget ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-$GCRYPT_SRC_VER.tar.bz2
wget ftp://ftp.gnutls.org/gcrypt/gnutls/v$GNUTLS_SRC_VER_MAJOR/gnutls-$GNUTLS_SRC_VER.tar.xz
wget ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-$GPGERROR_SRC_VER.tar.bz2
wget ftp://ftp.gnu.org/gnu/nettle/nettle-$NETTLE_SRC_VER.tar.gz
wget https://gmplib.org/download/gmp/gmp-$GMPLIB_SRC_VER.tar.xz

tar -xvf libmicrohttpd-$MICROHTTPD_SRC_VER.tar.gz
tar -xvf libgcrypt-$GCRYPT_SRC_VER.tar.bz2
tar -xvf gnutls-$GNUTLS_SRC_VER.tar.xz
tar -xvf libgpg-error-$GPGERROR_SRC_VER.tar.bz2
tar -xvf nettle-$NETTLE_SRC_VER.tar.gz
tar -xvf gmp-$GMPLIB_SRC_VER.tar.xz

rm libmicrohttpd-$MICROHTTPD_SRC_VER.tar.gz
rm libgcrypt-$GCRYPT_SRC_VER.tar.bz2
rm gnutls-$GNUTLS_SRC_VER.tar.xz
rm libgpg-error-$GPGERROR_SRC_VER.tar.bz2
rm nettle-$NETTLE_SRC_VER.tar.gz
rm gmp-$GMPLIB_SRC_VER.tar.xz

echo [[[Building]]]


echo ------------------------------------------------------------------------------------
echo --------- LIBGMP
echo ------------------------------------------------------------------------------------
echo
echo
cd gmp-$GMPLIB_SRC_VER
./configure --prefix=$ROOTFS_PREFIX --host=powerpc-linux CFLAGS=-O3
make
sudo sudo "PATH=$PATH" make install

echo ------------------------------------------------------------------------------------
echo --------- NETTLE
echo ------------------------------------------------------------------------------------
echo
echo
cd ../nettle-$NETTLE_SRC_VER
./configure --prefix=$ROOTFS_PREFIX/usr --host=powerpc-linux CFLAGS=-O3 CXX=/bin/false

make
sudo make install

echo ------------------------------------------------------------------------------------
echo --------- GPG-ERROR
echo ------------------------------------------------------------------------------------
echo
echo
cd ../libgpg-error-$GPGERROR_SRC_VER
./configure --target=ppc-denx-linux --prefix=$ROOTFS_PREFIX/usr --host=powerpc-linux CFLAGS=-O3
make
sudo make install

echo ------------------------------------------------------------------------------------
echo --------- GNU TLS
echo ------------------------------------------------------------------------------------
echo
echo
cd ../gnutls-$GNUTLS_SRC_VER

./configure --prefix=$ROOTFS_PREFIX/usr --host=powerpc-linux --with-libgcrypt CFLAGS=-O3 --disable-camelliamake --without-p11-kit --disable-cxx --without-zlib --with-included-libtasn1 --with-included-unistring LIBS=-ldl

make
sudo "PATH=$PATH" "CROSS_COMPILE=$CROSS_COMPILE" make install

echo ------------------------------------------------------------------------------------
echo --------- GCRYPT
echo ------------------------------------------------------------------------------------
echo
echo
cd ../libgcrypt-$GCRYPT_SRC_VER
./configure --prefix=$ROOTFS_PREFIX/usr --host=powerpc-linux --disable-asm CFLAGS=-O3 --with-gpg-error-prefix=$ROOTFS_PREFIX/usr/
make
sudo make install

echo ------------------------------------------------------------------------------------
echo --------- LIBMICROHTTPD
echo ------------------------------------------------------------------------------------
echo
echo
cd ../libmicrohttpd-$MICROHTTPD_SRC_VER
./configure --prefix=$ROOTFS_PREFIX/usr --host=powerpc-linux CFLAGS=-O3 LIBS="-lgmp -lgnutls -lgcrypt -lgpg-error -ldl" LDFLAGS="-L$ROOTFS_PREFIX/usr/lib -L$ROOTFS_PREFIX/lib" --with-gnutls=$ROOTFS_PREFIX/usr --with-libgcrypt-prefix=$ROOTFS_PREFIX/usr

make
sudo "PATH=$PATH" make install

# log something
echo [[[Done.]]]


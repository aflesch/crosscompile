#!/bin/bash

ELDKVER=5.6
SNMP_VER=5.7.3

. /opt/eldk-$ELDKVER/powerpc/environment-setup-powerpc-linux
mkdir -p /home/netsnmp
cd /home/netsnmp
wget https://sourceforge.net/projects/net-snmp/files/net-snmp/$SNMP_VER/net-snmp-$SNMP_VER.tar.gz
tar -xvf net-snmp-$SNMP_VER.tar.gz
cd net-snmp-$SNMP_VER
./configure --prefix=/opt/eldk-$ELDKVER/powerpc/sysroots/powerpc-linux/usr --host=powerpc-linux --with-endianness=big --enable-ipv6 --enable-privacy --enable-des --enable-internal-md5 --without-rpm --with-openssl=internal --enable-mini-agent --with-default-snmp-version=2 --enable-shared --with-cflags="-O2 -fsigned-char" --with-sys-location=Unknown --with-logfile=/var/log/snmpd.log --with-persistent-directory=/var/net-snmp --with-out-mib-modules=examples/ucdDemoPublic --sysconfdir=/etc --with-pic --disable-embedded-perl --with-perl-modules=no --with-sys-contact=root@localhost --with-mib-modules=agentx --disable-manuals --disable-scripts --disable-mibs --disable-mib-loading --disable-deprecated --with-out-mib-modules="mibII mibII/snmp_mib mibII/system_mib mibII/sysORTable mibII/vacm_vars"
make
make install


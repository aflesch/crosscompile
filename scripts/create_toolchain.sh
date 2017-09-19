#!/bin/bash

VER=5.6
BASE=/home/eldk-$VER

# Download
mkdir -p $BASE
cd /home/eldk-$VER
wget -P $BASE/targets/powerpc ftp://ftp.denx.de/pub/eldk/$VER/targets/powerpc/*
wget -P $BASE ftp://ftp.denx.de/pub/eldk/$VER/*

# Install
cd $BASE
chmod +x install.sh
chmod +x targets/powerpc/*.sh
./install.sh -s toolchain -r lsb-dev powerpc




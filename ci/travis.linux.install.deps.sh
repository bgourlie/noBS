#!/bin/bash
set -e

wget http://download.opensuse.org/repositories/home:tpokorra:mono/xUbuntu_12.04/Release.key
sudo apt-key add - < Release.key  
echo 'deb http://download.opensuse.org/repositories/home:/tpokorra:/mono/xUbuntu_12.04/ /' | sudo tee -a /etc/apt/sources.list.d/mono-opt.list
sudo apt-get update -qq
sudo apt-get install -qq mono-opt

# This is necessary to get for some nuget ssl-related stuff
mozroots --import --sync

curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh && source ~/.kre/kvm/kvm.sh

mono --version

kvm upgrade


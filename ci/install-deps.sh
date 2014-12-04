#!/bin/bash
set -e

echo "Installing Dart SDK"
curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/$DART_DIST > $DART_DIST
mkdir -p $DART_SDK
unzip $DART_DIST -d ~ > /dev/null
rm $DART_DIST

echo "Installing Mono"
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


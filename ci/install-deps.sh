#!/bin/bash
set -e

echo "Installing Dart SDK"
curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/$DART_DIST > $DART_DIST
mkdir -p $DART_SDK
unzip $DART_DIST -d ~ > /dev/null
rm $DART_DIST

echo "Installing kvm"
curl https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.sh | sh && source ~/.kre/kvm/kvm.sh
kvm upgrade


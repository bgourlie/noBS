#!/bin/bash

set -e

# Get the Dart SDK.
curl http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/$DART_DIST > $DART_DIST
mkdir -p $DART_SDK
unzip $DART_DIST -d ~ > /dev/null
rm $DART_DIST

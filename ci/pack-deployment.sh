#!/bin/bash

set -e

echo "==========================="
echo "    PACKING DEPLOYMENT     "
echo "==========================="

echo "Building client..."
cd ./client
pub build

# (HACK) Move CLR KRE to packages folder
# Hopefully we will have the ability to target azure deployments from OS X/Linux at some point
cd $TRAVIS_BUILD_DIR/server/src
cp -rf ./AzureDeployDeps/KRE-CLR-x86.1.0.0-beta1 ~/.kre/packages/KRE-CLR-x86.1.0.0-beta1

echo "Packing server..."
cd ./FitLog.Api
kpm pack --out ./deploy --no-source --runtime ~/.kre/packages/KRE-CLR-x86.1.0.0-beta1

# Generate the version file
pub global activate -sgit https://github.com/bgourlie/nobsVersionPatcher
pub global run nvp:nvp genServerVersion -o ./deploy/wwwroot/version.json

# (HACK) Copy additional dependencies not packed on OS X / linux for deployment to azure
cp -rf ../AzureDeployDeps/System.ComponentModel ./deploy/approot/packages/System.ComponentModel
cp -rf ../AzureDeployDeps/System.ComponentModel.Annotations ./deploy/approot/packages/System.ComponentModel.Annotations

NUM_SERVER_FILES=$(find ./deploy -type f | wc -l)
echo "Packed server files ($NUM_SERVER_FILES files)"

NUM_CLIENT_FILES=$(find ../../../client/build -type f | wc -l)
echo "Copying client files to deployment ($NUM_CLIENT_FILES files)"
cp -rf ../../../client/build/web/* ./deploy/wwwroot

#!/bin/bash

set -e

echo "==========================="
echo "      DEPLOY TO AZURE !     "
echo "==========================="

# (HACK) Move CLR KRE to packages folder
# Hopefully we will have the ability to target azure deployments from OS X/Linux at some point
cd $TRAVIS_BUILD_DIR/server/src
cp -rf ./AzureDeployDeps/KRE-CLR-x86.1.0.0-beta1 ~/.kre/packages/KRE-CLR-x86.1.0.0-beta1

cd ./FitLog.Api
kpm pack --out ./deploy --no-source --runtime ~/.kre/packages/KRE-CLR-x86.1.0.0-beta1

# (HACK) copy additional dependencies not packed on OS X / linux for deployment to azure
cp -rf ../AzureDeployDeps/System.ComponentModel ./deploy/approot/packages/System.ComponentModel
cp -rf ../AzureDeployDeps/System.ComponentModel.Annotations ./deploy/approot/packages/System.ComponentModel.Annotations

echo $AZURE_FTP_USER
find ./deploy -type f -exec curl --fail --ftp-create-dirs -T {} -u $AZURE_FTP_USER:$AZURE_FTP_PASSWORD ftp://waws-prod-dm1-003.ftp.azurewebsites.windows.net/site/wwwroot/nobs-api/{} \;


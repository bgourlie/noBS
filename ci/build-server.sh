#!/bin/bash

set -e

echo "==========================="
echo "    PACKING DEPLOYMENT     "
echo "==========================="

# (HACK) Move CLR KRE to packages folder
# Hopefully we will have the ability to target azure deployments from OS X/Linux at some point
cd $TRAVIS_BUILD_DIR/server/src
cp -rf ./AzureDeployDeps/KRE-CLR-x86.1.0.0-beta1 ~/.kre/packages/KRE-CLR-x86.1.0.0-beta1

cd ./FitLog.Api
kpm pack --out ./deploy --no-source --runtime ~/.kre/packages/KRE-CLR-x86.1.0.0-beta1

# Generate the version file
pub global activate -sgit https://github.com/bgourlie/nobsVersionPatcher
pub global run nvp:nvp genServerVersion -o ./deploy/wwwroot/version.json

# (HACK) Copy additional dependencies not packed on OS X / linux for deployment to azure
cp -rf ../AzureDeployDeps/System.ComponentModel ./deploy/approot/packages/System.ComponentModel
cp -rf ../AzureDeployDeps/System.ComponentModel.Annotations ./deploy/approot/packages/System.ComponentModel.Annotations

# (HACK) Patch generated web.config so that we can serve static json files (version.json)
pub global run nvp:nvp patchWebConfig -c ./deploy/wwwroot/web.config

if [ "$TRAVIS_BRANCH" = "$DEPLOY_BRANCH" ];
then
	echo "==========================="
	echo "      DEPLOY TO AZURE      "
	echo "==========================="
	find ./deploy -type f -exec curl --fail --ftp-create-dirs -T {} -u $AZURE_FTP_USER:$AZURE_FTP_PASSWORD ftp://waws-prod-dm1-003.ftp.azurewebsites.windows.net/site/wwwroot/nobs-api/{} \;
else
	echo "Skipping server deployment because branch is not $DEPLOY_BRANCH."	
	exit 0
fi

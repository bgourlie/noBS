#!/bin/bash
set -e

if [ "$TRAVIS_BRANCH" = "$DEPLOY_BRANCH" ];
then
	echo "==========================="
	echo "      DEPLOY TO AZURE      "
	echo "==========================="
	find $TRAVIS_BUILD_DIR/server/src/FitLog.Api/deploy -type f -exec curl --fail --ftp-create-dirs -T {} -u $AZURE_FTP_USER:$AZURE_FTP_PASSWORD ftp://waws-prod-dm1-003.ftp.azurewebsites.windows.net/site/wwwroot/nobs-api/{} \;
else
	echo "Skipping server deployment because branch is not $DEPLOY_BRANCH."	
	exit 0
fi

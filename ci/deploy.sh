#!/bin/bash
# The contents of this file are subject to the Common Public Attribution
# License Version 1.0. (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# https://raw.githubusercontent.com/bgourlie/noBS/master/LICENSE.
# The License is based on the Mozilla Public License Version 1.1, but Sections
# 14 and 15 have been added to cover use of software over a computer network
# and provide for limited attribution for the Original Developer. In addition,
# Exhibit A has been modified to be consistent with Exhibit B.
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
#
# The Original Code is noBS Exercise Logger.
#
# The Original Developer is the Initial Developer.  The Initial Developer of
# the Original Code is W. Brian Gourlie.
#
# All portions of the code written by W. Brian Gourlie are Copyright (c)
# 2014-2015 W. Brian Gourlie. All Rights Reserved.

set -e

if [ "$TRAVIS_BRANCH" = "$DEPLOY_BRANCH" ];
then
	echo "==========================="
	echo "      DEPLOY TO AZURE      "
	echo "==========================="
	cd ~
	find $DEPLOY_DIR -type f -exec curl --fail --ftp-create-dirs -T {} -u $AZURE_FTP_USER:$AZURE_FTP_PASSWORD ftp://waws-prod-dm1-003.ftp.azurewebsites.windows.net/site/wwwroot/nobs-api/{} \;
else
	echo "Skipping server deployment because branch is not $DEPLOY_BRANCH."	
	exit 0
fi

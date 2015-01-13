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

#!/bin/bash

set -ev

# ugly hack because kvm upgrade isn't adding the KRE bin to the path
# this will break once the kre version changes
export PATH=$PATH:~/.kre/packages/KRE-Mono.1.0.0-beta1/bin

cd ./server/test/FitLog.Domain.Tests/

k test

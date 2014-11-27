#!/bin/bash

set -e

cd ./client
ls
pub get
pub run grinder:grinder tests

cd ../server
kpm restore -s https://www.myget.org/F/aspnetvnext/api/v2/ -f https://nuget.org/api/v2/ --quiet

cd ./test/FitLog.Domain.Tests/

k test

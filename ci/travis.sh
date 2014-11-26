#!/bin/bash

set -ev

echo "==========================="
echo "    RUNNING CLIENT TESTS   "
echo "==========================="
cd ./client
ls
pub get
pub run grinder:grinder tests


echo "=========================="
echo "   RUNNING SERVER TESTS   "
echo "=========================="

cd ../server
kpm restore -s https://www.myget.org/F/aspnetvnext/api/v2/ -f https://nuget.org/api/v2/ 

cd ./test/FitLog.Domain.Tests/

k test

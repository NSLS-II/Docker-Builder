#!/bin/bash

# This bash script will be run with when the docker image is run
git clone https://github.com/epicsNSLS2-deploy/installSynApps
cd installSynApps
git clone https://github.com/epicsNSLS2-deploy/Install-Configurations
if [ "$ADCORE_VERSION" == "newest" ];
then
python3 -u installCLI.py -v -c Install-Configurations/configureDeb10
else
cd Install-Configurations
echo "Checking out config version $ADCORE_VERSION"
git checkout -q $ADCORE_VERSION
cd ..
fi
python3 -u installCLI.py -y -s -c Install-Configurations/configureDeb10 -i /epics -p


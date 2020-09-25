#!/bin/bash

# This bash script will be run with when the docker image is run

git clone $INSTALL_SYNAPPS_URL
cd installSynApps
git checkout -q origin/$INSTALL_SYNAPPS_BRANCH
git clone $INSTALL_CONFIG_URL
cd Install-Configurations
git checkout -q origin/$INSTALL_CONFIG_BRANCH
cd ..
if [ "$ADCORE_VERSION" == "newest" ];
then
python3 -u installCLI.py -v -c Install-Configurations/configureCentOS8
else
cd Install-Configurations
echo "Checking out config version $ADCORE_VERSION"
git checkout -q $ADCORE_VERSION
cd ..
fi
python3 -u installCLI.py -y -s -c Install-Configurations/configureCentOS8 -i /epics -p

#!/bin/bash

# This bash script will be run with when the docker image is run
git clone --single-branch --branch=$INSTALL_SYNAPPS_BRANCH $INSTALL_SYNAPPS_URL
echo "Cloned installSynApps w/ branch $INSTALL_SYNAPPS_BRANCH"
cd installSynApps
git clone --single-branch --branch=$INSTALL_CONFIG_BRANCH $INSTALL_CONFIG_URL
echo "Cloned Install-Configurations w/ branch $INSTALL_CONFIG_BRANCH"

if [ "$ADCORE_VERSION" == "newest" ];
then
python3 -u installCLI.py -v -c Install-Configurations/$UBUNTU19_CONFIG
else
cd Install-Configurations
echo "Checking out config version $ADCORE_VERSION"
git checkout -q $ADCORE_VERSION
cd ..
fi
python3 -u installCLI.py -y -s -c Install-Configurations/$UBUNTU19_CONFIG -i /epics -p

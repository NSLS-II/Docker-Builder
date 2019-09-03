#!/bin/bash

# This bash script will be run with when the docker image is run

git clone https://github.com/epicsNSLS2-deploy/installSynApps
cd installSynApps
git clone https://github.com/epicsNSLS2-deploy/Install-Configuration
python3 -u installCLI.py -y -c Install-Configuration/configureDeb9 -i /epics

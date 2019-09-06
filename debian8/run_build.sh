#!/bin/bash

# This bash script will be run with when the docker image is run

git clone https://github.com/epicsNSLS2-deploy/installSynApps
cd installSynApps
git clone https://github.com/epicsNSLS2-deploy/Install-Configurations
python3 -u installCLI.py -y -c Install-Configurations/configureDeb8 -i /epics

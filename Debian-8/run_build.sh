#!/bin/bash

# This bash script will be run with when the docker image generated from the
# Dockerfile in this directory is run

git clone https://github.com/epicsNSLS2-deploy/installSynApps
cd installSynApps
python3 installCLI.py -y -c addtlConfDirs/configureDeb8 -i /epics


#!/bin/bash

# This bash script will be run with when the docker image generated from the
# Dockerfile in this directory is run

git clone --single-branch --branch=feature-custom-build-scripts https://github.com/jwlodek/installSynApps
cd installSynApps
python3 installCLI.py -y -c addtlConfDirs/configureDeb8


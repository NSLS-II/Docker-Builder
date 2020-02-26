#!/bin/bash

# If running behind a proxy, edit this variable to be -c http.proxy=YOUR_PROXY
GIT_PROXY=""

git $GIT_PROXY clone https://github.com/epicsNSLS2-deploy/Install-Configurations
cd Install-Configurations
./update_and_tag.sh
cd ..
rm -rf Install-Configurations

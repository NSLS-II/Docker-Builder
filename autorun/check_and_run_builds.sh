#!/bin/bash

# You must define the http proxy variable here
GIT_PROXY="-c http.proxy=PROXY"

NEWEST_TAG=($(git $GIT_PROXY ls-remote --tags https://github.com/areaDetector/ADCore | awk -F/ '{ print $3 }' | tac))
PREVIOUS_TAG=$(cat PREVIOUS_VERSION.txt)
if [ "$NEWEST_TAG" != "$PREVIOUS_TAG" ];
then
echo "Last built version: $PREVIOUS_TAG. Detected newest version: $NEWEST_TAG"

# Store previous version
CWD=$(pwd)

# Go one directory up to the Docker-Builder folder
cd ..
echo "Executing Docker-Builder"
./run_container.sh all
cd $CWD
rm PREVIOUS_VERSION.txt
touch PREVIOUS_VERSION.txt
echo "Writing tag to file."
echo "$NEWEST_TAG" >> PREVIOUS_VERSION.txt
else
echo "No new version detected."
fi

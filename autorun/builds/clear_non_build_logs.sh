#!/bin/bash

for f in ./*
do
    LOG_CONTENTS=$(cat $f)
    if [ "$LOG_CONTENTS" == "No new version detected." ];
    then
    rm $f
    echo "Removed log $f - was not a build log"
    fi
done
echo "Done."

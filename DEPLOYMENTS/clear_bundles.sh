#!/bin/bash

# Simple script for cleaning out deployments folder.

echo "Are you sure you want to delete all bundles and README files?"
read -p "(y/n) > " res

if [ "$res" = "y" ];
then
rm *.tgz
rm *.txt
fi

echo "Done."

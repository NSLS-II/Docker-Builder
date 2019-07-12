#!/bin/bash

echo "Starting Ubuntu18.04 build"
echo "Creating container"
docker run --cidfile ubuntu18.04_id.cid isa/ubuntu18.04
UBUNTU_18_04_ID=$(cat ubuntu18.04_id.cid)
rm ubuntu18.04_id.cid
echo "Copying package..."
docker cp $UBUNTU_18_04_ID:/installSynApps/DEPLOYMENTS $(pwd)/DEPLOYMENTS/.
mv DEPLOYMENTS/DEPLOYMENTS/* DEPLOYMENTS/.
rmdir DEPLOYMENTS/DEPLOYMENTS
echo "Shutting down container."""
docker container rm $UBUNTU_18_04_ID

echo "Starting Debian8 build"
echo "Creating container"
docker run --cidfile debian8_id.cid isa/debian8
DEBIAN_8_ID=$(cat ubuntu18.04_id.cid)
rm debian8_id.cid
echo "Copying package..."
docker cp $DEBIAN_8_ID:/installSynApps/DEPLOYMENTS $(pwd)/DEPLOYMENTS/.
mv DEPLOYMENTS/DEPLOYMENTS/* DEPLOYMENTS/.
rmdir DEPLOYMENTS/DEPLOYMENTS
docker container rm $DEBIAN_8_ID
echo "Shutting down container."

echo "Build Done."

#!/bin/bash

docker run --cidfile ubuntu18.04_id.cid ubuntu/18.04 
UBUNTU_18_04_ID=$(cat ubuntu18.04_id.cid)
rm ubuntu18.04_id.cid
docker cp $UBUNTU_18_04_ID:/installSynApps/DEPLOYMENTS $(pwd)/DEPLOYMENTS/.
mv DEPLOYMENTS/DEPLOYMENTS/* DEPLOYMENTS/.
rmdir DEPLOYMENTS/DEPLOYMENTS
docker container rm $UBUNTU_18_04_ID

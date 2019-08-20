#!/bin/bash


to_run=$1

function run_container () {
    container=$1
    echo "Starting $container build"
    docker run --cidfile "$container"_id.cid isa/"$container"
    CONTAINER_ID=$(cat "$container"_id.cid)
    rm "$container"_id.cid
    echo "Copying package..."
    docker cp $CONTAINER_ID:/installSynApps/DEPLOYMENTS $(pwd)/DEPLOYMENTS/.
    mv DEPLOYMENTS/DEPLOYMENTS/* DEPLOYMENTS/.
    rmdir DEPLOYMENTS/DEPLOYMENTS
    echo "Shutting down container."""
    docker container rm $CONTAINER_ID
}

if [ "$to_run" = "help" ];
then
echo "USAGE:"
echo "  ./run_container.sh all - will run all docker containers sequentially."
echo "  ./run_container OS - will run single container."
echo
echo "Supported containers: [ ubuntu18.04, ubuntu19.04, debian8, debian9 ]"
echo
exit
fi

if [ "$to_run" = "all" ];
then
run_container ubuntu18.04
run_container ubuntu19.04
run_container debian8
run_container debian9
else
run_container "$to_run"
fi

echo "Build done. Bundles placed in ./DEPLOYMENTS"
exit

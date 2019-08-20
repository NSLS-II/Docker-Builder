#!/bin/bash

# Function that runs a single Docker container
function run_container () {
    CONTAINER_NAME=$1
    echo "Starting $CONTAINER_NAME build"
    docker run --cidfile "$CONTAINER_NAME"_id.cid isa/"$CONTAINER_NAME"
    CONTAINER_ID=$(cat "$CONTAINER_NAME"_id.cid)
    rm "$CONTAINER_NAME"_id.cid
    echo "Copying package..."
    docker cp $CONTAINER_ID:/installSynApps/DEPLOYMENTS $(pwd)/DEPLOYMENTS/.
    mv DEPLOYMENTS/DEPLOYMENTS/* DEPLOYMENTS/.
    rmdir DEPLOYMENTS/DEPLOYMENTS
    echo "Shutting down the $CONTAINER_NAME container."
    docker container rm $CONTAINER_ID
}

# Print the help message
function print_help () {
    echo
    echo "USAGE:"
    echo "  ./run_container.sh all - will run all docker containers sequentially."
    echo "  ./run_container [Distribution Container] - will run single container."
    echo
    echo "  Ex. ./run_container.sh ubuntu18.04"
    echo
    echo "Supported containers: [ ubuntu18.04, ubuntu19.04, debian8, debian9 ]"
    echo
    exit
}

# First check if number of arguments is correct
if [ "$#" != "1" ];
then
echo
echo "Exactly 1 argument is required for run_container.sh."
print_help
else
TO_RUN=$1
fi


# Check if input parameter is valid
if [ "$TO_RUN" != "help" ];
then
case $TO_RUN in 
    ubuntu18.04|ubuntu19.04|debian8|debian9|all) echo "Valid option $TO_RUN. Starting Docker-Builder...";;
    *) echo "ERROR - $TO_RUN is not a supported container"
       print_help;;
esac
else
print_help
fi

# Otherwise if TO_RUN is valid container name or all
# run the run_container function
if [ "$TO_RUN" = "all" ];
then
run_container ubuntu18.04
run_container ubuntu19.04
run_container debian8
run_container debian9
else
run_container "$TO_RUN"
fi

echo "Build done. Bundles placed in ./DEPLOYMENTS"
exit

#!/bin/bash

# Function that runs a single Docker container. When running, a .cid file
# is created that contains the container ID. This is used to fetch the bundle
# from the container after build completion, and then to free the container.
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
    echo "  ./run_container.sh help - will display this help message."
    echo "  ./run_container.sh all - will run all docker containers sequentially."
    echo "  ./run_container.sh [Distribution] - will run a single container."
    echo
    echo "  Ex. ./run_container.sh ubuntu18.04"
    echo
    echo "Supported containers: [ ubuntu18.04, ubuntu19.04, debian8, debian9, debian10, centos7 ]"
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
    ubuntu18.04|ubuntu19.04|debian8|debian9|debian10|centos7|all) echo "Valid option $TO_RUN. Starting Docker-Builder...";;
    *) echo "ERROR - $TO_RUN is not a supported container"
       print_help;;
esac
else
print_help
fi

TIMESTAMP=$(date '+%Y-%m-%d-%H:%M:%S')
mkdir logs

# Otherwise if TO_RUN is valid container name or all
# run the run_container function. All terminal output placed in logfile
if [ "$TO_RUN" = "all" ];
then
run_container ubuntu18.04 |& tee logs/Build-Log-$TIMESTAMP.log
run_container ubuntu19.04 |& tee -a logs/Build-Log-$TIMESTAMP.log
run_container debian8 |& tee -a logs/Build-Log-$TIMESTAMP.log
run_container debian9 |& tee -a logs/Build-Log-$TIMESTAMP.log
run_container debian10 |& tee -a logs/Build-Log-$TIMESTAMP.log
run_container centos7 |& tee -a logs/Build-Log-$TIMESTAMP.log
else
run_container "$TO_RUN" |& tee logs/Build-Log-$TIMESTAMP.log
fi

echo "Build done. Bundles placed in ./DEPLOYMENTS"
exit

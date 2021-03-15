#!/bin/bash

# Function that runs a single build container and extracts the only addon package
# specified by the build. The container is then cleaned up afterwords.
function run_addon_container () {
    CONTAINER_NAME=$1
    ADDON_MODULE=$2
    echo "Starting $CONTAINER_NAME build for $ADDON_MODULE..."

    docker run --env-file ./config.env -e "ADDON_MODULE=$ADDON_MODULE" --cidfile "$CONTAINER_NAME"_id.cid isa/"$CONTAINER_NAME"

    echo "Copying $ADDON_MODULE add-on package..."
    CONTAINER_ID=$(cat "$CONTAINER_NAME"_id.cid)
    rm "$CONTAINER_NAME"_id.cid
    docker cp $CONTAINER_ID:/installSynApps/DEPLOYMENTS $(pwd)/DEPLOYMENTS/.
    mv DEPLOYMENTS/DEPLOYMENTS/* DEPLOYMENTS/.
    rm DEPLOYMENTS/cleanup.sh
    rmdir DEPLOYMENTS/DEPLOYMENTS

    echo "Shutting down the $CONTAINER_NAME container..."
    docker container rm $CONTAINER_ID
    
    echo "Done."
    echo
}


function print_help () {
    echo "This is a stand-in help menu"
    exit
}


# Check if inputs are valid
if [ "$#" == "2" ];
then
TO_RUN=$1
ADDON_MODULE=$2
elif [ "$#" == "1" ];
then
if [ "$1" == "help" ];
then
print_help
else
echo "Exactly 2 arguments are required for create_addon_package.sh"
print_help
fi
else
echo "Exactly 2 arguments are required for create_addon_package.sh"
print_help
fi


# Check if selected distribution is legal
if [ "$TO_RUN" != "help" ];
then
case $TO_RUN in 
    ubuntu18.04|ubuntu19.04|ubuntu20.04|debian8|debian9|debian10|centos7|centos8|debian|ubuntu|centos|all) echo "Valid option $TO_RUN. Starting Docker-Builder...";;
    *) echo "ERROR - $TO_RUN is not a supported target distribution"
    print_help;;
esac
fi

TIMESTAMP=$(date '+%Y-%m-%d-%H:%M:%S')

# If all our arguments are valid, we will simply run the appropriate builder image
if [ "$TO_RUN" = "all" ];
then
run_addon_container ubuntu18.04 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container ubuntu19.04 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container ubuntu20.04 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container debian8 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container debian9 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container debian10 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container centos7 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container centos8 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
elif [ "$TO_RUN" = "debian" ];
then
run_addon_container debian8 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container debian9 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container debian10 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
elif [ "$TO_RUN" = "ubuntu" ];
then
run_addon_container ubuntu18.04 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container ubuntu19.04 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container ubuntu20.04 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
elif [ "$TO_RUN" = "centos" ];
run_addon_container centos7 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
run_addon_container centos8 $ADDON_MODULE |& tee logs/Build-Log-$TIMESTAMP.log
else
fi

echo "Build done. Add-on bundles placed in ./DEPLOYMENTS"




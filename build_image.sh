#!/bin/bash

# Function that enters a target directory, and builds a docker image from it
function build_image () {
    IMAGE_NAME=$1
    DOCKER_FLAGS=${@:2}
    
    # We need to add a space if we are adding flags
    if [ "$DOCKER_FLAGS" != "" ];
    then
        DOCKER_FLAGS="$DOCKER_FLAGS "
    fi

    cd $IMAGE_NAME
    echo "docker build $DOCKER_FLAGS--tag isa/$IMAGE_NAME ."
    docker build "$DOCKER_FLAGS"--tag isa/$IMAGE_NAME .
    cd ..
}

# Print the help message
function print_help () {
    echo
    echo "USAGE:"
    echo "  ./build_image.sh help - will display this help message"
    echo "  ./build_image.sh all - will build all docker images sequentially."
    echo "  ./build_image.sh [Distribution Branch] - will build all images for particular distro branch. Ex: debian"
    echo "  ./build_image.sh [Distribution] - will build a single container image."
    echo
    echo "  Ex. ./build_image.sh ubuntu18.04"
    echo "  Ex. ./build_image.sh debian"
    echo "  Ex. ./build_image.sh all"
    echo
    echo "Supported distributions: [ ubuntu18.04, ubuntu19.04, ubuntu20.04, debian8, debian9, debian10, centos7, centos8 ]"
    echo
    echo "You may also add any number of docker build flags after selecting a distribution."
    echo
    exit
}


# First check if number of arguments is correct
if [ "$#" < "1" ];
then
echo
echo "At least 1 argument is required for build_image.sh."
print_help
else
TO_RUN=$1
DOCKER_FLAGS=${@:2}
fi

# Check if input parameter is valid
if [ "$TO_RUN" != "help" ];
then

# Remove trailing slash if found.
if [ "${TO_RUN: -1}" == "/" ];
then
    TO_RUN="${TO_RUN::-1}"
fi

case $TO_RUN in 
    ubuntu18.04|ubuntu19.04|ubuntu20.04|debian8|debian9|debian10|centos7|centos8|ubuntu|debian|centos|all) echo "Valid option $TO_RUN. Starting Docker-Builder...";;
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
build_image ubuntu18.04 "$DOCKER_FLAGS"
build_image ubuntu19.04 "$DOCKER_FLAGS"
build_image ubuntu20.04 "$DOCKER_FLAGS"
build_image debian8 "$DOCKER_FLAGS"
build_image debian9 "$DOCKER_FLAGS"
build_image debian10 "$DOCKER_FLAGS"
build_image centos7 "$DOCKER_FLAGS"
build_image centos8 "$DOCKER_FLAGS"
elif [ "$TO_RUN" = "debian" ];
then
build_image debian8 "$DOCKER_FLAGS"
build_image debian9 "$DOCKER_FLAGS"
build_image debian10 "$DOCKER_FLAGS"
elif [ "$TO_RUN" = "ubuntu" ];
then
build_image ubuntu18.04 "$DOCKER_FLAGS"
build_image ubuntu19.04 "$DOCKER_FLAGS"
build_image ubuntu20.04 "$DOCKER_FLAGS"
elif [ "$TO_RUN" = "centos" ];
then
build_image centos7 "$DOCKER_FLAGS"
build_image centos8 "$DOCKER_FLAGS"
else
build_image "$TO_RUN" "$DOCKER_FLAGS"
fi

# Clean up the intermediate images
echo "Removing previous image versions..."
docker image prune -f

echo "Docker image created for $TO_RUN. Use docker image ls to see all images."
echo "Run a build with: ./run_container.sh $TO_RUN"
echo "Done."
exit

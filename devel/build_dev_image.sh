#!/bin/bash

# Function that enters a target directory, and builds a docker image from it
function build_image () {
    IMAGE_NAME=$1
    cd $IMAGE_NAME
    docker build -t isadev/$IMAGE_NAME .
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
    echo "  Ex. ./build_dev_image.sh ubuntu18.04"
    echo "  Ex. ./build_dev_image.sh debian"
    echo "  Ex. ./build_dev_image.sh all"
    echo
    echo "Supported distributions: [ ubuntu18.04, ubuntu19.04, debian8, debian9, debian10, centos7, centos8 ]"
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
    ubuntu18.04|ubuntu19.04|debian8|debian9|debian10|centos7|centos8|ubuntu|debian|centos|all) echo "Valid option $TO_RUN. Starting Docker-Builder...";;
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
build_image ubuntu18.04
build_image ubuntu19.04
build_image debian8
build_image debian9
build_image debian10
build_image centos7
build_image centos8
elif [ "$TO_RUN" = "debian" ];
then
build_image debian8
build_image debian9
build_image debian10
elif [ "$TO_RUN" = "ubuntu" ];
then
build_image ubuntu18.04
build_image ubuntu19.04
elif [ "$TO_RUN" = "centos" ];
then
build_image centos7
build_image centos8
else
build_image "$TO_RUN"
fi

# Clean up the intermediate images
echo "Removing previous image versions..."
docker image prune -f

echo "Docker development image created for $TO_RUN. Use docker image ls to see all images."
echo "Start an environment with: ./init_dev_env.sh $TO_RUN"
echo "Done."
exit

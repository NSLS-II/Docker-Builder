# The ubuntu 18.04 builder
FROM ubuntu:18.04

# Check for updates and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install python3 and pip and upgrade pip
RUN apt-get install python3 python3-pip -y
RUN python3 -m pip install --upgrade pip

# Install required build tool packages
RUN apt-get -y install gcc g++ git wget tar make cmake pkg-config

# Required Packages for building EPICS
RUN apt-get -y install libxml2-dev libpcre3-dev re2c libxext-dev libreadline-dev
RUN apt-get -y install  libx11-dev libusb-dev libusb-1.0-0-dev libjpeg-dev

# Boost packages used by EPICS unit testing and several drivers/modules
RUN apt-get -y install libboost-dev libboost-test-dev libboost-system-dev 

# Required for ADPointGrey driver
RUN apt-get -y install libraw1394-dev

# Install distro package
RUN python3 -m pip install distro

# copy the script
COPY ./run_build.sh ./
# run the script
CMD ["bash","run_build.sh"]


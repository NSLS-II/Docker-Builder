# The ubuntu 18.04 builder
FROM ubuntu:19.04
# get the important packages
RUN apt-get update && apt-get upgrade -y && apt-get install python3-pip -y
RUN python3 -m pip install --upgrade pip
RUN apt-get -y install git wget tar make cmake
RUN apt-get -y install gcc g++ make libxml2-dev libboost-dev libboost-test-dev libboost-system-dev libpcre3-dev re2c
RUN apt-get -y install libxext-dev libreadline-dev libx11-dev libusb-dev libusb-1.0-0-dev libraw1394-dev
RUN python3 -m pip install distro
# copy the script
COPY ./run_build.sh ./
# run the script
CMD ["bash","run_build.sh"]

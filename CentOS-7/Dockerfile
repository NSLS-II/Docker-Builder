# The centos7 builder
FROM centos:7

# check for updates and ugrade packages
RUN yum check-update && yum update

# Python + pip required for installSynApps
RUN yum -y install python3-pip python3
RUN python3 -m pip install --upgrade pip

# Required build packages
RUN yum -y install git wget tar make cmake gcc g++ pkgconfig

# Packages required for building EPICS
RUN yum -y install libxm12-dev libpcre3-dev re2c libxext-dev
RUN yum -y install libjpeg-dev libreadline-dev libx11-dev libusb-dev libusb-1.0-0-dev

# Boost packages used by EPICS unit testing and several drivers/modules
RUN yum -y install libboost-test-dev libboost-system-dev libboost-dev

# Install some necessary python packages
RUN python3 -m pip install distro

# Copy the script
COPY ./run_build.sh ./

# The run command
CMD ["bash", "run_build.sh"]
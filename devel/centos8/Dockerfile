# The centos8 builder
FROM centos:8

# check for updates and ugrade packages
RUN dnf check-update || { rc=$?; [ "$rc" -eq 100 ] && exit 0; exit "$rc"; }
RUN dnf -y update

# Python + pip required for installSynApps
RUN dnf -y install epel-release
RUN dnf -y install python36 python3-pip
RUN python3 -m pip install --upgrade pip

# Required build packages
RUN dnf -y install git wget tar make cmake gcc gcc-c++ pkgconfig perl-devel

# Packages required for building EPICS
RUN dnf -y install libtirpc-devel
RUN dnf -y --enablerepo=PowerTools install re2c libusb-devel rpcgen
RUN dnf -y install libxml2-devel pcre-devel libXext-devel
RUN dnf -y install libjpeg-devel readline-devel libusbx-devel

# Boost packages used by EPICS unit testing and several drivers/modules
RUN dnf -y install boost-devel

# libraw1394 is required for ADPointGrey
RUN dnf -y install libraw1394

# Install some necessary python packages
RUN python3 -m pip install distro

# Grab installSynApps
RUN mkdir /epics
RUN mkdir /epics/utils
RUN git clone https://github.com/epicsNSLS2-deploy/installSynApps /epics/utils/installSynApps
RUN git clone https://github.com/epicsNSLS2-deploy/Install-Configurations /epics/utils/Install-Configurations

COPY ./README.txt ./

# Start bash shell
CMD ["/bin/bash"]


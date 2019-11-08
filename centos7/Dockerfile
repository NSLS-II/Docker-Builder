# The centos7 builder
FROM centos:7

# check for updates and ugrade packages
RUN yum check-update || { rc=$?; [ "$rc" -eq 100 ] && exit 0; exit "$rc"; }
RUN yum -y update

# Python + pip required for installSynApps
RUN yum -y install epel-release
RUN yum -y install python36 python36-pip
RUN python3 -m pip install --upgrade pip

# Required build packages
RUN yum -y install git wget tar make cmake gcc gcc-c++ pkgconfig

# Packages required for building EPICS
RUN yum -y install libxml2-devel pcre-devel re2c libXext-devel
RUN yum -y install libjpeg-devel readline-devel libusb-devel libusbx-devel

# Boost packages used by EPICS unit testing and several drivers/modules
RUN yum -y install boost-devel

# libraw1394 is required for ADPointGrey
RUN yum -y install libraw1394-devel

# Install some necessary python packages
RUN python3 -m pip install distro

# Copy the script
COPY ./run_build.sh ./

# The run command
CMD ["bash", "run_build.sh"]

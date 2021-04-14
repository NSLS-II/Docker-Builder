# The centos7 builder
FROM registry.access.redhat.com/ubi8/ubi 

# Install yum utilities
RUN yum -y install yum-utils

# Enable codeready repo
RUN yum-config-manager --enable codeready-builder-for-rhel-8-x86_64-rpms

# check for updates and ugrade packages
RUN yum check-update || { rc=$?; [ "$rc" -eq 100 ] && exit 0; exit "$rc"; }
# Not necessary?
#RUN yum -y update

# Python + pip required for installSynApps
#RUN yum -y install epel-release
RUN yum -y install python36
RUN python3 -m pip install --upgrade pip

# Required build packages
RUN yum -y install git wget tar make cmake gcc gcc-c++ pkgconfig perl-devel xz


# Packages required for building EPICS
RUN yum -y install libxml2-devel pcre-devel readline-devel re2c libtirpc-devel
RUN yum -y install libjpeg-devel libusb-devel libusbx-devel rpcgen

# Boost packages used by EPICS unit testing and several drivers/modules
RUN yum -y install boost-devel

# libraw1394 is required for ADPointGrey
RUN yum -y install libraw1394

# Install some necessary python packages
RUN python3 -m pip install distro requests

# Copy the script
COPY ./run_build.sh ./

# The run command
CMD ["bash", "run_build.sh"]

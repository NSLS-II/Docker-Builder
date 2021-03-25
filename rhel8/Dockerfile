# The centos7 builder
FROM registry.access.redhat.com/ubi8/ubi 

# check for updates and ugrade packages
RUN yum check-update || { rc=$?; [ "$rc" -eq 100 ] && exit 0; exit "$rc"; }
RUN yum -y update

# Python + pip required for installSynApps
#RUN yum -y install epel-release
RUN yum -y install python36
RUN python3 -m pip install --upgrade pip

# Required build packages
RUN yum -y install git wget tar make cmake gcc gcc-c++ pkgconfig perl-devel xz

# Manually build and install re2c since package is missing
RUN wget https://github.com/skvadrik/re2c/releases/download/2.0.3/re2c-2.0.3.tar.xz
RUN tar -xf re2c-2.0.3.tar.xz
RUN cd re2c-2.0.3 && ./configure && make -sj && make install

# Manually build and install libreadline since package is missing
RUN wget https://ftp.gnu.org/gnu/readline/readline-8.1.tar.gz
RUN tar -xzf readline-8.1.tar.gz
RUN cd readline-8.1 && ./configure && make -sj && make install

# Packages required for building EPICS
RUN yum -y install libxml2-devel pcre-devel
RUN yum -y install libjpeg-devel

# Boost packages used by EPICS unit testing and several drivers/modules
#RUN yum -y install boost-devel

# Install some necessary python packages
RUN python3 -m pip install distro requests

# Copy the script
COPY ./run_build.sh ./

# The run command
CMD ["bash", "run_build.sh"]

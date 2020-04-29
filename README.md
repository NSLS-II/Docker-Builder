# Docker-Builder

An exploration into using docker containers to trigger EPICS areaDetector builds on many supported distributions with [installSynApps](https://github.com/epicsNSLS2-deploy/installSynApps).

### Setup

For using `Docker-Builder`, you will need an active docker engine installation on a modern linux machine.

Here are links to guides for setting up docker engine for various linux distributions:

* **Ubuntu:** https://docs.docker.com/install/linux/docker-ce/ubuntu/
* **Debian:** https://docs.docker.com/install/linux/docker-ce/debian/
* **Cent-OS:** https://docs.docker.com/install/linux/docker-ce/centos/

**NOTE: Running docker engine on windows allows for running both windows and linux containers, but as of yet Docker-Builder has only been tested on linux.**

### Generating the Images

`Docker-Builder` works by creating Docker image containers for each OS on your system. When run, these containers clone the [installSynApps](https://github.com/epicsNSLS2-deploy/installSynApps) python module, and use it to clone, build, and package all of EPICS, synApps, and areaDetector.

To generate the docker container images, clone the Docker-Builder repository with:
```
git clone https://github.com/epicsNSLS2-deploy/Docker-Builder
```
Then enter the directory and run the `build_image.sh` script. To build all OS images, run:
```
cd Docker-Builder
./build_image.sh all
```
Alternatively, you may specify a single supported distribution. For example, for Cent-OS 7:
```
./build_image.sh centos7
```
The input should match the directory name of the target distribution. Note that the `run_container.sh` script described below will only work for distributions that have successfully generated docker images.

Building each docker image will take several minutes. To ensure that the docker images were created successfully, run:
```
docker image ls
```
The result should look similar to the following:
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
isa/debian9         latest              524827ab317a        34 minutes ago      837MB
isa/debian8         latest              6aefd53fa9f8        34 minutes ago      649MB
isa/ubuntu19.04     latest              80697618df09        36 minutes ago      775MB
isa/ubuntu18.04     latest              fb60dc54bee5        37 minutes ago      739MB
ubuntu              19.04               9f3d7c446553        5 days ago          70MB
ubuntu              18.04               a2a15febcdf3        5 days ago          64.2MB
debian              9                   f26939cc87ef        6 days ago          101MB
debian              8                   2c5f66c0d4e0        6 days ago          129MB
```
Note that you will see an image for the distribution containers (ubuntu 18.04, debian 8 etc.), and then `isa/$DISTRIBUTION` (ex. isa/debian9, isa/ubuntu19.04), which are the actual build containers. Each container is around 1GB in size.

You should only need to run the `build_image.sh` script once per distribution, unless there is an update to its Dockerfile. This means that you can run `build_image.sh all` once on your development server, and you will not have to run it again. From there you will only need to use the `run_container.sh` script as described below.

### Running the Images

Once the images are created, you may execute a build for a supported container by running the `run_container.sh` script. For example, when executing a build for ubuntu 18.04:
```
./run_container.sh ubuntu18.04
```
**NOTE: The distribution name passed to the script must match the isa/ Docker image.**

To generate bundles for all supported distributions, run:
```
./run_container.sh all
```
To see a list of supported distributions, run:
```
./run_container.sh help
```

It is recommended to run `Docker-Builder` on a fairly powerful machine, as the build scales fairly well along with the number of CPU cores. Each container takes roughly 5 minutes to build on a 16 core Intel Xeon Silver 4110 based machine, with default docker hardware usage settings. With the currently supported 4 distributions, a `./run_container all` run took around 20 minutes on the same machine.

Each execution of `run_container.sh` will generate a log file in `logs/`. The filename will be a build timestamp. You may look through these files in order to catch any build errors.

The generated containers should be automatically closed once the bundle has been moved to your local machine. In the event that this does not happen, you may free up the docker containers with:
```
docker container prune
```

### Output Bundles

Running a docker image container will place the generated output bundle in the `DEPLOYMENTS` directory in the `Docker-Builder` folder. The output bundle will be in the format of a tarball archive, and can be unpacked anywhere. To generate IOCs using this output tarball, it is recommended to use [initIOC](https://github.com/epicsNSLS2-deploy/initIOC). Step by step instructions for using this script are available [here](https://epicsnsls2-deploy.github.io/Deploy-Docs/#initIOC-step-by-step-example).

### Supported Distributions

Supported linux distributions are whatever distributions have a Dockerfile in `Docker-Builder`. Currently this includes:

* Ubuntu 18.04
* Ubuntu 19.04
* Ubuntu 20.04
* Debian 8
* Debian 9
* Debian 10
* CentOS 7
* CentOS 8

Feel free to make an issue or pull request if you desire further distribution support.

### Contributing

The `Docker-Builder` has been tested with `./build_image.sh all` and `./run_container.sh all` on the following host distributions:

* Ubuntu 18.04 LTS
* Debian 9
* Debian 10
* CentOS 7

If you have used `Docker-Builder` on an OS not listed here, please feel free to create a pull request if it was successful, or if an error was encountered, please report it as an [issue](https://github.com/epicsNSLS2-deploy/Docker-Builder/issues).

In addition, if you have created a Dockerfile for a distribution not supported by default by `Docker-Builder` feel free to create a pull request.

### Install Configurations

Docker builder supports building any install configurations that can be read by `installSynApps`. By default, each distribution's docker container clones a copy of the [Install-Configurations](https://github.com/epicsNSLS2-deploy/Install-Configurations) repository, and uses an install configuration located within. To use a different configuration, you may edit the `run_build.sh` script for each distribution, and rerun 
```
./build_image all
```
to re-initiaizlize the docker container. If you prefer to use a local configuration rather than clone it at runtime, add:
```
COPY./PATH_TO_INSTALL_CONFIG ./
```
as the second to last line in the `Dockerfile`. You will also have to rebuild the image. Note that in this case, the image must be rebuilt every time changes are made to the config.

### Future plans

Currently, `Docker-Builder` only works on linux hosts with linux distribution targets. Support for windows is planned, for the future, and should allow for windows and linux builds on windows. 

If you would like any other feature to be added to `Docker-Builder`, please add it as an [issue](https://github.com/epicsNSLS2-deploy/Docker-Builder/issues).

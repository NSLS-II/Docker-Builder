# Docker-Builder

An exploration into using docker containers to trigger builds on all OS with [installSynApps](https://github.com/epicsNSLS2-deploy/installSynApps).

### Setup

For using `Docker-Builder`, you will need an active docker engine installation on a modern linux machine.

Here are links to guides for setting up docker engine for various linux distributions:

* **Ubuntu:** https://docs.docker.com/install/linux/docker-ce/ubuntu/
* **Debian:** https://docs.docker.com/install/linux/docker-ce/debian/
* **Cent-OS:** https://docs.docker.com/install/linux/docker-ce/centos/

**NOTE: Running docker engine on windows allows for running both windows and linux containers, but as of yet Docker-Builder has only been tested on linux.**

### Generating the Images

Docker-Builder works by creating Docker image containers for each OS on your system. When run, these containers clone the [installSynApps](https://github.com/epicsNSLS2-deploy/installSynApps) python module, and use it to clone, build, and package all of EPICS, synApps, and areaDetector.

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

Building each docker images will take several minutes. To ensure that the docker images were created successfully, run:
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
**Note that the distribution name passed to the script must match the isa/ Docker image.**

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

Running a docker image container will place the generated output bundle in the `DEPLOYMENTS` directory in the `Docker-Builder` folder.

### Contributing

The `Docker-Builder` has been tested with `./run_container.sh all` on the following host distributions:

* Ubuntu 18.04 LTS
* Debian 9

If you have used `Docker-Builder` on an OS not listed here, please feel free to create a pull request if it was successful, or if an error was encountered, please report it as an [issue](https://github.com/epicsNSLS2-deploy/Docker-Builder/issues).

In addition, if you have created a Dockerfile for a distribution not supported by default by `Docker-Builder` feel free to create a pull request.

### Future plans

Currently, `Docker-Builder` pulls its install configuration from the upstream of `installSynApps`, meaning that configuration is limited. The intention is to add a `installConfiguration` directory in each distribution's directory to allow fine control of what modules are pulled and built by the container.

If you would like any other feature to be added to `Docker-Builder`, please add it as an [issue](https://github.com/epicsNSLS2-deploy/Docker-Builder/issues).

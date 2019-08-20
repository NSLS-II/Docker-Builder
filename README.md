# Docker-Builder

An exploration into using docker containers to trigger builds on all OS with installSynApps.

### Setup

For using Docker-Builder, you will need an active docker installation on a modern linux machine.

Here are links to guides for setting up Docker engine for various linux distributions:

* **Ubuntu:** https://docs.docker.com/install/linux/docker-ce/ubuntu/
* **Debian:** https://docs.docker.com/install/linux/docker-ce/debian/
* **Cent-OS:** https://docs.docker.com/install/linux/docker-ce/centos/

### Generating the Images

Docker-Builder works by creating Docker image containers for each OS on your system. When run, these containers clone the [installSynApps](https://github.com/epicsNSLS2-deploy/installSynApps) python module, and uses it to clone build and package all of EPICS, synApps, and areaDetector.

To generate the docker container images, clone the Docker-Builder repository with:
```
git clone https://github.com/epicsNSLS2-deploy/Docker-Builder
```
Then enter the directory and run the `build_images.sh` script.
```
cd Docker-Builder
./build_images.sh
```
Building the docker images will take several minutes. To ensure that the docker images were created successfully, run:
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
Note that you will see an image for the distribution containers, and then isa/$DISTRIBUTION, which are the actual build containers. Each container is slightly smaller than 1GB in size.

### Running the Builds

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

The generated containers should be automatically closed once the bundle has been moved to your local machine. In the event that this does not happen, you may free up the docker containers with:
```
docker container prune
```

### Output Bundles

Running a docker image container will place the generated output bundle in the `DEPLOYMENTS` directory in the `Docker-Builder` folder.
# Development Dockerfiles

In some cases it is beneficial to have a development evironment in which you may attempt to build/test EPICS and synApps more manually than
the standard `Docker-Builder` allows. This directory contains Dockerfiles meant to generate such development environments.


To generate a development image, run
```
./build_dev_image.sh $DISTRIBUTION
```
Then, to enter your development environment, use:
```
./init_dev_env.sh $DISTRIBUTION
```
You will enter a bash prompt for your chosen distribution. The installSynApps module will already be cloned in `/epics/utils/installSynApps`
along with a set of install configurations in `/epics/utils/Install-Configurations`.

All dependency packages will already be installed. From here, you may use the container as you wish.

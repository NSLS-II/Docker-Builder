# Docker-Builder Autorun

The simplest way to automate the process of running `Docker-Builder` is to use a cronjob,
and the helper scripts in this directory.

### Setup Docker Images

Begin by following the `README` file in the root of the `Docker-Builder` project to configure the images 
as you wish, and make sure they are built by running:
```
./build_image.sh all
```
and then
```
docker image ls
```
If all the images are shown as expected, you are ready to set up the cronjob. Below is an
example of an expected output of `docker image ls`. Note the `isa/$DISTRO` images are the 
build images, and that each distribution has a generated image.
```
jwlodek@xf10idd-ioc3:/epics/utils/Docker-Builder/autorun$ docker image ls
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
isa/centos7          latest              a14097caf9c1        2 weeks ago         1.65GB
isa/centos8          latest              a6720cd65fbe        2 weeks ago         1.24GB
isa/debian10         latest              8973b9aeba9b        2 weeks ago         884MB
isa/debian9          latest              9e924ad64256        2 weeks ago         840MB
isa/debian8          latest              be4f0b97dbe7        2 weeks ago         683MB
isa/ubuntu19.04      latest              5fe56929e316        2 weeks ago         780MB
isa/ubuntu18.04      latest              14c1fd36a563        2 weeks ago         743MB
isadev/centos8       latest              0de42b00f1ac        2 months ago        1.24GB
isadev/debian10      latest              e1d07a6cf5ac        2 months ago        886MB
isadev/ubuntu18.04   latest              c288ebeb04d2        2 months ago        746MB
```

### Creating a Cronjob

Before we add the crobjob, check that the ADCore version number in the `PREVIOUS_VERSION.txt` file is the current one. Otherwise, the cronjob will execute after setup.

To add a new cronjob use:
```
crontab -e
```
Then, add the following job:
```
00 05 * * * cd $DOCKER_BUILDER/autorun && bash check_and_run_builds.sh >> builds/BUILD_$(date +\%Y-\%m-\%d).log
```
Replacing `$DOCKER_BUILDER` with the absolute path to your `Docker-Builder` folder. This cronjob will run
at 5AM every day, and will check if the ADCore version has changed on github. If it has, it will execute
```
./run_container.sh all
```
and generate bundles for each distribution. These will be placed in `DEPLOYMENTS`

Then add another job:
```
00 07 * * * cd $DOCKER_BUILDER/autorun/builds && bash clear_non_build_logs.sh
```
again, replacing `$DOCKER_BUILDER`. This will remove any logs from cron checks that
did not result in builds i.e. every time the cron runs and ther is not a new areaDetector version.

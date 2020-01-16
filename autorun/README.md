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
If all the images are shown as expected, you are ready to set up the cronjob.

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
Replacing `$DOCKER_BUILDER` with the absolute path to your `Docker-Builder` folder.

Then add another job:
```
00 07 * * * cd $DOCKER_BUILDER/autorun/builds && bash clear_non_build_logs.sh
```
again, replacing `$DOCKER_BUILDER`.

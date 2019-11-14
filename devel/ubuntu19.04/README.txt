Welcome to the Docker-Builder development environment container.

This container has been preloaded with all base dependencies for developing for
EPICS and synApps

In addition, installSynApps and several install configurations have been loaded into the
/epics/utils directory.

You may run

./installCLI.py -c ../Install-Configurations/minConfigureLinux -i /epics/src -p -m

To use installSynApps to create a base build of EPICS in the /epics/src directory,
which you may then use for development purposes.

You may also of course use a more feature-rich configuration, or perform
everything manually.

Good Luck!

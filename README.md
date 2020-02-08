My environment for doing stuff

putting it into a repo, so i will know where to search for it ;-) (also doing that is a good reason to brush it all up)

I tend to put little scripts for personal use into .bashrc as functions or aliases, this way it is easier to look them up.

now that i have this archive there is one more thing to remember - to backup the scripts when they change...

this project is explained in more detail [here](https://mosermichael.github.io/cstuff/all/blog/2019/07/24/goodies.html)

my VIM customizations are explaine [here](https://github.com/MoserMichael/myenv/blob/master/VIMENV.md)

Installation

if you want to install the stuff into your curren user run script ./setup.sh after cloning this repo - it (hopefully) works on ubuntu and fedora.

if you want to install and run the stuff from a docker then run [./set-and-run-in-docker.sh](https://github.com/MoserMichael/myenv/blob/master/setup-and-run-in-docker.sh) ; but that's a very strange environment - the HOME directory is in the docker, so every change to configuration under HOME will be gone once you exit the docker, however it sets the current directory to your real home directory outside of the docker.

by default it installs the environment based on the [setup.sh](https://github.com/MoserMichael/myenv/blob/master/setup.sh) script cloned into the docker from this git repository (-m git) and installs it on a a docker image based on fedora (-b fedora), it starts a bash shell interactively, it changes to the home directory of the current user (outside of the docker)

-m file is used for debugging, when the script ./setup-and-run-indocker.sh is run 

```
./setup-and-run-in-docker.sh [-m <mode>] [-b <distro>] [-c] [-h]

Install my work environment into a docker and run it there; mount the system file system.

-m git | file    : git - install from git url https://github.com/MoserMichael/myenv.git ; 
                   file - get other script files from same directory as this script. 
                    default git

-b ubuntu|fedora : base of docker is either ubuntu latest or fedora latest. default: fedora

-v               : verbose mode

-c               : clean the docker image and exit.

-h               : show help

```

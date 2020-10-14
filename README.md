# My environment for doing stuff

putting it into a repo, so i will know where to search for it ;-) (also doing that is a good reason to brush it all up)

I tend to put little scripts for personal use into .bashrc as functions or aliases, this way it is easier to look them up.

now that i have this archive there is one more thing to remember - to backup the scripts when they change...

this project is explained in more detail [here](https://mosermichael.github.io/cstuff/all/blog/2019/07/24/goodies.html)

my VIM customizations are explaine [here](https://github.com/MoserMichael/myenv/blob/master/VIMENV.md)

# Installation

if you want to install the stuff into your curren user run script ./setup.sh after cloning this repo - it (hopefully) works on ubuntu and fedora.

if you want to install and run this project from a docker based environment then run [./set-and-run-in-docker.sh](https://github.com/MoserMichael/myenv/blob/master/setup-and-run-in-docker.sh) ; but that's a very strange environment - the HOME directory is in the docker, so every change to configuration under HOME will be gone once you exit the docker, however it sets the current directory to your real home directory outside of the docker.

by default it installs the environment based on the [setup.sh](https://github.com/MoserMichael/myenv/blob/master/setup.sh) script cloned into the docker from this git repository (-m git) and installs it on a a docker image based on fedora (-b fedora), it starts a bash shell interactively, it changes to the home directory of the current user (outside of the docker)

-m file is used for debugging, when the script ./setup-and-run-indocker.sh is run.

This script requires docker and git.

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







# short description of aliases and scripts 

```
     aboutgitarchive show all sort of stuff about the current git repository
                 ctg build ctags for all c++ source files under current direcory
         dockerclean delete everything in docker registry
  dockercleanunnamed clean out unused stuff to free up disk space.
      dockerimageget <docker image> <tarfile> copies content of image into tar file.
       dockerimagels <docker image>; list content of docker image without running the container. (preferable)
    dockerimagesizes show size of docker images in human readable form
  dockerrunimagebash <docker-image> run a docker image and get you a shell with a contaiener using that image (if image has bash)
       dockerstopall stop & remove all docker containers
                   e [<file>] start vim
                ebig [<file>] start vim for editing very big files
               errno <error number> greps up the error code in include files under /usr/ (reason is in comment displayed)
         findcppmain find main functions in c++ source files (entry point when looking at stuff)
          findgomain find main functions in go source files (looking for entry point when looking at stuff)
                  gb show current git branch
   gitcleanuntracked clean all untracked files and directories
             gitdiff git diff with line numbers!
            gitdiffc git diff with colors and line numbers!
    gitfilesincommit <commit-sha>  to show files in commit
            gitgraph git log as tree
             gitgrep <search-term> run git grep from the repositories root directory - and put in full path name on all matching files.
          gitgrepall <search-term> run git grep from the repositories root directory in all remote branches!
      gitshowdeleted show deleted files in git
          gitstatall git status does not show all files (thosed in .ignored are not shown) this one shows them all.
       gitundodelete <file>  bring back a deleted file in git
              giturl show orign + url that this git repo is looking at
              gotags build tags for all go source files under current direcory
               gpush some projects at redhat force you to add a sign-off to each commit; this automates the process.
                   h <term>  show man page for <term>; prompt for man page if multiple pages for <term>
                   m alias for running make
       mergencommits <number> merge a number of the last <number> commits
     mergetwocommits merge the last two commits
                   p <search-term> grep alias for searching in python files under current directory
            pstopcpu list processes with top cpu usage on top (first column in red)
            pstopmem list processes with top memory usage on top (first column in red)
                   s <search-term> grep alias for searching in cpp files under current directory
                  sa <search-term> grep alias for searching in all files under current directory
                  sg <search-term> grep alias for searching in all go source files under current directory
                show show help text on all utility aliases/functions that have <name>_usage variable defined
   showunhealthypods show only pods that are not quite well.
        straceprefix put this before command to run strace (put into strace.log)
                  tk <session-name> kill a tmux session (with completion)
                 tls lists all tmux sessions
                  tn <session-name> creates a new tmux session
         whoisauthor show who are the most frequent authors in the current git repository

** scripts ***

             beep.sh: makes a short beep.
 del-all-printers.sh: delete all printers
 docker-push-repo.sh: -u <user> -i <image name to upload>  -n <docker repository name> -r <registry> : upload docker image to public registry.
     find-replace.sh: -s <source filter> -f <from> -t <to> [-v -h] : find replace in multiple files
get-all-resource-in-namespace.sh: -s <namespace> : show all kubernetes objects that exist in namspace
   ls-deployments.sh: [-n <namespace>] show kubernetes deployments with containers, their image and command 
      merge_plans.py: processing my plan.txt formatted text files
             nocolor: filter in pipeline - to remove color escape codes from text stream
         pod-logs.sh: -p <podname> [-n <namespace>] : for a pod - show logs of its containers
record-screen-cli.sh: record a demo from screen using ffmpeg
 scale-deployment.sh: -d <depl.name> [-n <depl.namespace>] -s <inst.count> -t <timeout> : scale a deployment with timeout
size-of-git-repos.sh: find all git repos and show their sizes
          ssh-big.sh: compress big files and scp them / untar at destination
          teenocolor: like tee, remove colors escape codes before writing to file
```

# scripts in more detail

[link to beep.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//beep.sh)
```
./scripts/beep.sh [-h|<frequency>]

makes  short beep. (default frequency 1000)

used the following to install it on fedora:
sudo dnf install sox pavucontrol alsa-utils 

```
[link to docker-push-repo.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//docker-push-repo.sh)
```
Usage: ./scripts/docker-push-repo.sh -u <user> -i <image name to upload>  -n <docker repository name> -r <registry>  [-v] [-h] 

-i <image name to upload>
-n <docker repository name>
-r <docker registry>            : defaults to quay.io
-u <docker registry user>

environment variable DOCKER_REGISTRY_PASSWORD must be set to the docker repository password.

-v : verbose run
-h : help

Uploads the <image name to upload> to <registry>/<docker repository name> (by default the quay.io registry is used for -r)
Logs into registry before pushing the password, and logs out after that.
Uses <user> and environment varialbe DOCKER_REGISTRY_PASSWORD for the password

```
[link to find-replace.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//find-replace.sh)
```
./scripts/find-replace.sh -s <source filter> -f <from> -t <to> [-v -h]

apply replace to multiple input ifles

-s <source filter>      : specify input files; available values: cpp git go py shell 
-f <from>               : replace from
-t <to>                 : replace to
-r                      : report how many files were changed.

source filter runs find and then it pipes it into sed to replace it.

```
[link to get-all-resource-in-namespace.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//get-all-resource-in-namespace.sh)
```
./scripts/get-all-resource-in-namespace.sh -

show all kubernetes objects that exist in namspace

-n <namespace>      : the namespace (required)
-o					: for each of these objects - dump as json (default off)
-h					: show help

```
[link to ls-deployments.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//ls-deployments.sh)
```
Usage: ./scripts/ls-deployments.sh -n <namespace> [-v] [-h] 

-v : verbose run
-h : help

list the name of all kubernetes deployments in a namespace given by -n option. (if no -n option then applies to all namespaces)
for each deployment it also displays for each container its name, image and command

requires: kubectl and jq

```
[link to merge_plans.py](https://github.com/MoserMichael/myenv/blob/master/scripts//merge_plans.py)
```
usage: merge_plans.py [-h] [--infile [infile [infile ...]]] [--shows]
                      [--check] [--sort] [--merge]

Parsing and processing of a structured plan file. My plan files have the
following header followed by text line, up until the next header: regex for
parsing header line: (-+)(\d\d)/(\d\d)/(\d+) (\d\d):(\d\d):(\d\d)(-+)

optional arguments:
  -h, --help            show this help message and exit
  --infile [infile [infile ...]], -i [infile [infile ...]]
                        Input file name
  --shows, -s           Show the file entries to standard output
  --check, -c           Check if the file is sorted by date
  --sort, -q            Sort entries by date an time, print to standard output
  --merge, -m           Merge two files, on conditio that they are both
                        sorted.
```
[link to nocolor](https://github.com/MoserMichael/myenv/blob/master/scripts//nocolor)
```
filter in pipeline - to remove color escape codes from text stream
```
[link to pod-logs.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//pod-logs.sh)
```
Usage: ./scripts/pod-logs.sh -p <podname> [-n <namespace>] [-v] [-h] 

-p : <podname> (optional)
-n : <namespace> (optional)
-v : verbose run
-h : help

1) describes the pod (kubectl describe pod <podname> -n <namespace>)
2) for each container in the pod template:
     - show the container definition from the template
     - show the log for that container as part of the pod
3) if -p is missing then it displays log/info on all pods in the namespace
is supposed to help with debugging pod problems

```
[link to record-screen-cli.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//record-screen-cli.sh)
```
./scripts/record-screen-cli.sh [-x <x-offset>] [-y <y-offset>] [-f <filename>] [-r <framerate>] [-a <audio src index>] [-v -h]

capture video from screen & record video from a input source.
    -f <filename>   : output filename to hold the recording. default value: output.mkv 
    -r <framerate>  : recorded framerate. default value 10 frames per second. 
    -x <x-offset>   : x - offset (default value 100 )
    -y <y-offset>   : y - offset (default value 200 )
    -w <second>     : wait <seconds> before recording. default value 2
    -a <audio idx>  : by default a menu is displayed to choose an audio input source. 
                      this option presets an index (1..) from list as the actual choice. 
    -h              : show this help message
    -v              : verbose tracing.

```
[link to scale-deployment.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scale-deployment.sh)
```
./scripts/scale-deployment.sh  [-v -h] -d <depl.name> [-n <depl.namespace>] -s <inst.count> -t <timeout>

scale a kubernetes deployment

-d <deployment name>		: name of deployment object
-n <deployment namespace>	: namespce of deployment
-s <number of instances>	: number of instances to scale to. zero means stop all pods.
-t <timeout> 				: default timeout is 30 seconds

Scales a kubernetes deployment and waits for the deployment to reach the desired number of instances.
It waits while there are any pods terminating, and while the number of running pods is not equal to desired scale,
or if the timeout has been reached while waiting for the pods to start.

```
[link to size-of-git-repos.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//size-of-git-repos.sh)
```
finds all subdirectories of the current directory that have git repos (that include directory .git)
shows the size of the git repository in human readable form.

this can be usefull when you have to cleanup your disk and make some space.
```
[link to ssh-big.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//ssh-big.sh)
```
./scripts/ssh-big.sh -f <big-file1> [-f <big_file2> ..] -r <user@host:/directory> [-i <identity_file>]

compress a set of input file into tar archive (gzipped) and transfer the archive to host via scp; open the tar archive via ssh.

Often the transfer of big files takes a lot of time over a slow connection; this script saves some time by 
compressing the big file first.

Options:

-i <identity_file> : ssh identity file.
-f <bigfile>       : input file (can have multiple)
-r <user@host:/directory> : remote location

```
[link to teenocolor](https://github.com/MoserMichael/myenv/blob/master/scripts//teenocolor)
```
./scripts/teenocolor <file>

like tee but removes colors escape codes from the input stream before logging it to the <file>
leaves stdout unaltered.

```

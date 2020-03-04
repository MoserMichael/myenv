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


# Various scripts in script directory





[link to delete-all-printers.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/delete-all-printers.sh)
```
delete all printers
```
[link to docker-push-repo.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/docker-push-repo.sh)
```
Usage: ./scripts/docker-push-repo.sh -u &lt;user&gt; -i &lt;image name to upload&gt;  -n &lt;docker repository name&gt; -r &lt;registry&gt;  [-v] [-h] 

-i &lt;image name to upload&gt;
-n &lt;docker repository name&gt;
-r &lt;docker registry&gt;            : defaults to quay.io
-u &lt;docker registry user&gt;

environment variable DOCKER_REGISTRY_PASSWORD must be set to the docker repository password.

-v : verbose run
-h : help

Uploads the &lt;image name to upload&gt; to &lt;registry&gt;/&lt;docker repository name&gt; (by default the quay.io registry is used for -r)
Logs into registry before pushing the password, and logs out after that.
Uses &lt;user&gt; and environment varialbe DOCKER_REGISTRY_PASSWORD for the password

```
[link to find-replace.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/find-replace.sh)
```
./scripts/find-replace.sh -s &lt;source filter&gt; -f &lt;from&gt; -t &lt;to&gt; [-v -h]

apply replace to multiple input ifles

-s &lt;source filter&gt;      : specify input files; available values: cpp git go py shell 
-f &lt;from&gt;               : replace from
-t &lt;to&gt;                 : replace to
-r                      : report how many files were changed.

source filter runs find and then it pipes it into sed to replace it.

```
[link to list-deployments-with-images.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/list-deployments-with-images.sh)
```
Usage: ./scripts/list-deployments-with-images.sh -n &lt;namespace&gt; [-v] [-h] 

-v : verbose run
-h : help

list the name of all kubernetes deployments in a namespace given by -n option. (if no -n option then applies to all namespaces)
for each deployment it also displays for each container its name, image and command

requires: kubectl and jq

```
[link to pod-logs.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/pod-logs.sh)
```
Usage: ./scripts/pod-logs.sh -p &lt;podname&gt; [-n &lt;namespace&gt;] [-v] [-h] 

-p : &lt;podname&gt;
-n : &lt;namespace&gt; (optional)
-v : verbose run
-h : help

1) describes the pod (kubectl describe pod &lt;podname&gt; -n &lt;namespace&gt;)
2) for each container in the pod template:
     - show the container definition from the template
     - show the log for that container as part of the pod

is supposed to help with debugging pod problems

```
[link to record-from-screen-cli.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/record-from-screen-cli.sh)
```
./scripts/record-from-screen-cli.sh [-x &lt;x-offset&gt;] [-y &lt;y-offset&gt;] [-f &lt;filename&gt;] [-r &lt;framerate&gt;] [-a &lt;audio src index&gt;] [-v -h]

capture video from screen & record video from a input source.
    -f &lt;filename&gt;   : output filename to hold the recording. default value: output.mkv 
    -r &lt;framerate&gt;  : recorded framerate. default value 10 frames per second. 
    -x &lt;x-offset&gt;   : x - offset (default value 100 )
    -y &lt;y-offset&gt;   : y - offset (default value 200 )
    -w &lt;second&gt;     : wait &lt;seconds&gt; before recording. default value 2
    -a &lt;audio idx&gt;  : by default a menu is displayed to choose an audio input source. 
                      this option presets an index (1..) from list as the actual choice. 
    -h              : show this help message
    -v              : verbose tracing.

```
[link to scale-deployment.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/scale-deployment.sh)
```
./scripts/scale-deployment.sh  [-v -h] 

scale a kubernetes deployment

-d &lt;deployment name&gt;		: name of deployment object
-n &lt;deployment namespace&gt;	: namespce of deployment
-s &lt;number of instances&gt;	: number of instances to scale to. zero means stop all pods.
-t &lt;timeout&gt; 				: default timeout is 30 seconds

Scales a kubernetes deployment and waits for the deployment to reach the desired number of instances.
It waits while there are any pods terminating, and while the number of running pods is not equal to desired scale,
or if the timeout has been reached while waiting for the pods to start.

```
[link to size-of-git-repos.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/size-of-git-repos.sh)
```
4.7M	./.git
```
[link to ssh-big.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/ssh-big.sh)
```
./scripts/ssh-big.sh -f &lt;big-file1&gt; [-f &lt;big_file2&gt; ..] -r &lt;user@host:/directory&gt; [-i &lt;identity_file&gt;]

compress a set of input file into tar archive (gzipped) and transfer the archive to host via scp; open the tar archive via ssh.

Often the transfer of big files takes a lot of time over a slow connection; this script saves some time by 
compressing the big file first.

Options:

-i &lt;identity_file&gt; : ssh identity file.
-f &lt;bigfile&gt;       : input file (can have multiple)
-r &lt;user@host:/directory&gt; : remote location

```
[link to ssh-to-node.sh](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/ssh-to-node.sh)
```
Usage: ./scripts/ssh-to-node.sh -n &lt;nodename&gt; [-v] [-h] 

-n : Runs shell on kubernetes node specified by -n option.
     Note: uses oc in path and current cluster configuration.
-v : verbose run
-h : help

Runs privileged pod on node and does ssh to that node;
```
[link to teenocolor](https://github.com/MoserMichael/myenv/blob/master/scripts//scripts/teenocolor)
```
./scripts/teenocolor &lt;file&gt;

like tee but removes colors escape codes from the input stream before logging it to the &lt;file&gt;
leaves stdout unaltered.

```

# Aliases and functions added in .bashrc

```
     aboutgitarchive show all sort of stuff about the current git repository
                 ctg build ctags for all c++ source files under current direcory
         dockerclean delete everything in docker registry
  dockercleanunnamed clean out unused stuff to free up disk space.
       dockerimagels &lt;docker image&gt;; list content of docker image without running the container. (preferable)
    dockerimagesizes show size of docker images in human readable form
  dockerrunimagebash &lt;docker-image&gt; run a docker image and get you a shell with a contaiener using that image (if image has bash)
                   e [&lt;file&gt;] start vim
                ebig [&lt;file&gt;] start vim for editing very big files
         findcppmain find main functions in c++ source files (entry point when looking at stuff)
          findgomain find main functions in go source files (looking for entry point when looking at stuff)
                  gb show current git branch
   gitcleanuntracked clean all untracked files and directories
    gitfilesincommit &lt;commit-sha&gt;  to show files in commit
            gitgraph git log as tree
             gitgrep &lt;search-term&gt; run git grep from the repositories root directory - and put in full path name on all matching files.
      gitshowdeleted &lt;file&gt; show deleted files in grep
          gitstatall git status does not show all files (thosed in .ignored are not shown) this one shows them all.
       gitundodelete &lt;file&gt;  bring back a deleted file in git
              giturl show url that this git repo is looking at
             gorigin show origin of branch
              gotags build tags for all go source files under current direcory
               gpush some projects at redhat force you to add a sign-off to each commit; this automates the process.
                   m alias for running make
       mergencommits &lt;number&gt; merge a number of the last &lt;number&gt; commits
     mergetwocommits merge the last two commits
             nocolor filter in pipeleine - to remove color escape codes from text stream
                   p &lt;search-term&gt; grep alias for searching in python files under current directory
                   s &lt;search-term&gt; grep alias for searching in cpp files under current directory
                  sa &lt;search-term&gt; grep alias for searching in all files under current directory
                  sg &lt;search-term&gt; grep alias for searching in all go source files under current directory
                show show help text on all utility aliases/functions that have &lt;name&gt;_usage variable defined
   showunhealthypods show only pods that are not quite well.
                  tk &lt;session-name&gt; kill a tmux session (with completion)
                 tls lists all tmux sessions
                  tn &lt;session-name&gt; creates a new tmux session
              topmem top: show processes ordered by memory consumption
         whoisauthor show who are the most frequent authors in the current git repository
```

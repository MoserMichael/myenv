#!/bin/bash

set -e

DOCKER_BASE=fedora
GIT_URL=https://github.com/MoserMichael/myenv.git
MODE=git
CLEAN=off

function Help {
    if [[ $1 != "" ]]; then
        echo "Error: $*"
    fi

cat <<EOF
$0 [-m <mode>] [-b <distro>] [-c] [-h]

Install my work environment into a docker and run it there; mount the system file system.

-m git | file  	 : git - install from git url $GIT_URL ; 
		   file - get other script files from same directory as this script. 
		    default $MODE

-b ubuntu|fedora : base of docker is either ubuntu latest or fedora latest. default: $DOCKER_BASE

-v		 : verbose mode

-c		 : clean the docker image and exit.

-h		 : show help

EOF

exit 1
}

while getopts "hcvm:b:" opt; do
  case ${opt} in
    h)
	Help
	;;
    b)
	DOCKER_BASE=$OPTARG
	;;
    m)
	MODE=$OPTARG
	;;
    c)	
	CLEAN=on
	;;
    v)
	set -x
	export PS4='+(${BASH_SOURCE}:${LINENO})'
	VERBOSE=1
    ;; 
    *)
    Help "Invalid option"
    ;;
  esac
done

if [[ "$MODE" != "file" ]] && [[ "$MODE" != "git" ]]; then
	Help "invalid value for -m option"
fi

if [[ "$DOCKER_BASE" != "ubuntu" ]] && [[ "$DOCKER_BASE" != "fedora" ]]; then 
	Help "invalid value for -b option"
fi


if [[ "$DOCKER_BASE" == "ubuntu" ]]; then
	ENV_IMAGE_BASE=my-devenv-ubuntu 
else 
  if [[ $DOCKER_BASE == "fedora" ]]; then 
	ENV_IMAGE_BASE=my-devenv-fedora
  else 
	echo "invalid value of DOCKER_BASE. Either set to ubuntu or fedora"
	exit 1
  fi
fi

ENV_IMAGE=${ENV_IMAGE_BASE}:latest

if [[ "$CLEAN" == "on" ]]; then
	echo "deleting docker image $ENV_IMAGE"
	docker rmi $ENV_IMAGE
	exit
fi


HAS_IMAGE=$(docker images | sed '1d' | awk '{ print $1 ":" $2 }' | grep $ENV_IMAGE | wc -l)

if [[ "$HAS_IMAGE" == "0" ]]; then
	docker_file=$(mktemp /tmp/tmp-dockerfile.XXXXXX) 

	if [[ "$DOCKER_BASE" == "fedora" ]]; then
		echo "*** building fedora image ***"
		if [[ "$MODE" == "file" ]]; then
	cat >${docker_file} <<EOF
FROM docker.io/fedora:latest
WORKDIR /root
# workaround for 'Failed to download metadata for repo 'fedora-modular' ?
#RUN dnf config-manager --disable-repo fedora-modular 
RUN dnf -y update
RUN dnf -y install sudo procps findutils git
COPY setup.sh /root/setup.sh
ENV GOPATH /root/go
RUN mkdir /root/go
COPY .vimrc /root/.vimrc
COPY .bashrc /root/.bashrc
COPY .tmux.conf  /root/.tmux.conf
RUN ./setup.sh docker
RUN  bash -c 'echo "cd /mnt/mysys/$HOME" >> /root/.bashrc'
EOF
	 	else # from git

	cat >${docker_file} <<EOF
FROM docker.io/fedora:latest
WORKDIR /root
RUN dnf -y update
RUN dnf -y install sudo procps findutils git
RUN bash -c "cd /root; find . -name '*' | xargs rm -rf; true"
RUN git clone $GIT_URL /root/
ENV GOPATH /root/go
RUN mkdir /root/go
RUN ./setup.sh docker
RUN  bash -c 'echo "cd /mnt/mysys/$HOME" >> /root/.bashrc'
EOF
         	fi

    else 
    if [[ $DOCKER_BASE == "ubuntu" ]]; then 

		echo "*** building ubuntu image ***"
	  	if [[ "$MODE" == "file" ]]; then
cat >${docker_file} <<EOF
FROM docker.io/ubuntu:latest
WORKDIR /root

# some package installer requires tzinfo setup, tell it to install noninteractively.
ENV DEBIAN_FRONTEND=noninteractive 

COPY setup.sh /root/setup.sh

# from https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
# some package installer requires tzinfo setup, tell it to install noninteractively.
RUN apt-get -qy update && DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends tzdata 

RUN apt-get -qy install sudo procps findutils git
COPY setup.sh /root/setup.sh
ENV GOPATH /root/go
RUN mkdir /root/go
COPY .vimrc /root/.vimrc
COPY .bashrc /root/.bashrc
COPY .tmux.conf  /root/.tmux.conf
RUN ./setup.sh docker
RUN  bash -c 'echo "cd /mnt/mysys/$HOME" >> /root/.bashrc'
EOF
		else  # from git
cat >${docker_file} <<EOF
FROM docker.io/ubuntu:latest
WORKDIR /root

COPY setup.sh /root/setup.sh

# from https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
# some package installer requires tzinfo setup, tell it to install noninteractively.
RUN apt-get -qy update && DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends \
        tzdata 

RUN apt-get -qy install sudo procps findutils git
RUN bash -c "cd /root; find . -name '*' | xargs rm -rf; true"
RUN git clone $GIT_URL  /root/
ENV GOPATH /root/go
RUN mkdir /root/go
RUN ./setup.sh docker
RUN  bash -c 'echo "cd /mnt/mysys/$HOME" >> /root/.bashrc'
EOF
		fi 
	fi
	fi
	
	docker build . -f ${docker_file} -t $ENV_IMAGE 
	docker tag $ENV_IMAGE_BASE $ENV_IMAGE
	rm -f ${docker_file}
fi

echo "Running environment in docker"
docker run --rm -it -v /:/mnt/mysys  $ENV_IMAGE /bin/bash


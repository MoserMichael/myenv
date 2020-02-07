#!/bin/bash

set -ex

DOCKER_BASE=fedora

if [[ "$DOCKER_BASE" == "ubuntu" ]]; then
	ENV_IMAGE_BASE=my-devenv-ubuntu 
else 
  if [[ $DOCKER_BASE == "fedora" ]]; then 
	ENV_IMAGE_BASE=my-devenv-fedora
  else 
	echo "invalid value of DOCKER_BASE. Either set to ubuntu or fedora"
  fi
fi

ENV_IMAGE=${ENV_IMAGE_BASE}:latest

HAS_IMAGE=$(docker images | sed '1d' | awk '{ print $1 ":" $2 }' | grep $ENV_IMAGE | wc -l)

if [[ "$HAS_IMAGE" == "0" ]]; then
	docker_file=$(mktemp /tmp/tmp-dockerfile.XXXXXX) 

	if [[ "$DOCKER_BASE" == "fedora" ]]; then
		echo "*** building fedora image ***"
	cat >${docker_file} <<EOF
FROM docker.io/fedora:latest
WORKDIR /root
COPY setup.sh /root/setup.sh
RUN dnf -y update
RUN dnf -y install sudo
ENV GOPATH /root/go
RUN mkdir /root/go
RUN ./setup.sh docker
COPY .vimrc /root/.vimrc
COPY .bashrc /root/.bashrc
COPY .vimrc  /root/.vimrc
EOF
	else 
		if [[ $DOCKER_BASE == "ubuntu" ]]; then 

			echo "*** building ubuntu image ***"

cat >${docker_file} <<EOF
FROM docker.io/ubuntu:latest
WORKDIR /root
COPY setup.sh /root/setup.sh
RUN apt-get -qy update
RUN apt-get -qy install sudo
ENV GOPATH /root/go
RUN mkdir /root/go
RUN ./setup.sh docker
COPY .vimrc /root/.vimrc
COPY .bashrc /root/.bashrc
COPY .vimrc  /root/.vimrc
EOF

		fi
	fi
	docker build . -f ${docker_file} -t $ENV_IMAGE 
	docker tag $ENV_IMAGE_BASE $ENV_IMAGE
	rm -f ${docker_file}
fi

echo "home directory is in /mnt/myuser within the docker"
docker run --rm -it -v $HOME:/mnt/myuser  $ENV_IMAGE /bin/bash


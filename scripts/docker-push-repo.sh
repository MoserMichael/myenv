#!/bin/bash

set -e

function Exit 
{
    echo "Error: $@"
    exit 1
}

function Help()
{
    if [[ $1 != "" ]]; then
        echo "Error: $*"
    fi
    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "-u <user> -i <image name to upload>  -n <docker repository name> -r <registry> : upload docker image to public registry."
        exit 1
    fi


	cat <<EOF
Usage: $0 -u <user> -i <image name to upload>  -n <docker repository name> -r <registry>  [-v] [-h] 

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

EOF
	exit 1
}

DOCKER_REGISTRY=quay.io

while getopts "hvu:i:n:r:" opt; do
  case ${opt} in
    h)
	Help
        ;;
    u)
        DOCKER_REGISTRY_USER=$OPTARG
        ;;
    i)
        IMAGE_NAME_WITH_TAG=$OPTARG
        ;;
    n)
        DOCKER_REGISTRY_REPOSITORY_NAME=$OPTARG
        ;;
    r)
        DOCKER_REGISTRY=$OPTARG
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

if [[ "$IMAGE_NAME_WITH_TAG" == "" ]]; then
    Help "please set -u <option>"
fi
has_image=$(docker images | sed '1d' | awk '{ print $1":"$2 }' |  grep -E "^${IMAGE_NAME_WITH_TAG}$" | wc -l)
if [[ "$has_image" == "0" ]]; then
    Help "no local docker image ${IMAGE_NAME_WITH_TAG} exists"
fi

if [[ "$DOCKER_REGISTRY_USER" == "" ]]; then
    Help "please set -u option"
fi

if [ "$DOCKER_REGISTRY_PASSWORD" == "" ]; then
    Help "please set environment variable DOCKER_REGISTRY_PASSWORD so that script can log into registry"
fi

if [[ "$DOCKER_REGISTRY" == "" ]]; then
    Help "please set -r option"
fi

(echo -n "$DOCKER_REGISTRY_PASSWORD" | docker login -u "$DOCKER_REGISTRY_USER" --password-stdin ${DOCKER_REGISTRY}) || Exit "can't login to docker"

set -x

CONTAINER_SHA=$(docker container create $IMAGE_NAME_WITH_TAG)

docker commit "${CONTAINER_SHA}" ${DOCKER_REGISTRY}/${DOCKER_REGISTRY_USER}/${DOCKER_REGISTRY_REPOSITORY_NAME}

docker push ${DOCKER_REGISTRY}/${DOCKER_REGISTRY_USER}/${DOCKER_REGISTRY_REPOSITORY_NAME}

docker container rm ${CONTAINER_SHA}

docker logout ${DOCKER_REGISTRY} 

echo "*** pushed successfully. remember to set access in repo UI, can't do that from command line ***"

#!/bin/bash

#set -x

KCMD=kubectl
function Help()
{
    cat <<EOF
Usage: $0 -n <namespace> [-v] [-h] 

-v : verbose run
-h : help

list the name of all deployments in a namespace given by -n option. (if no -n option then applies to all namespaces)
for each deployment it also displays for each container its name, image and command

requires: $KCMD and jq

EOF
    exit 1
}

POD_NSPACE_SPEC="--all-namespaces"
while getopts "hvn:p:" opt; do
  case ${opt} in
    h)
	Help
        ;;
    n)
        POD_NSPACE_SPEC=" -n $OPTARG "
        POD_NSPACE="$OPTARG "
        ;;
    p)
        POD_NAME=$OPTARG
        ;;
    v)
	set -x
	export PS4='+(${BASH_SOURCE}:${LINENO}) '
	VERBOSE=1
        ;; 
    *)
        echo "Invalid Option"
        Help
        ;;
   esac
done	



function tokenize {                                                                                                                                                                                                                           
  local OLD_IFS                                                                                                                                                                                                                               
                                                                                                                                                                                                                                              
  OLD_IFS=$IFS                                                                                                                                                                                                                                
  IFS=$1 read -d '' -r -a TOKEN_ARRAY <<< "$2" || true                                                                                                                                                                                        
  IFS=$OLD_IFS                                                                                                                                                                                                                                
}   


DEPLOYMENTS=$($KCMD get deployments $POD_NSPACE_SPEC --no-headers )

function dep_info {
  echo "deployment: $DEP_NAME namespace: $NAMESPACE"
  $KCMD get deployment -n $NAMESPACE $DEP_NAME -o json  | jq '.spec | .template | .spec | .containers | .[] | "container-info name: " + .name + " image: " + .image + " command: " + ( .command // [] | join(" ")) ' 
}

if [[ "$POD_NSPACE" == "" ]]; then
	while read -r line; do 

	  echo ""
	  tokenize ' ' "$line"                                                                                                                                                                                                                
	  NAMESPACE=${TOKEN_ARRAY[0]}
	  DEP_NAME=${TOKEN_ARRAY[1]}

	  dep_info
	done <<< "$DEPLOYMENTS"
else 
	while read -r line; do 

	  echo ""
	  tokenize ' ' "$line"                                                                                                                                                                                                                
	  NAMESPACE="$POD_NSPACE"
	  DEP_NAME=${TOKEN_ARRAY[0]}

	  dep_info
        done <<< "$DEPLOYMENTS"

fi

   


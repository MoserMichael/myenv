#!/bin/bash

set -e

KCMD=kubectl

function Help()
{
    if [[ "$1" != "" ]]; then
        echo "Error: $@"
    fi 

    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "-p <podname> [-n <namespace>] : for a pod - show logs of its containers"
        exit 1
    fi


    cat <<EOF
Usage: $0 -p <podname> [-n <namespace>] [-v] [-h] 

-p : <podname> (optional)
-n : <namespace> (optional)
-v : verbose run
-h : help

1) describes the pod ($KCMD describe pod <podname> -n <namespace>)
2) for each container in the pod template:
     - show the container definition from the template
     - show the log for that container as part of the pod
3) if -p is missing then it displays log/info on all pods in the namespace
is supposed to help with debugging pod problems

EOF
    exit 1
}

log_pod() {

CMD="$KCMD describe pod $POD_NAME $POD_NSPACE_SPEC"
cat <<EOF

**** describe pod: $POD_NAME namespace: $POD_NSPACE
**** command: $CMD

EOF

$CMD

CONTAINER_NAMES=$($KCMD get pod $POD_NAME $POD_NSPACE_SPEC  -o=jsonpath='{.spec.containers[*].name}') 

cat << EOF

*** pod: $POD_NAME namespace: $POD_NAMESPACE containers: ${CONTAINER_NAMES}

EOF

CONTAINER_COUNT=0
for containername in $CONTAINER_NAMES; do
    
    cat <<EOF

**** container spec. container-name: $containername  in pod: $POD_NAME namespace: $POD_NSPACE 

EOF
    $KCMD get pod $POD_NAME $POD_NSPACE_SPEC -o=json | jq '.spec.containers['"$CONTAINER_COUNT"']'

    CMD="$KCMD logs $POD_NAME $POD_NSPACE_SPEC -c $containername"

    cat <<EOF

**** container logs. container-name: $containername in pod: $POD_NAME namespace: $POD_NSPACE 
**** command: $CMD

EOF
    $CMD

    ((CONTAINER_COUNT+=1))
done

}

while getopts "hvn:p:" opt; do
  case ${opt} in
    h)
	Help
        ;;
    n)
        POD_NSPACE=$OPTARG
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
        Help "Inavlid option"
        ;;
   esac
done	

if [[ "$POD_NSPACE" != "" ]]; then
  POD_NSPACE_SPEC="-n $POD_NSPACE"
fi

if [[ "$POD_NAME" == "" ]]; then

	for line in $($KCMD get pods -n ${POD_NSPACE} | sed '1d' | awk '{ print $1 }'); do
		POD_NAME="$line"
		log_pod
	done
	exit 1
    Help "missing pod name"
fi


log_pod


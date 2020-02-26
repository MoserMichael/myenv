#!/bin/bash

OC="oc --kubeconfig $HOME/dev-scripts/ocp/auth/kubeconfig"


DEPLOYMENT_NAME=""
DEPLOYMENT_NS=""
TIMEOUT=30
NUM_REPLICAS=20

start_deployment() {
    $OC scale deployment --replicas=${NUM_REPLICAS} ${DEPLOYMENT_NAME} -n ${DEPLOYMENT_NS}

    echo "deployment scaled, waiting for adjusting the number of pods..."

    START_TIME=$(date +%s)
    while true; do
        CURRENT_PODS=$($OC get pods -n ${DEPLOYMENT_NS} | grep -E "^$DEPLOYMENT_NAME")
        IS_UP=$(echo "$CURRENT_PODS" | grep -cE "Running")

        NUM_TERMINATING=$(echo "$CURRENT_PODS" | grep -cE "Terminating")

        CUR_TIME=$(date +%s)
        ELAPSED_TIME=$(($CUR_TIME-$START_TIME))

        echo "Running ${IS_UP} Terminating: ${NUM_TERMINATING} Scale target: $NUM_REPLICAS Time: ${ELAPSED_TIME}/${TIMEOUT}"

        if [[ "$NUM_TERMINATING" == "0" ]] && [[ "$IS_UP" == "$NUM_REPLICAS" ]]; then 
           break
        fi

        if [[ "$ELAPSED_TIME" -ge "$TIMEOUT" ]]; then
            echo "Timed out. $ELAPSED_TIME seconds passed"
            echo "pods of deployment: "
            echo "$CURRENT_RUNNING"
            exit 1
        fi
        sleep 1
    done
    echo "*** deployment running  ***"
}

function Help {
    if [[ $1 != "" ]]; then
        echo "Error: $*"
    fi

cat <<EOF
$0  [-v -h] 

scale a kubernetes deployment

-d <deployment name>		: name of deployment object
-n <deployment namespace>	: namespce of deployment
-s <number of instances>	: number of instances to scale to. zero means stop all pods.
-t <timeout> 				: default timeout is $TIMEOUT seconds

Scales a pod and waits for the deployment to reach the desired number of instances.
It waits while there are any pods terminating, and while the number of running pods is not equal to desired scale,
or if the timeout has been reached while waiting for the pods to start.

EOF

exit 1
}

DEPLOYMENT_NAME=""
DEPLOYMENT_NS=""
TIMEOUT=30
NUM_REPLICAS=""


while getopts "hvt:s:n:d:" opt; do
  case ${opt} in
    h)
		Help
        ;;
    v)
		set -x
		export PS4='+(${BASH_SOURCE}:${LINENO})'
		#VERBOSE=1
        ;; 
    d)
	    DEPLOYMENT_NAME="$OPTARG"	
        ;;
    n)
        DEPLOYMENT_NS="$OPTARG"
        ;;
    t)
        TIMEOUT="$OPTARG"
        ;;
    s)
        NUM_REPLICAS="$OPTARG"
        ;;
    *)
        Help "Invalid option"
        ;;
   esac
done	

if [[ $DEPLOYMENT_NAME == "" ]]; then
  Help "missing deployment name. -d option"
fi

if [[ $DEPLOYMENT_NS == "" ]]; then
  Help "missing deployment namespace. -n option"
fi

if [[ $NUM_REPLICAS == "" ]]; then
  Help "missing desired number of replicase name. -s option"
fi

start_deployment






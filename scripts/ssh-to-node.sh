#!/bin/bash -i

KCTL=oc

function Help()
{
	cat <<EOF
Usage: $0 -n <nodename> [-v] [-h] 

-n : Runs shell on kubernetes node specified by -n option.
     Note: uses $KCTL in path and current cluster configuration.
-v : verbose run
-h : help

Runs privileged pod on node and does ssh to that node;
EOF
	exit 1
}

while getopts "hvn:" opt; do
  case ${opt} in
    h)
	Help
        ;;
    n)
        NODE_NAME=$OPTARG
        ;;
    v)
	set -x
	export PS4='+(${BASH_SOURCE}:${LINENO})'
	VERBOSE=1
        ;; 
   esac
done	

if [[ $NODE_NAME == "" ]]; then
  Help
fi


NODENAMES=`$KCTL get nodes --no-headers  | awk '{ print $1 }'`
echo "${NODENAMES}" | grep $NODE_NAME 
if [ $? != 0 ]; then
  echo "Error: node name $NODE_NAME is not defined in cluster"
  $KCTL get nodes
  exit 1
fi


FNAME=$(mktemp /tmp/sshtonode.XXXXXX)
PODNAME=inspectnode$$

cat >${FNAME} <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: ${PODNAME}
  namespace: default
spec:
  containers:
  - name: busybox
    image: busybox
    resources:
      limits:
        cpu: 200m
        memory: 100Mi
      requests:
        cpu: 100m
        memory: 50Mi
    stdin: true
    securityContext:
      privileged: true
    volumeMounts:
    - name: host-root-volume
      mountPath: /host
      readOnly: true
  volumes:
  - name: host-root-volume
    hostPath:
      path: /
  hostNetwork: true
  hostPID: true
  restartPolicy: Never
  nodeSelector:
    kubernetes.io/hostname: ${NODE_NAME}
  nodeName: ${NODE_NAME}
EOF

trap 'rm -f '${FNAME}';${KCTL} delete pod '${PODNAME} INT TERM HUP EXIT

cat ${FNAME}

$KCTL create -f ${FNAME}
if [ $? != 0 ]; then
	echo "Error: failed to create pod. status $?"
	exit 1
fi

echo "* wait for pod to start *"
while [ true ]; 
do
	ST=`$KCTL get pods ${PODNAME} -o wide --no-headers`
	if [ $VERBOSE != 0 ]; then
	  echo "$ST"
	fi
	echo "$ST" | grep Running
	if [ $? == 0 ]; then
		break
	fi
	sleep 1
done

cat << EOF
***
running shell on node ${NODE_NAME};
 run chroot /host to enter host environment
exit twice to return to host (once to escape chroot, second to escape this shell)
***

EOF

$KCTL exec -it ${PODNAME} -c busybox -- /bin/sh 

#!/bin/bash -i


function Help()
{
	cat <<EOF
Usage: $0 -n <nodename> [-v] [-h] 

-n : Runs shell on node  specified by -n option.
     Note: uses kubectl in path and current cluster configuration.
-v : verbose run
-h : help

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
        ;; 
   esac
done	

if [[ $NODE_NAME == "" ]]; then
  Help
fi


NODENAMES=`kubectl get nodes --no-headers  | awk '{ print $1 }'`
echo "${NODENAMES}" | grep $NODE_NAME 
if [ $? != 0 ]; then
  echo "Error: node name $NODE_NAME is not defined in cluster"
  kubectl get nodes
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

trap 'rm -f '${FNAME}';kubectl delete pod '${PODNAME} INT TERM HUP EXIT

cat ${FNAME}

kubectl create -f ${FNAME}

echo "* wait for pod to start *"
while [ true ]; 
do
	ST=`kubectl get pods ${PODNAME} -o wide --no-headers`
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

kubectl exec -it ${PODNAME} -c busybox -- /bin/sh 

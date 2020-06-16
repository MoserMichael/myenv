#!/bin/bash

function Help {
    if [[ $1 != "" ]]; then
        echo "Error: $*"
    fi

    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "-s <namespace> : show all kubernetes objects that exist in namspace"
        exit 1
    fi

cat <<EOF
$0 -

show all kubernetes objects that exist in namspace

-n <namespace>      : the namespace (required)
-o					: for each of these objects - dump as json (default off)
-h					: show help

EOF

exit 1
}

JSON=""
while getopts "hon:" opt; do
  case ${opt} in
    h)
		Help
        ;;
    n)
        NSPACE="$1"
        ;;
	o)
		JSON="-o json"
		;;
	*)
        Help "Invalid option"
        ;;
   esac
done	


if [[ $NSPACE == "" ]]; then

	Help "-n option required"
fi

for f in $(kubectl api-resources  --namespaced=true | sed 's/1d//' | awk '{ print $1 }'); do 
	RET=$(kubectl get -n olm $f -o wide 2>&1) 
	if [[ $? == 0 ]]; then
		NOTFOUND=$(echo "$RET" | grep -c "No resources found")
		if [[ ${NOTFOUND} == "0" ]]; then 
			echo "***"
			echo "kubectl get -n olm $f -o wide" 
			echo ""
			echo "$RET"
			if [[ "$JSON" != "" ]]; then
				echo "kubectl get -n olm $f $JSON" 
				kubectl get -n olm $f $JSON
			fi
		fi 
	fi
done


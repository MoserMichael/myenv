#!/usr/bin/env bash

set -e

Help() {

    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "-d <dir> [-g] : run gotestsum on dir, run go generate (if -g set)"
        exit 1
    fi


    cat <<EOF
$0 [-g] [-d <dir> ]

-g   : run go generate for all files in directory specified by -d option
-d   : run gotestsum for all commands in <dir>
-v   : run verbose (debug)
EOF
    exit 1
}

GENERATE=0
DIR="."

while getopts "hvgd:" opt; do
  case ${opt} in
    h)
	Help
        ;;
    g)
        GENERATE=1
        ;;
    d)
        DIR=$OPTARG
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

if [[ $GENERATE != 0 ]]; then
    go generate $DIR/...
fi

which gotestsum >/dev/null
if [[ $? != 0 ]]; then
    go install gotest.tools/gotestsum@latest
fi
gotestsum --junitfile results.xml  -- -v -p 1 --timeout=2m ${DIR}/...


#!/bin/bash

function Help()
{ 

    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "-f <from_string> -t <to_string> - replace string <from_string> to <to_string> under git"
        exit 1
    fi

    
    cat <<EOF
Usage: $0 [-f <from_string> -t <to_string> [-h]

-v : verbose run
-h : help

-f : from_string
-t : to_string

replace string <from_string> to <to_string> in all files under git, from current dir down.

EOF

exit 1
}

while getopts "hvf:t:" opt; do
  case ${opt} in
    h)
	Help
        ;;
    t)
        TO_STRING=$OPTARG
        ;;
    f)
        FROM_STRING=$OPTARG
        ;;
    v)
        set -x
    	export PS4='+(${BASH_SOURCE}:${LINENO}) '
        ;; 


    *)
        echo "Invalid Option"
        Help
        ;;
   esac
done	

SED=sed

if [[ "$OSTYPE" == "darwin"* ]]; then
    # use gsed and hope you did 'brew install gnu-sed'
    SED=gsed
fi


if [[ $FROM_STRING != "" ]] && [[ $TO_STRING != "" ]]; then
    git ls-files -z | xargs -0 $SED -i -e "s/$FROM_STRING/$TO_STRING/g" 
else
    Help
fi


#!/bin/bash

#
# 1 - fix automatically if wrong
# 0 - report and exit with error
#
FIX_IF_WRONG=0

#
# number of tab stops (used when errors are fixed with expand)
#
TABSTOP=4

#
# expand - convert tabs to spaces
# unexpand - convert spaces to tabs.
#
#
ACTION="unexpand"


FILE_EXTENSION=""

#declare -A explain=( ["expand"]="convert tabs to spaces" ["unexpand"]="convert spaces to tabs" )

VERBOSE=0


function trace_on_total
{
    SCRIPT_TRACE_ON=1
    OLD_PS4=$PS4
    export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
    set -x
}

function Help {
    if [[ $1 != "" ]]; then
        echo "Error: $*"
        echo ""
    fi

cat <<EOF
$0 [-h] [-v] [-f] [-a expand|unexpand] [-t <tabstop>] [-e <file extension> ]

    -f                      : fix files if wrong (default report only)
    -e <file extension>     : file extension of files to check or fix. (example: -e go means all go files)
    -h                      : show help message.
    -a <expand|unexpand>    : action: expand - convert tabs to spaces; unexpand - convert spaces to tabs (default $ACTION)
    -t <tabstop>            : tabstop (default $TABSTOP)
    -v                      : verbose mode

if current directory is in a git repo: fix or report tab/spaces issues in all source file with extension specified by -e option.
if -f is specified then the selected files are fixed, without this option it only checks for compliance.
-a <expand> - convert tabs to spaces; -a <unexpand> - convert spaces to tabs.

EOF
    exit 1
}

while getopts "hfva:t:e:" opt; do
  case ${opt} in
    h)
	    Help
        ;;
    a)
        ACTION="$OPTARG"
        ;;
    f)
        FIX_IF_WRONG=1
        ;;
    t)
        TABSTOP="$OPTARG"
        ;;
    v)
        ((VERBOSE+=1))
        ;;
    e)
        FILE_EXTENSION="$OPTARG"
        ;;
    *)
        Help "Invalid option"
        ;;
   esac
done	

if [[ $VERBOSE == 2 ]]; then
   trace_on_total
fi

if [[ $ACTION != "expand" ]] && [[ $ACTION != "unexpand" ]]; then
    echo "action should be either expand or unexpand"
    Help "Invalid value of -f option"
fi

if [[ $FILE_EXTENSION == "" ]]; then
    Help "must specify a file extension with -f <file extension>"
fi

tmpfile=$(mktemp /tmp/tmpvim-enforce-spaces.XXXXX)

function check_file {
    local FILE="$1"

    $ACTION -t $TABSTOP "$FILE" >$tmpfile
    if [[ $? != 0 ]]; then 
        echo "can't copy $FILE to $tmpfile error: $?"
        exit 1
    fi


    diff $tmpfile $FILE >/dev/null

    stat=$?

    if [[ $stat == 2 ]]; then
        echo "failed to compare $tmpfile and $FILE"
        exit 1
    fi

    if [[ $stat == 1 ]]; then
        if [[ $FIX_IF_WRONG == 1 ]]; then 

            echo "fix file $FILE apply command: $ACTION $FILE"
            cp -f "$tmpfile" "$FILE"
            if [ $? != 0 ]; then
                echo "failed to copy $tmpfile to $FILE error: $?"
                exit 1
            fi
        else
            if [ $ACTION == "expand" ]; then
                echo "$FILE has tabs. fix that with command: $ACTION $FILE >tmpfile; mv -f tmpfile $FILE"
                
            else
                echo "$FILE has spaces. fix that with command: $ACTION $FILE >tmpfile; mv -f tmpfile $FILE"
            fi
            exit 1
        fi
    elif [[ $stat == 0 ]]; then
       if [[ $VERBOSE == 1 ]]; then
            echo "ok"
       fi
    else 
       echo "unexpected status: $?"
       exit 1
    fi

}

function run_files() {
    
    for f in $(git ls-files -- ':!vendor/' | grep -E "*.${FILE_EXTENSION}$"); do
        if [[ $VERBOSE == 1 ]]; then
            echo "check file: $f"
        fi

        check_file "$f"
    done
}

function run_all() {

    TOP_DIR=`git rev-parse --show-toplevel 2>/dev/null`
    if [ "x$TOP_DIR" != "x" ]; then
        pushd $TOP_DIR >/dev/null
        run_files
        popd >/dev/null
    else 
        echo "$PWD is not in a git repo"
        exit 1
    fi
}

run_all

rm -f "$tmpfile"

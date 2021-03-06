#!/bin/bash

### common useful stuff for bash scripts 
### bash is commonly used as a scripting language on linux (i guess that's because it is available on most setups)
### this set of functions tries to abstract away some often used primites.

# trace with source file name and line number
function trace_on
{
    SCRIPT_TRACE_ON=1
    OLD_PS4=$PS4
    export PS4='+(${BASH_SOURCE}:${LINENO}) '
    set -x
 }

# trace with source file name, line number and current function name
function trace_on_total
{
    SCRIPT_TRACE_ON=1
    OLD_PS4=$PS4
    export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
    set -x
}

# turn tracing off
function trace_off 
{
    set +x
    export PS4=$OLD_PS4
    unset -v OLD_PS4
    unset -v SCRIPT_TRACE_ON
}

#
# tokenize <input string> <token delimter>
#
# tokenizes the <input string> according to <token delimter> into global array TOKEN_ARRAY
#
function tokenize {
  local OLD_IFS
  
  OLD_IFS=$IFS
  IFS=$2 read -d '' -r -a TOKEN_ARRAY <<< "$1" || true
  IFS=$OLD_IFS

}

#
# tokenize_iterate <input_string> <token delimiter> <callback function for each token>
#
# tokenizes the <input string> according to <token delimter> and call <calback function> with each token.
#
function tokenize_iterate {
  local TOKEN_ARRAY
  local OLD_IFS
  
  OLD_IFS=$IFS
  IFS=$2 read -d '' -r -a TOKEN_ARRAY <<< "$1" || true
  IFS=$OLD_IFS

  for element in "${TOKEN_ARRAY[@]}"
  do
    $3  "$element"
  done
}

function dump_it {
    echo "$1" | hexdump -C
}


#
# title message setup
#
function title_msg_init {
    TITLEMSG_PREFIX=$1
    TITLEMSG_MAX_STEPS=$2
    TITLEMSG_CUR_STEP=1
}

#
# show a title message (useful to show that a stage has been passed)
#
function title_msg {
    { set +x; } 2>/dev/null
    echo ""
    echo "---"
    for a in "$@"; do
        echo "${TITLEMSG_PREFIX} ${TITLEMSG_CUR_STEP}/${TITLEMSG_MAX_STEPS}:    $a"
    done
    echo "---"
    echo ""
    ((TITLEMSG_CUR_STEP += 1))
    if [[ $SCRIPT_TRACE_ON != "" ]]; then 
       set -x 
    fi
}

#
# show size of a file in stdout
#
function file_size {
    stat --printf="%s" $1 2>/dev/null
}


#
# range of numbers range <from> <to>
#
# returns all numbers between <from>..<to> inclusively. nice for iterations.
# (actually there is seq - but this one does it without another process invocation, don't know if that counts ;-)
#
function range {
    { set +x; } 2>/dev/null
    
    local from
    local to
    local res

    from=$1
    to=$2

    while [ $from -le $to ]; do
        res="$res $from"
        ((from += 1))
    done
    echo $res

    if [[ $SCRIPT_TRACE_ON != "" ]]; then 
       set -x 
    fi
}


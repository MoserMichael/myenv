#!/bin/bash

set -x
beep() {

    ( speaker-test -t sine -f $freq >/dev/null )& pid=$! 
    sleep 0.1s 
    kill -PIPE $pid >/dev/null 2>&1
}



if [[ $1 == "-h" ]]; then
cat <<EOF
$0 [-h|<frequency>]

makes  short beep. (default frequency 1000)

used the following to install it on fedora:
sudo dnf install sox pavucontrol alsa-utils 

EOF
exit 1
fi

freq=$1
if [[ $freq == "" ]]; then
 freq=1000
fi

beep



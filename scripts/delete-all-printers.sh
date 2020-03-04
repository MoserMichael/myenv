#!/bin/bash

if [[ $1 == "-h" ]]; then
    echo "delete all printers"
    exit 1
fi


for a in $(lpstat -l | awk '{ print $1}' | sort | uniq); do
	echo "deleting printer: $a"
	lpadmin -x $a
done

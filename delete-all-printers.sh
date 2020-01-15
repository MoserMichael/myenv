#!/bin/bash


for a in $(lpstat -l | awk '{ print $1}' | sort | uniq); do
	echo "deleting printer: $a"
	lpadmin -x $a
done

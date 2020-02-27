#!/bin/bash -ei

function Help {
    if [[ $1 != "" ]]; then
        echo "Error: $*"
    fi

cat <<EOF
$0 -f <big-file1> [-f <big_file2> ..] -r <user@host:/directory> [-i <identity_file>]

compress a set of input file into tar archive (gzipped) and transfer the archive to host via scp; open the tar archive via ssh.

Often the transfer of big files takes a lot of time over a slow connection; this script saves some time by 
compressing the big file first.

Options:

-i <identity_file> : ssh identity file.
-f <bigfile>       : input file (can have multiple)
-r <user@host:/directory> : remote location

EOF

exit 1
}

function file_size {
    stat --printf="%s" "$1"  2>/dev/null || true
}

IN_FILE=""
IDENTITY_FILE=""
REMOTE_LOCATION=""
INPUT_FILE_SIZE=0

while getopts "hvi:f:r:" opt; do
  case ${opt} in
    h)
        Help
        ;;
    f)
        IN_FILE="$IN_FILE $OPTARG"
        if [[ ! -f $OPTARG ]]; then
            Help "Input file $OPTARG does not exist. -f $OPTARG"
        fi
        FSIZE=$(file_size $OPTARG)
        INPUT_FILE_SIZE=$(($INPUT_FILE_SIZE+$FSIZE))
        ;;
    i)
        IDENTITY_FILE="-i $OPTARG"
        ;;
    r)
        REMOTE_LOCATION="$OPTARG"
        ;;
    v)
        set -x
        export PS4='+(${BASH_SOURCE}:${LINENO})'
        #VERBOSE=1
        ;; 
    *)
        Help "Invalid flag"
        ;;   
    esac
done	

if [[ $REMOTE_LOCATION == "" ]]; then
    echo "Remote location missing. missing -r option"
fi

REMOTE_DIR=$(echo "$REMOTE_LOCATION" | sed -n 's/[^@]*@[^:]*:\(.*\)$/\1/p')

REMOTE_HOST=$(echo "$REMOTE_LOCATION" | sed -n 's/\([^:]*\):.*$/\1/p')

if [[ $REMOTE_DIR == "" ]]; then
    Help "-r options must be of the form <user>@<host>:<remote_dir>"
fi


set -ex


OFILE=$(mktemp tarfile.XXXXXXXXX.tar.gz)

tar cvfz $OFILE $IN_FILE

tar tvfz $OFILE

OFILE_SIZE=$(file_size $OFILE)

cat <<EOF
===
Input file sizes: $INPUT_FILE_SIZE Compressed tar file size: $OFILE_SIZE"
===
EOF

scp $IDENTITY_FILE  $OFILE $REMOTE_LOCATION/${OFILE} 

ssh $IDENTITY_FILE  $REMOTE_HOST /bin/sh -c 'set -x;/usr/bin/tar xvfz '${REMOTE_DIR}'/'${OFILE}' -C '${REMOTE_DIR}';/bin/rm '${REMOTE_DIR}'/'${OFILE}''

rm -f ${OFILE}

echo "*** files copied ***"


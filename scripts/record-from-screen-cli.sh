#!/bin/bash

X_OFFSET=100
Y_OFFSET=200
FRAMERATE=10
WAIT_BEFORE_START=2
OFILE="output.mkv"
AUDIO_SRC=""

function Help {
    if [[ $1 != "" ]]; then
        echo "Error: $*"
    fi
    if [[ ! -z "${SHORT_HELP_MODE}" ]]; then
        echo "record a demo from screen using ffmpeg"
        exit 1
    fi


cat <<EOF
$0 [-x <x-offset>] [-y <y-offset>] [-f <filename>] [-r <framerate>] [-a <audio src index>] [-v -h]

capture video from screen & record video from a input source.
    -f <filename>   : output filename to hold the recording. default value: $OFILE 
    -r <framerate>  : recorded framerate. default value $FRAMERATE frames per second. 
    -x <x-offset>   : x - offset (default value $X_OFFSET )
    -y <y-offset>   : y - offset (default value $Y_OFFSET )
    -w <second>     : wait <seconds> before recording. default value $WAIT_BEFORE_START
    -a <audio idx>  : by default a menu is displayed to choose an audio input source. 
                      this option presets an index (1..) from list as the actual choice. 
    -h              : show this help message
    -v              : verbose tracing.

EOF

exit 1
}



check_ffmpeg_installed() {
    if [[ $(which ffmpeg) == "" ]]; then

        cat <<EOF

Error: ffmpeg is not installed. please install:

On fedora:
    sudo dnf install ffmpeg 
    sudo dnf install sox.x86_64

EOF
        exit 1
    fi
}

check_session() {
    SESSION_TYPE=$(loginctl show-session 3 -p Type)
    if [ $SESSION_TYPE != "Type=x11" ]; then
        
        cat <<EOF
Error: Current session is not  x11; for this script you need to change the GUI manager during login.

For Fedora:
In the login screen: where you enter the password; near the sign-in button there is an option icon (settings icon); it appears when mouse hovers on the login button. 
Here choose 'Gnome on Xorg'

EOF
        exit 1
    fi
}

get_screen_resolution() {
    #SCREEN_RESOLUTION=1024x768

    SCREEN_RESOLUTION=$(xrandr | grep '[[:space:]]connected[[:space:]]'  | grep primary | sed -n  's/.*primary \([[:digit:]]*x[[:digit:]]*\).*$/\1/p')

    echo "Resolution of primary screen: $SCREEN_RESOLUTION"

    WIDTH=$(echo "$SCREEN_RESOLUTION" | sed -n 's/\([[:digit:]]*\).*$/\1/p')
    HEIGHT=$(echo "$SCREEN_RESOLUTION" | sed -n 's/\([[:digit:]]*\)x\([[:digit:]]*\).*$/\2/p')

    V_WIDTH=$(($WIDTH-$X_OFFSET))
    V_HEIGHT=$(($HEIGHT-$Y_OFFSET))
}

choose_audio_source_device() {

    DISP_NAMES=$(pacmd list-sources | grep device.description  | sed -n 's/[[:space:]]*device.description = \(.*\)/\1/p' )

    DISP_DEV_NAMES=$(pacmd list-sources | grep name:  | sed -n 's/[[:space:]]*name: <\([^>]*\)>.*/\1/p')


    NUM_ALSA_DEV=$(echo "$DISP_NAMES" | wc -l)
    if [[ "$AUDIO_SRC" != "" ]]; then 

        ALSA_DEV=$(echo "$DISP_DEV_NAMES" | sed "${AUDIO_SRC}q;d")

    elif [[ $NUM_ALSA_DEV == "0" ]]; then 

        echo "Warning: Can't record audio. No microphone device detected via alsa, capturing the screen only"

    elif [[ $NUM_ALSA_DEV == "1" ]]; then 

        ALSA_DEV="$DISP_DEV_NAMES"

    else

        # more then one microphone; make the user select one.
        DISP_NAMES=$(pacmd list-sources | grep device.description  | sed -n 's/[[:space:]]*device.description = \(.*\)/\1/p' )

        PS3='Please enter your choice of audio input source: '
        options=()
        while IFS= read -r line; do
            options+=("$line")
        done <<< "$DISP_NAMES"

        options+=("Record without audio source - video only")
 
        COLUMNS=10
        select opt in "${options[@]}"
        do
            ALSA_DEV="$opt"
            SOURCES=$(pacmd list-sources | grep device.string |  awk '{ print $3 }')
            ALSA_DEV=$(echo "$DISP_DEV_NAMES" | sed "${REPLY}q;d")
            break
        done
    fi
}

beep() {
    ( speaker-test -t sine -f 1000 )& pid=$! 
    sleep 0.1s 
    kill -PIPE $pid >/dev/null 2>&1
}

record_it() {
 
    if [[ $WAIT_BEFORE_START != "" ]]; then
       echo "sleep $WAIT_BEFORE_START seconds before start of recording"
       sleep $WAIT_BEFORE_START  
       beep >/dev/null 2>&1
       echo "recording now..."
    fi

    rm -f $OFILE || true
    echo "Press q to stop recording. Now recording to $OFILE ... " 

    if [[ $VERBOSE == "" ]]; then
      exec 1>/dev/null
      exec 2>/dev/null
    fi

    if [[ $ALSA_DEV == "" ]]; then
        #record video 
        ffmpeg -video_size ${V_WIDTH}x${V_HEIGHT} -framerate $FRAMERATE -thread_queue_size 2048 -f x11grab -i :0.0+${X_OFFSET},${Y_OFFSET} ${OFILE} 

    else 

        #ffmpeg -video_size ${V_WIDTH}x${V_HEIGHT} -framerate $FRAMERATE -f x11grab -i :0.0+${X_OFFSET},${Y_OFFSET}   -f pulse -i $ALSA_DEV -c:a libmp3lame -af afftdn $OFILE >/dev/null 2>&1
        #ffmpeg -video_size ${V_WIDTH}x${V_HEIGHT} -framerate $FRAMERATE -f x11grab -i :0.0+${X_OFFSET},${Y_OFFSET}  -f pulse -i $ALSA_DEV -c:a libmp3lame -af anlmdn $OFILE >/dev/null 

        #ffmpeg -threads 4  -probesize 10M -video_size ${V_WIDTH}x${V_HEIGHT} -framerate $FRAMERATE  -thread_queue_size 2048 -f x11grab -i :0.0+${X_OFFSET},${Y_OFFSET} -thread_queue_size 2048 -f pulse -i $ALSA_DEV -af "loudnorm,highpass=f=200,lowpass=f=3000" -flush_packets 1 $OFILE 
        
        ffmpeg -probesize 10M -video_size ${V_WIDTH}x${V_HEIGHT} -framerate $FRAMERATE  -thread_queue_size 2048 -f x11grab -i :0.0+${X_OFFSET},${Y_OFFSET} -thread_queue_size 2048 -f pulse -i $ALSA_DEV -af "loudnorm" -c:v libx264 -c:a flac $OFILE 
    fi

    echo "recording stopped"
}


while getopts "hvx:y:f:r:w:a:" opt; do
  case ${opt} in
    h)
        Help
        ;;
    r) 
        FRAMERATE="$OPTARG"           
        ;;
    x)
        X_OFFSET="$OPTARG"
        ;;
    y)
        Y_OFFSET="$OPTARG"
        ;;
    f)
        OFILE="$OPTARG" 
        ;;
    w)
        WAIT_BEFORE_START="$OPTARG"
        ;;
    v)
        set -x
        export PS4='+(${BASH_SOURCE}:${LINENO})'
        VERBOSE=1
        ;;
    a)
        AUDIO_SRC="$OPTARG"
        ;;
    *)
        Help "Invalid option"
        ;;
   esac
done	

check_ffmpeg_installed
check_session
get_screen_resolution
choose_audio_source_device
record_it



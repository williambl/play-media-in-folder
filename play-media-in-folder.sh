QUEUE_FOLDER=queueFolder
PLAYED_FOLDER=playedFolder
USE_YOUTUBEDL=1

# functions

function play_yt {
    if [[ $USE_YOUTUBEDL ]]
    then
        play_yt_with_youtubedl $1
    else
        play_yt_with_vlc $1
    fi
}

function play_yt_with_vlc {
    vlc --one-instance --playlist-enqueue "https://youtube.com/watch?v=$1"
}

function play_yt_with_youtubedl {
    youtube-dl "https://youtube.com/watch?v=$1" -f bestvideo+bestaudio/mkv -o "$PLAYED_FOLDER/$1"
    vlc --one-instance --playlist-enqueue "$PLAYED_FOLDER/$1.mkv"
}


echo Starting VLC Media Player.
vlc --one-instance >/dev/null 2>&1 &

inotifywait -m "$QUEUE_FOLDER" -e create -e moved_to --format '%f' |
    while read FILE; do
        echo Enqueueing $FILE

        FILEEXT=${FILE##*.}
        echo $FILEEXT

        if [[ $FILEEXT = "youtube" ]]
        then
            rm "$QUEUE_FOLDER/$FILE"
            play_yt `basename $FILE .youtube`
        else
            mv "$QUEUE_FOLDER/$FILE" "$PLAYED_FOLDER/$FILE"
            vlc --one-instance --playlist-enqueue "$PLAYED_FOLDER/$FILE"
        fi

        if [[ ! $(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus) = "Playing" ]]; then
            dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
        fi
    done

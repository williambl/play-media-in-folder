QUEUE_FOLDER=queueFolder
PLAYED_FOLDER=playedFolder

echo Starting VLC Media Player.
vlc --one-instance >/dev/null 2>&1 &

inotifywait -m $QUEUE_FOLDER -e create -e moved_to --format '%f' |
    while read FILE; do
        echo Enqueueing $FILE

        mv $QUEUE_FOLDER/$FILE $PLAYED_FOLDER/$FILE
        vlc --one-instance --playlist-enqueue $PLAYED_FOLDER/$FILE

        if [[ ! $(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus) = "Playing" ]]; then
            dbus-send --type=method_call --dest=org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
        fi
    done

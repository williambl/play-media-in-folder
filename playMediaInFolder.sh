QUEUE_FOLDER=queueFolder
PLAYED_FOLDER=playedFolder

vlc --one-instance >/dev/null 2>&1 &

inotifywait -m $QUEUE_FOLDER -e create -e moved_to --format '%f' |
    while read FILE; do
        mv $QUEUE_FOLDER/$FILE $PLAYED_FOLDER/$FILE
        vlc --one-instance --playlist-enqueue $PLAYED_FOLDER/$FILE
    done

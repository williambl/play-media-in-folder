QUEUE_FOLDER=queueFolder
PLAYED_FOLDER=playedFolder

inotifywait -m $QUEUE_FOLDER -e create -e moved_to --format '%f' |
    while read FILE; do
        mv $QUEUE_FOLDER/$FILE $PLAYED_FOLDER/$FILE
        vlc $PLAYED_FOLDER/$FILE
    done

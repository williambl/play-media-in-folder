inotifywait -m queueFolder -e create -e moved_to --format '%w' |
    while read FILE; do
        echo $FILE
        FILENAME=$(basename $FILE)
        echo $FILENAME
        #mv $FILE playedFolder/$FILENAME
        
        #vlc playedFolder/$FILENAME
    done

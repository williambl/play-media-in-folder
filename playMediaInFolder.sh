inotifywait -m queueFolder -e create -e moved_to --format '%w' |
    while read FILE; do
        mv $FILE playedFolder/$FILE
        vlc playedFolder/$FILE
    done

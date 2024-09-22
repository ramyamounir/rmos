#!/usr/bin/env sh

get_index() {
    if [ ! -d "$1" ]; then
        echo 0
    fi

    IDX=0
    PATTERN="s/$2_\\([0-9]\\+\\)\\.$3/\\1/"

    for file in "$1"/$2_*.$3; do
        N=$(basename "$file" | sed $PATTERN)

        if [[ $N =~ ^[0-9]+$ ]]; then
            if [[ N > IDX ]]; then
                IDX=$N
            fi
        fi
    done

    echo $IDX
}

DIR="$HOME/downloads"
PREFIX="screenshot"
EXTENSION="png"

NEW_IDX=$(($(get_index $DIR $PREFIX $EXTENSION) + 1))
FILENAME="$DIR/$PREFIX"_$NEW_IDX.$EXTENSION

if [[ $1 -eq 0 ]]; then
    maim --hidecursor --format png --quality 10 "$FILENAME" 
else
    maim --hidecursor --format png --quality 10 --select "$FILENAME"
fi


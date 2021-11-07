#!/bin/sh -e

FILE="$SYNCED_DIR/MY_FILE"

for i in 0 1 0; do
    echo "I: $i"

    mkdir -p "$SYNCED_DIR"
    touch "$FILE"
    ./ropsync.sh

    while read -r ABS_PATH; do
        find "$ABS_PATH" | grep -q "$(basename "$FILE")"
    done < "$ROPSYNC_CONFIG_DIR/hosts"

    if [ "$i" -eq 1 ]; then
        rm "$FILE"
    else
        read -r ABS_PATH < "$ROPSYNC_CONFIG_DIR/hosts"
        find "$ABS_PATH" -name "$(basename "$FILE")" -type f -exec rm {} +
    fi

    ./ropsync.sh

    while read -r ABS_PATH; do
        find "$ABS_PATH" | grep "$(basename "$FILE")" || continue
        exit 1
    done < "$ROPSYNC_CONFIG_DIR/hosts"
done

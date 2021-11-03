#!/bin/sh -e

FILE="$SYNCED_DIR/MY_FILE"
mkdir -p "$SYNCED_DIR"
TARGET_VALUE="A"
TARGET_VALUE2="B"

verify () {
    read -r VALUE < "$FILE"

    [ "$1" = "$VALUE" ]
    while read -r ABS_PATH; do
        find "$ABS_PATH" -name "$(basename "$FILE")" | {
            read -r REMOTE_FILE
            read -r VALUE<"$REMOTE_FILE"
            [ "$1" = "$VALUE" ]
            echo "$2"  > "$REMOTE_FILE"
        }
    done < "$ROPSYNC_DATA_DIR/hosts"
}

echo "$TARGET_VALUE"  > "$FILE"
./ropsync.sh

verify "$TARGET_VALUE" "$TARGET_VALUE2"

./ropsync.sh

verify "$TARGET_VALUE2"

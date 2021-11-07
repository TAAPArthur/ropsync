#!/bin/sh -e
# Verifies ignored files/dirs

mkdir -p "$IGNORED_DIR"
touch "$IGNORED_FILE"
./ropsync.sh

while read -r ABS_PATH; do
    find "$ABS_PATH" | grep -q -v -e "$IGNORED_DIR" -e "$IGNORED_FILE"
done < "$ROPSYNC_CONFIG_DIR/hosts"

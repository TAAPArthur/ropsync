#!/bin/sh -e
# Verifies files and directories will be auto created

./ropsync.sh
while read -r F; do
    [ -e "$F" ]
done < "$ROPSYNC_DATA_DIR/known_files"

while read -r F; do
    [ -e "$F" ]
done < "$ROPSYNC_CONFIG_DIR/include"

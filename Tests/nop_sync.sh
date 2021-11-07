#!/bin/sh -e

./ropsync.sh
./ropsync.sh

mkdir -p "$SYNCED_DIR"
touch "$SYNCED_DIR/MY_FILE"

./ropsync.sh
./ropsync.sh

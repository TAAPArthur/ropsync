#!/bin/sh -e

export TEST_HOME=/tmp/.robsync
mkdir -p "$TEST_HOME"

export ROPSYNC_CONFIG_DIR=$TEST_HOME/config
export ROPSYNC_DATA_DIR=$TEST_HOME/data
export IGNORED_DIR=$TEST_HOME/.git/
export IGNORED_FILE=$TEST_HOME/.test
export SYNCED_DIR=$TEST_HOME/TestA/
export SYNCED_DIR2=$TEST_HOME/TestD/
export SYNCED_FILE=$TEST_HOME/test_file
export RSYNC_EXTRA_FLAGS=-i

for f in ${1:-Tests/*.sh}; do
    rm -fr "${TEST_HOME:?}"/*
    mkdir -p "$ROPSYNC_CONFIG_DIR" "$ROPSYNC_DATA_DIR"
    cat - <<EOF >"$ROPSYNC_CONFIG_DIR/hosts"
$TEST_HOME/TestB
$TEST_HOME/TestC
EOF
    cat - <<EOF >"$ROPSYNC_CONFIG_DIR/include"
$SYNCED_FILE
$SYNCED_DIR
EOF
    cat - <<EOF >"$ROPSYNC_CONFIG_DIR/exclude"
.git*
.test
EOF
    rm -f "$ROPSYNC_DATA_DIR/known_files"
    echo "Running $f"
    "$f"
done

#!/bin/sh -e

ROPSYNC_CONFIG_DIR=${ROPSYNC_CONFIG_DIR:-${XDG_CONFIG_DIR:-$HOME/.config}/ropsync}
ROPSYNC_DATA_DIR=${ROPSYNC_DATA_DIR:-${XDG_DATA_DIR:-$HOME/.local/state}/ropsync}
KNOWN_FILES=$ROPSYNC_DATA_DIR/known_files
HOST_FILE=$ROPSYNC_CONFIG_DIR/hosts
FILES=$ROPSYNC_CONFIG_DIR/include
EXCLUDE_PATTERNS=$ROPSYNC_CONFIG_DIR/exclude

mkdir -p "$ROPSYNC_CONFIG_DIR"

getAllFiles() {
    while read -r file; do
        [ "${file#\~}" = "$file" ] || file=$HOME/${file#\~}
        find "$file" 2>/dev/null
    done < "$FILES"
}
getDeletedOrNewFiles() {
    [ -n "$1" ]
    if [ -f "$KNOWN_FILES" ]; then
        find "$1" 2>/dev/null | sort - "$KNOWN_FILES" | uniq -u
    fi
}

HOSTNAME=$(hostname)
RSYNC_FLAGS="-auti"

while read -r user_at_host; do
    if [ -z "$user_at_host" ] || [ "${user_at_host#*@}" = "$HOSTNAME" ]; then
        continue
    fi

    if [ "/${user_at_host#/}" != "$user_at_host" ] && [ "${user_at_host%:}:" != "$user_at_host:" ] ; then
        user_at_host="$user_at_host:"
    fi

    while read -r file; do
        echo "FILE: $file"
        [ "${file#\~}" = "$file" ] && local_file="$file" || local_file=$HOME/${file#\~}
        if [ ! -e "$local_file" ]; then
            # if path ends in '/'
            if [ "${local_file%/}/" != "$local_file/" ]; then
                echo "Creating directory $local_file"
                mkdir "$local_file"
            else
                echo "Creating file $local_file"
                touch "$local_file"
            fi
        fi
        (cat "$EXCLUDE_PATTERNS"; getDeletedOrNewFiles "$local_file") | sed "s\\^$local_file\\\\"  | rsync "$RSYNC_FLAGS" --mkpath --delete --exclude-from - "$user_at_host$local_file" "$file" || true
        sed "s\\^$local_file\\\\" "$EXCLUDE_PATTERNS" | rsync "$RSYNC_FLAGS" --mkpath --delete --exclude-from -  "$local_file" "$user_at_host$file"
    done < "$FILES"
done < "$HOST_FILE"
getAllFiles | sort > "$KNOWN_FILES"

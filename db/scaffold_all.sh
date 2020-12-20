#!/usr/bin/env bash

# This creates scaffold commands for every table in the current schema.rb and runs em

db_directory=${BASH_SOURCE%/*}
TEMP=$db_directory/commands.tmp

# Create the scaffolding commands into commands.tmp
echo "*" | scaffold -p "$db_directory/schema.rb" | gsed '/rails/!d' > "$TEMP"

if [[ ! -f "$TEMP" ]] ; then
    echo "Failed"
    exit 1
fi

chmod +x "$TEMP"
./"$TEMP"

rm "$TEMP"

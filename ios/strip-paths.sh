#!/bin/bash

BINARY="$1"

if [ -f "$BINARY" ]; then
    echo "File: $BINARY found"
else
    echo "File: $BINARY is not found, exit"
    exit 1
fi

PATTERN="file:///.*\.dart"

grep -Eoba "$PATTERN" "$BINARY" | while read -r match
do
    offset=$(echo "$match" | cut -d: -f1)
    str=$(echo "$match" | cut -d: -f2-)
    length=${#str}

    echo "Found offset: $offset, length: $length"

    dd if=/dev/zero of="$BINARY" bs=1 count=$length seek=$offset conv=notrunc 2>/dev/null
done
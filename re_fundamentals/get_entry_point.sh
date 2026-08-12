#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

file_name="$1"

if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

if ! readelf -h "$file_name" >/dev/null 2>&1; then
    echo "Error: '$file_name' is not an ELF file."
    exit 1
fi

magic_number=$(readelf -h "$file_name" | awk '/Magic:/ {
    for (i = 2; i <= NF; i++) {
        printf "%s%s", $i, (i == NF ? "\n" : " ")
    }
}')

class=$(readelf -h "$file_name" | awk -F: '/Class:/ {
    gsub(/^[ \t]+/, "", $2)
    print $2
}')

byte_order=$(readelf -h "$file_name" | awk -F: '/Data:/ {
    gsub(/^[ \t]+/, "", $2)
    sub(/^2'\''s complement, /, "", $2)
    print $2
}')

entry_point_address=$(readelf -h "$file_name" | awk -F: '/Entry point address:/ {
    gsub(/^[ \t]+/, "", $2)
    print $2
}')

source "$(dirname "$0")/messages.sh"
display_elf_header_info

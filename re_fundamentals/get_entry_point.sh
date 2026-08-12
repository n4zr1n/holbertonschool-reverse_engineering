#!/bin/bash

file_name="$1"

if [ -z "$file_name" ]; then
    echo "Error: Please provide a file name."
    exit 1
fi

if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not an ELF file."
    exit 1
fi

magic_number=$(readelf -h "$file_name" | awk '/Magic:/ {
    sub(/^[^:]*:[[:space:]]*/, "")
    print
}')

class=$(readelf -h "$file_name" | awk -F: '/Class:/ {
    gsub(/^[[:space:]]+/, "", $2)
    print $2
}')

byte_order=$(readelf -h "$file_name" | awk -F: '/Data:/ {
    gsub(/^[[:space:]]+/, "", $2)
    sub(/^2'\''s complement, /, "", $2)
    print $2
}')

entry_point_address=$(readelf -h "$file_name" | awk -F: '/Entry point address:/ {
    gsub(/^[[:space:]]+/, "", $2)
    print $2
}')

source ./messages.sh

# Capture output from messages.sh
output=$(display_elf_header_info)

# Print without adding another newline
printf '%s' "$output"

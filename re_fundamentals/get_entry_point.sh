#!/bin/bash

file_name="$1"

# Check that a file was provided
if [ -z "$file_name" ]; then
    echo "Error: Please provide a file name."
    exit 1
fi

# Check that the file exists
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# Check that the file is an ELF file
if ! file "$file_name" | grep -q "ELF"; then
    echo "Error: '$file_name' is not an ELF file."
    exit 1
fi

# Extract ELF header information
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

# Load the provided formatting function
source ./messages.sh

# Display the information
display_elf_header_info

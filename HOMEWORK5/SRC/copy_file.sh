#!/bin/bash
read -p "Source file: " file
read -p "Enter the destination directory: " dir
if [ ! -f "$file" ]; then
echo "Source file '$file' does not exist."
exit 1
fi
cp "$file" "$dir"
if [ $? -eq 0 ]; then
echo "File copied successfully."
else
echo "Error copying file."
fi

#!/bin/bash

#file_name="my_file.txt"
read -p "Enter filename: " file
if [ -f "$file" ]; then
  cat "$file"
else
  echo "Error: File '$file' not found."
fi
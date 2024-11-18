#!/bin/bash

#file="your_file.txt"

read -p "Enter filename" file
if [ -f "$file" ]; then
  echo "The file '$file' exists."
else
  echo "The file '$file' does not exist."
fi

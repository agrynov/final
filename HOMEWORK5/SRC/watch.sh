#!/bin/bash

watch_dir="/Users/andrijgrinov/Documents/danit-hw/HOMEWORK5/watch"

while true; do
  find "$watch_dir" -mmin -1 -type f -print0 | while read -rd '' file; do
    if [[ -f "$file" ]]; then
      echo "New file detected: $file"
      cat "$file"
      mv "$file" "${file}.back"
    fi
  done
  sleep 5
done
#!/bin/bash

read -p "Enter a sentence : " sentence


words=($sentence)
reversed_words=($(for ((i=${#words[@]}-1; i>=0; i--)); do echo "${words[i]}"; done))

for reverse in "${reversed_words[@]}"; do
echo -n "$reverse "
done
echo ""
#!/bin/bash
read -p "Enter new hostname: " new_hostname
hostnamectl set-hostname $new_hostname
echo "$new_hostname" > /etc/hostname
echo "done"

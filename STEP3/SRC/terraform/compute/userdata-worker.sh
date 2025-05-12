#!/bin/bash
sudo apt update
sudo apt install -y openjdk-17-jdk

mkdir -p /home/ubuntu/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPpz5fSBEv56vyejq5P1syaizYzFoNY7GFi1AUMMz3c andrijgrinov@MB-AIR-AG.local" >> /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
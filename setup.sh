#!/bin/bash

# This is a VM setup for ubuntu only OS
# Provide as argument your username (in order to add you to docker and sudo group)

echo "Installing docker"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg make
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
       "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Add access rights for current user" $1
sudo usermod -a -G docker $1
sudo usermod -a -G sudo  $1

echo "Setting up ufw to be docker compatible"
sudo ufw enable

echo "Edit ufw rules to be docker compatible"
# ref: https://github.com/chaifeng/ufw-docker?tab=readme-ov-file#solving-ufw-and-docker-issues
sudo cp after.rules /etc/ufw/after.rules

sudo ufw reload
echo "Setup ufw: block all but 22, 80 (tcp only) and 443 (tcp only) ports"
sudo ufw default deny
sudo ufw allow 22
sudo ufw route allow proto tcp from any to any port 80
sudo ufw route allow proto tcp from any to any port 443
echo "Turning ufw log"
# ufw is known to be glutton in terms of memory
sudo ufw logging off

echo "Restarting docker"

sudo systemctl restart docker

echo "Setup decent history size"

echo "export HISTSIZE=100000" >> .bashrc
echo "export HISTFILESIZE=100000" >> .bashrc
echo "export HISTCONTROL=ignoreboth:erasedups" >> .bashrc

echo "All done!"
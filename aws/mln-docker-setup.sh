#!/bin/bash

# Install Docker:
sudo yum update -y
sudo yum install docker

# Add the current user to new Docker admin group
# NOTE: This step removes need for “sudo” elevated access to run Docker images
sudo usermod -aG docker ec2-user
id ec2-user
newgrp docker

# Install docker-compose
sudo yum install python3-pip -y
sudo pip3 install docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service

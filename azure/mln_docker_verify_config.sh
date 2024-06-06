#!/bin/bash

# Part 1: Verify Docker running and the version
sudo docker run hello-world
docker-compose version

# Check if Docker is running and the version is OK
if [ $? -ne 0 ]; then
  echo "Error: Docker is not running or the version is incorrect."
  exit 1
fi

# Part 2: Add the current user to new Docker admin group
# NOTE: This step removes need for “sudo” elevated access to run Docker images

sudo groupadd docker
sudo usermod -aG docker $USER

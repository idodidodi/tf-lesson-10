#!/bin/bash

echo "Starting create wordpress docker compose"
cd /home/ubuntu
mkdir wordpress
cd wordpress
curl -O https://raw.githubusercontent.com/idodidodi/tf-lesson-10/main/docker-compose.yml
sudo docker-compose up -d

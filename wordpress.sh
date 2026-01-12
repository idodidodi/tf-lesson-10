#!/bin/bash

echo "Starting create wordpress docker compose"

mkdir wordpress
cd wordpress
curl -O https://raw.githubusercontent.com/idodidodi/tf-lesson-10/main/docker-compose.yml
docker-compose up -d

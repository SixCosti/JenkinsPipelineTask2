#!/bin/bash

# Remove running containers
docker rm -f $(docker ps -aq)

# Create a volume for MySQL to persist data
docker volume rm mysql-data
docker volume create mysql-data
# Create a network
if ! docker network ls | grep -q trio-task-network; then
  docker network create trio-task-network
fi

# Build the images
docker build -t trio-task-mysql:5.7 db --no-cache
docker build -t trio-task-flask-app:latest flask-app --no-cache

# Run mysql container with teh volume mounted
docker run -d \
    --name mysql \
    --network trio-task-network \
    --mount type=volume,source=mysql-data,target=/var/lib/mysql \
    trio-task-mysql:5.7


# Run flask-app container
docker run -d \
    --name flask-app \
    --network trio-task-network \
    -e MYSQL_ROOT_PASSWORD=password \
    trio-task-flask-app:latest

# Run nginx container
docker run -d \
    --name nginx \
    -p 80:80 \
    --network trio-task-network \
    --mount type=bind,source="$(pwd)"/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
    nginx:latest


# show running containers
echo
docker ps -a

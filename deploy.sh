#!/bin/bash
set -e

BRANCH_NAME=$1
DOCKER_USER=sathyaseelans
IMAGE_NAME=devops-build

if [ "$BRANCH_NAME" == "dev" ]; then
    TAG=dev
elif [ "$BRANCH_NAME" == "master" ]; then
    TAG=prod
else
    TAG=latest
fi

CONTAINER_NAME=devops-app

echo "Pulling Docker image: $DOCKER_USER/$IMAGE_NAME:$TAG"
docker pull $DOCKER_USER/$IMAGE_NAME:$TAG

echo "Stopping old container if exists..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

echo "Starting container..."
docker run -d -p 80:80 --restart always --name $CONTAINER_NAME $DOCKER_USER/$IMAGE_NAME:$TAG

echo "Deployment completed for branch $BRANCH_NAME"

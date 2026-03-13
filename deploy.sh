#!/bin/bash

TAG=$1

DOCKER_USER="sathyaseelans"

if [ "$TAG" = "dev" ]; then
    IMAGE="$DOCKER_USER/dev:dev"
else
    IMAGE="$DOCKER_USER/prod:prod"
fi

echo "Pulling Docker image: $IMAGE"

docker pull $IMAGE

echo "Stopping old container..."

docker stop devops-app || true
docker rm devops-app || true

echo "Running container..."

docker run -d -p 80:80 --name devops-app $IMAGE

#!/bin/bash

IMAGE_NAME=sathyaseelans/dev
TAG=latest

echo "Pulling image..."

docker pull $IMAGE_NAME:$TAG

echo "Stopping old container..."

docker stop devops-app || true
docker rm devops-app || true

echo "Running container..."

docker run -d -p 80:80 --name devops-app $IMAGE_NAME:$TAG

#!/bin/bash
set -e

# Branch and Docker info
BRANCH_NAME=$1  # pass branch as first argument
DOCKER_USER=sathyaseelans
IMAGE_NAME=devops-build

if [ "$BRANCH_NAME" == "dev" ]; then
    TAG=dev
elif [ "$BRANCH_NAME" == "master" ]; then
    TAG=prod
else
    TAG=latest
fi

echo "Building Docker image for branch $BRANCH_NAME..."
docker build -t $DOCKER_USER/$IMAGE_NAME:$TAG .

echo "Pushing Docker image to DockerHub..."
docker push $DOCKER_USER/$IMAGE_NAME:$TAG

echo "Build and push completed for tag: $TAG"

#!/bin/bash
set -e

BRANCH_NAME=$1

DOCKER_USER=sathyaseelans

if [ "$BRANCH_NAME" == "dev" ]; then
    IMAGE="$DOCKER_USER/dev:dev"

elif [ "$BRANCH_NAME" == "master" ]; then
    IMAGE="$DOCKER_USER/prod:prod"

else
    IMAGE="$DOCKER_USER/dev:latest"
fi

echo "Building Docker image: $IMAGE"

docker build -t $IMAGE .

echo "Pushing Docker image..."

docker push $IMAGE

echo "Build and push completed for $IMAGE"

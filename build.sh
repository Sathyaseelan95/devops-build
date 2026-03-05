#!/bin/bash

IMAGE_NAME=devops-build
TAG=latest

echo "Building Docker Image..."

docker build -t $IMAGE_NAME:$TAG .

echo "Build Completed"

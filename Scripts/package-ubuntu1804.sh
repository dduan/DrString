#!/usr/bin/env bash

command -v docker &> /dev/null  || { echo >&2 "Install docker https://www.docker.com"; exit 1; }

IMAGE=drstringbuilding
docker rm $IMAGE &> /dev/null
docker image rm -f $IMAGE &> /dev/null
docker build -t $IMAGE -f Scripts/Dockerfile-building .
docker run --name $IMAGE $IMAGE
ARTIFACT_PATH="$(pwd)/.build/release-ubuntu1804"
mkdir -p $ARTIFACT_PATH
docker cp "$IMAGE:/DrString/.build/release/drstring" $ARTIFACT_PATH
tar -C $ARTIFACT_PATH -czf "$ARTIFACT_PATH/drstring.tar.gz" drstring

#!/bin/bash

command -v docker &> /dev/null  || { echo >&2 "Install docker https://www.docker.com"; exit 1; }
if ! command -v docker > /dev/null; then
    echo "Install docker https://docker.com" >&2
    exit 1
fi
ACTION=$1
SWIFT=$2
UBUNTU=$3
DOCKERFILE=$(mktemp)
echo "FROM swift:$SWIFT-$UBUNTU"     > $DOCKERFILE
echo 'ADD . DrString'                >> $DOCKERFILE
echo "RUN cd DrString; make $ACTION" >> $DOCKERFILE
IMAGE=drstringtesting
docker image rm -f "$IMAGE" > /dev/null
docker build -t "$IMAGE" -f $DOCKERFILE . && docker run --rm "$IMAGE"

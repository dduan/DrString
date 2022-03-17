#!/bin/bash

if ! command -v docker > /dev/null; then
    echo "Install docker https://docker.com" >&2
    exit 1
fi
action=$1
swift=$2
ubuntu=$3
arch=$4
dockerfile=$(mktemp)
echo "FROM swift:$swift-$ubuntu"                     >  $dockerfile
echo 'ADD . DrString'                                >> $dockerfile
echo 'WORKDIR DrString'                              >> $dockerfile
echo 'RUN apt-get update && apt-get install -y make' >> $dockerfile
echo "RUN make $action"                              >> $dockerfile
image=drstring
docker image rm -f "$image:$image" || true > /dev/null
docker build --platform=linux/$arch -t "$image:$image" -f $dockerfile .

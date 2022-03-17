#!/bin/bash

./Scripts/ubuntu.sh $@
image=drstring
docker run --rm -iv${PWD}:/host-volume $image:$image sh -s <<EOF
chown -v $(id -u):$(id -g) drstring.tar.gz
cp -va drstring.tar.gz /host-volume
EOF

#!/bin/bash

./Scripts/ubuntu.sh $@
image=drstring
archive=.build/drstring_ubuntu.tar.gz
docker run --rm -iv${PWD}:/host-volume $image:$image sh -s <<EOF
chown -v $(id -u):$(id -g) $archive
cp -va $archive /host-volume/$archive
EOF

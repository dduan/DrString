#!/bin/bash
set -euo pipefail

SWIFT_VERSION=$1
UBUNTU_RELEASE=$2
DOCKER_ARCH=$3
IMAGE_TAG="${SWIFT_VERSION}-${UBUNTU_RELEASE}-${DOCKER_ARCH}"
ARCHIVE=drstring-ubuntu-${UBUNTU_RELEASE}.tar.gz

docker build --platform linux/$DOCKER_ARCH --force-rm -f "Scripts/Dockerfile-${SWIFT_VERSION}-${UBUNTU_RELEASE}" --tag $IMAGE_TAG .

TEMP=$(mktemp -d)
EXES=(/usr/bin/drstring)
ALL=( "${EXES[@]}" /etc/bash_completion.d/drstring /usr/share/zsh/vendor-completions/_drstring /usr/share/fish/completions/drstring.fish )
for content in ${ALL[@]}; do
    mkdir -p "$TEMP/$(dirname $content)"
    docker run $IMAGE_TAG cat $content > "$TEMP/$content"
done

for exe in ${EXES[@]}; do
    chmod +x "$TEMP/$exe"
done

tar -C $TEMP -czf $ARCHIVE etc usr

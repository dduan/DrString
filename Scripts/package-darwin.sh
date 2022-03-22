#!/bin/bash

set -euo pipefail

BUILD_PATH=.build/apple/Products/Release
TEMP=$(mktemp -d)
COMPLETIONS_PATH=$TEMP/completions
ARCHIVE=drstring_darwin.tar.gz
rm -rf $COMPLETIONS_PATH
mkdir -p $COMPLETIONS_PATH
cp -r Scripts/completions/* $COMPLETIONS_PATH
cp $BUILD_PATH/drstring-cli $TEMP/drstring
tar -C $TEMP -czf $ARCHIVE drstring completions

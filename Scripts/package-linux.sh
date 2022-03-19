#!/bin/bash

set -euo pipefail

BUILD_PATH=.build/release
BIN_PATH=$BUILD_PATH/bin
COMPLETIONS_PATH=$BUILD_PATH/completions
ARCHIVE=drstring_linux.tar.gz
rm -rf $BIN_PATH
rm -rf $COMPLETIONS_PATH
mkdir $BIN_PATH
mkdir $COMPLETIONS_PATH
cp -r Scripts/completions/* $COMPLETIONS_PATH
mv $BUILD_PATH/drstring-cli $BIN_PATH/drstring
tar -C $BUILD_PATH -czf $ARCHIVE bin completions
mv $ARCHIVE .build

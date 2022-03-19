#!/bin/bash

set -euo pipefail

BUILD_PATH=.build/release
BIN_PATH=$BUILD_PATH/bin
COMPLETIONS_PATH=$BUILD_PATH/completions
rm -rf $BIN_PATH
rm -rf $COMPLETIONS_PATH
mkdir $BIN_PATH
mkdir $COMPLETIONS_PATH
cp -r Scripts/competions/* $COMPLETIONS_PATH
mv $BUILD_PATH/drstring-cli $BIN_PATH/drstring
tar -C $BUILD_PATH -czf drstring.tar.gz bin completions
mv drstring_linux.tar.gz .build

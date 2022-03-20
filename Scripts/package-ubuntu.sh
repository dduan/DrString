#!/bin/bash

set -euo pipefail

BUILD_PATH=.build/release
BIN_PATH=$BUILD_PATH/bin
LIB_PATH=$BUILD_PATH/lib
COMPLETIONS_PATH=$BUILD_PATH/completions
ARCHIVE=drstring_ubuntu.tar.gz
RUNTIME_PATH=$(./Scripts/locateswift.sh)/linux
rm -rf $BIN_PATH
rm -rf $COMPLETIONS_PATH
rm -rf $LIB_PATH
mkdir $BIN_PATH
mkdir $COMPLETIONS_PATH
mkdir $LIB_PATH
cp -r Scripts/completions/* $COMPLETIONS_PATH
mv $BUILD_PATH/drstring-cli $BIN_PATH/drstring
for lib in libBlocksRuntime.so lib_InternalSwiftSyntaxParser.so; do
    cp "$RUNTIME_PATH/$lib" $LIB_PATH
done
tar -C $BUILD_PATH -czf $ARCHIVE bin lib completions
mv $ARCHIVE .build

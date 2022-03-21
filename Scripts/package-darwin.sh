#!/bin/bash

set -euo pipefail

BUILD_PATH=.build/apple/Products/Release
LIB_PATH=$BUILD_PATH/lib
BIN_PATH=$BUILD_PATH/bin
COMPLETIONS_PATH=$BUILD_PATH/completions
ARCHIVE=drstring_darwin.tar.gz
rm -rf $LIB_PATH
rm -rf $BIN_PATH
rm -rf $COMPLETIONS_PATH
mkdir -p $LIB_PATH
mkdir -p $BIN_PATH
mkdir -p $COMPLETIONS_PATH
cp -r Scripts/completions/* $COMPLETIONS_PATH
cp $BUILD_PATH/drstring-cli $BIN_PATH/drstring
cp $BUILD_PATH/lib_InternalSwiftSyntaxParser.dylib $LIB_PATH/lib_InternalSwiftSyntaxParser.dylib
tar -C $BUILD_PATH -czf $ARCHIVE bin lib completions

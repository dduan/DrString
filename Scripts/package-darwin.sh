#!/bin/bash

BUILD_PATH=.build/apple/Products/Release
LIB_PATH=$BUILD_PATH/lib
BIN_PATH=$BUILD_PATH/bin/drstring
rm -rf $LIB_PATH
rm -rf $BIN_PATH
mkdir -p $LIB_PATH
mkdir -p $BUILD_PATH/{bin,completions}
cp -r Scripts/completions/* $BUILD_PATH/completions
cp $BUILD_PATH/drstring-cli $BIN_PATH
cp $BUILD_PATH/lib_InternalSwiftSyntaxParser.dylib $LIB_PATH/lib_InternalSwiftSyntaxParser.dylib
tar -C $BUILD_PATH -czf drstring.tar.gz bin lib completions
mv drstring.tar.gz .build

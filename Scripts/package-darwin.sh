#!/bin/bash

set -e

BUILD_PATH=.build/release
LIB_PATH=$BUILD_PATH/lib/drstring
BIN_PATH=$BUILD_PATH/bin/drstring
SWIFT_PATH=$(xcrun --find swift)
rm -rf $LIB_PATH
rm -rf $BIN_PATH
mkdir -p $LIB_PATH
mkdir -p $BUILD_PATH/bin
cp .build/release/drstring $BIN_PATH
cp "$(dirname $SWIFT_PATH)/../lib/swift/macosx/lib_InternalSwiftSyntaxParser.dylib" $LIB_PATH/lib_InternalSwiftSyntaxParser.dylib
install_name_tool -add_rpath @executable_path/../lib/drstring $BIN_PATH
tar -C $BUILD_PATH -czf drstring.tar.gz bin/drstring lib/drstring/lib_InternalSwiftSyntaxParser.dylib
mv drstring.tar.gz .build

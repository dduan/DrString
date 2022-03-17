#!/bin/bash

set -euo pipefail

BUILD_PATH=.build/release
mv $BUILD_PATH/drstring-cli $BUILD_PATH/drstring
tar -C $BUILD_PATH -czf drstring.tar.gz drstring

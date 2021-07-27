#!/bin/bash

set -euo pipefail

BUILD_PATH=.build/release
tar -C $BUILD_PATH -czf drstring.tar.gz drstring
mv drstring.tar.gz .build

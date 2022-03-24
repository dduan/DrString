#!/usr/bin/env python3

import re
import sys

expected = re.search(r'let version = "(.+)"', open('Sources/DrStringCore/version.swift').read(), re.M).group(1)
versions = {}
versions['CHANGELOG.md'] = re.search(r'\n##\s*(.+)', open('CHANGELOG.md').read(), re.M).group(1)

for file in versions:
    if expected != versions[file]:
        print(f"version mismatch: expected {expected}; found {versions[file]} in {file}", file=sys.stderr)
        exit(1)

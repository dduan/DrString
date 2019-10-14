SHELL = /bin/bash
BUILD_PATH = .build/release
LIB_PATH = $(BUILD_PATH)/lib/drstring
BIN_PATH = $(BUILD_PATH)/bin/drstring
SWIFT_PATH = $(shell xcrun --find swift)

test:
	@swift test

test-generated-artifacts:
ifeq ($(shell uname),Darwin)
	@$(MAKE) generate
	@git diff --exit-code
else
	@echo "Only works on macOS"
endif

build:
	@swift build --configuration release --disable-sandbox

generate: generate-explainers generate-linux-manifest

install: build
	@mv .build/release/drstring /usr/local/bin

generate-explainers:
	@Scripts/generateexplainers.py 'Documentation/Explainers' > Sources/Critic/explainers.swift

generate-linux-manifest:
	@swift test --generate-linuxmain

test-docker:
	@Scripts/run-tests-docker.sh

build-docker:
	@Scripts/build-docker.sh

package-darwin: build
	@Scripts/package-darwin.sh

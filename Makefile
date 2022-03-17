SHELL = /bin/bash

ifeq ($(shell uname),Darwin)
EXTRA_SWIFT_FLAGS = --arch arm64 --arch x86_64 --disable-sandbox -Xlinker -dead_strip -Xlinker -dead_strip_dylibs
else
SWIFT_TOOLCHAIN = $(shell dirname $(shell swift -print-target-info | grep runtimeResourcePath | cut -f 2 -d ':' | cut -f 2 -d '"'))
EXTRA_SWIFT_FLAGS = -Xcxx -L${SWIFT_TOOLCHAIN}/swift/linux
endif

.PHONY: test
test:
	@swift test ${EXTRA_SWIFT_FLAGS}

.PHONY: test-generated-artifacts
test-generated-artifacts:
ifeq ($(shell uname),Darwin)
	@$(MAKE) generate
	@git diff --exit-code
else
	@echo "Only works on macOS"
endif

.PHONY: build
build:
	@swift build --configuration release -Xswiftc -warnings-as-errors ${EXTRA_SWIFT_FLAGS}

.PHONY: generate
generate: generate-explainers generate-completion-scripts

.PHONY: build
install: build
	@mv .build/release/drstring /usr/local/bin

.PHONY: generate-explainers
generate-explainers:
	@Scripts/generateexplainers.py 'Documentation/Explainers' > Sources/Critic/explainers.swift

.PHONY: generate-completion-scripts
generate-completion-scripts:
	@swift run drstring-cli --generate-completion-script zsh > Scripts/completions/zsh/_drstring
	@swift run drstring-cli --generate-completion-script bash > Scripts/completions/bash/drstring-completion.bash

.PHONY: test-docker
test-docker:
	@Scripts/ubuntu.sh test 5.3.1 bionic

.PHONY: build-docker
build-docker:
	@Scripts/ubuntu.sh build 5.3.1 bionic

.PHONY: package-darwin
package-darwin: build
	@Scripts/package-darwin.sh

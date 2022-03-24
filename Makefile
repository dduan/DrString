SHELL = /bin/bash

ifeq ($(shell uname),Darwin)
EXTRA_SWIFT_FLAGS = --arch arm64 --arch x86_64 --disable-sandbox -Xlinker -dead_strip -Xlinker -dead_strip_dylibs
else
SWIFT_TOOLCHAIN = $(shell dirname $(shell ./Scripts/locateswift.sh))
EXTRA_SWIFT_FLAGS = -Xswiftc -static-stdlib -Xswiftc -I${SWIFT_TOOLCHAIN}/swift/_InternalSwiftSyntaxParser -Xlinker -fuse-ld=lld -Xlinker -L${SWIFT_TOOLCHAIN}/swift/linux -Xlinker -rpath -Xlinker '$$ORIGIN/../lib'
endif

.PHONY: test
test:
	@swift test

.PHONY: check-version
check-version:
	@Scripts/check-version.py

.PHONY: test-generated-artifacts
test-generated-artifacts:
	@$(MAKE) generate
	@git diff --exit-code

.PHONY: build
build:
	@swift build --configuration release -Xswiftc -warnings-as-errors ${EXTRA_SWIFT_FLAGS}

.PHONY: generate
generate: generate-explainers generate-completion-scripts

.PHONY: generate-explainers
generate-explainers:
	@Scripts/generateexplainers.py 'Documentation/Explainers' > Sources/Critic/explainers.swift

.PHONY: generate-completion-scripts
generate-completion-scripts:
	@swift run drstring --generate-completion-script zsh > Scripts/completions/zsh/_drstring
	@swift run drstring --generate-completion-script bash > Scripts/completions/bash/drstring-completion.bash
	@swift run drstring --generate-completion-script fish > Scripts/completions/drstring.fish

.PHONY: build-docker
build-docker:
	@docker build --platform linux/amd64 --force-rm --tag drstring .

.PHONY: package-darwin
package-darwin: build
	@Scripts/package-darwin.sh

.PHONY: package-ubuntu
package-ubuntu:
	@Scripts/ubuntuarchive.sh 5.6.0 focal amd64

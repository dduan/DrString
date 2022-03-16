SHELL = /bin/bash

.PHONY: test
test:
	@swift test

.PHONY: test-generated-artifacts
test-generated-artifacts:
ifeq ($(shell uname),Darwin)
	@$(MAKE) generate
	@git diff --exit-code
else
	@echo "Only works on macOS"
endif

.PHONY: build
build-fat-binary:
	@swift build --arch arm64 --arch x86_64 --configuration release --disable-sandbox -Xswiftc -warnings-as-errors -Xlinker -dead_strip -Xlinker -dead_strip_dylibs

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
package-darwin: build-fat-binary
	@Scripts/package-darwin.sh

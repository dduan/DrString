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
build:
	@swift build --configuration release --disable-sandbox -Xswiftc -warnings-as-errors
	@mv .build/release/drstring-cli .build/release/drstring

.PHONY: generate
generate: generate-explainers generate-linux-manifest generate-completion-scripts

.PHONY: build
install: build
	@mv .build/release/drstring /usr/local/bin

.PHONY: generate-explainers
generate-explainers:
	@Scripts/generateexplainers.py 'Documentation/Explainers' > Sources/Critic/explainers.swift

.PHONY: generate-linux-manifest
generate-linux-manifest:
	@swift test

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

.PHONY: package-linux
package-linux: build
	@Scripts/package-linux.sh

test: generate-explainers
	@swift test

test-generated-artifacts:
ifeq ($(shell uname),Darwin)
	@$(MAKE) generate
	@git diff --exit-code
else
	@echo "Only works on macOS"
endif

build: generate
	@swift build --configuration release

generate: generate-explainers generate-linux-manifest

install: build
	@mv .build/release/drstring /usr/local/bin/

generate-explainers:
	@Scripts/generateexplainers.py 'Documentation/Explainers' > Sources/Critic/explainers.swift

generate-linux-manifest:
	@swift test --generate-linuxmain

test-docker:
	@Scripts/run-tests-docker.sh

build-docker:
	@Scripts/build-docker.sh

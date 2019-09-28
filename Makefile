test: generate-explainers
	@swift test

test-generate-linux-manifests:
ifeq ($(shell uname),Darwin)
	@swift test --generate-linuxmain
	@git diff --exit-code
else
	@echo "Only works on macOS"
endif

build: generate-explainers
	@swift build --configuration release

install: build
	@mv .build/release/drstring /usr/local/bin/

generate-explainers:
	@Scripts/generateexplainers.py 'Documentation/Explainers' > Sources/Critic/explainers.swift

test-docker:
	@Scripts/run-tests-docker.sh

build-docker:
	@Scripts/build-docker.sh

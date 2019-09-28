test: generate-explainers
	@swift test

build: generate-explainers
	@swift build --configuration release

install: build
	@mv .build/release/drstring /usr/local/bin/

generate-explainers:
	@Scripts/generateexplainers.py 'Documentation/Explainers' > Sources/Critic/explainers.swift

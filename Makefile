run:
	@swift run drstring-cli check -i Sources/drstring-cli/Tests.swift --ignore-throws

test:
	@swift test

build:
	@swift build --configuration release

install: build
	@mv .build/release/drstring-cli /usr/local/bin/drstring

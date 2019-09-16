run:
	@swift run

test:
	@swift test

build:
	@swift build --configuration release

install: build
	@mv .build/release/drstring-cli /usr/local/bin/drstring

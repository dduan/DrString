test:
	@swift test

build:
	@swift build --configuration release

install: build
	@mv .build/release/drstring /usr/local/bin/

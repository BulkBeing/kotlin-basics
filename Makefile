.PHONY: build
build:
	rm -rf docs/
	hugo --panicOnWarning --cleanDestinationDir

.PHONY: all build run

IMG = skyperious

all: run

run: build

build: Dockerfile requirements.txt
	@docker build \
		--quiet \
		--tag $(IMG) \
		.

run:
	@docker run \
		--interactive \
		--tty \
		$(IMG) \
		/bin/bash

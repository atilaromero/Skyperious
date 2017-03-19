DOCKER_TAG ?= $(notdir $(shell pwd))

.PHONY: all build clean run

all: build xfer run

build: Dockerfile main.db requirements.txt
	@docker build \
		--quiet \
		--tag $(DOCKER_TAG) \
		.

clean:
	@rm -rf ./xfer/

exec: build
	@docker exec \
		--interactive \
		--tty \
		$(DOCKER_TAG) \
		/bin/bash

run: xfer build
	@docker run \
		--interactive \
		--name $(DOCKER_TAG) \
		--rm \
		--tty \
		--volume="$(shell pwd)/$<:/code/$<" \
		$(DOCKER_TAG)

xfer:
	@mkdir $@

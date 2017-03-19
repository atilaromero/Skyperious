DOCKER_TAG ?= $(notdir $(shell pwd))
DB_FILE ?= main.db
XFER_FILE ?= ./xfer/export.tar.gz

.PHONY: all build clean exec run

all: run

build: Dockerfile $(DB_FILE) requirements.txt
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
		$(DOCKER_TAG) \
		./venv/bin/skyperious export \
			--verbose \
			--type html \
			--$(DB_FILE) &&
		tar \
			--create \
			--verbose \
			--gzip \
			--file $(XFER_FILE) \
			$(shell ls -d Export */)

xfer:
	@mkdir $@

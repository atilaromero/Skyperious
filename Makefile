DOCKER_TAG = $(notdir $(shell pwd))
DOCKER_HOSTNAME = $(shell hostname)-docker-$(DOCKER_TAG)
mkdir = mkdir -p $(dir $@)

DB_FILE = main.db
XFER_FILE ?= xfer/export.tar.gz
XFER_DIR = $(dir $(XFER_FILE))


.PHONY: all
all: $(XFER_FILE)

.PHONY: docker_build
docker_build: Dockerfile $(DB_FILE) requirements.txt
	@docker build \
		--quiet \
		--tag $(DOCKER_TAG) \
		.

.PHONY: docker_stop
docker_stop:
	@docker rm \
		--force \
		$(DOCKER_TAG) \
		2> /dev/null || true

.PHONY: docker_run
docker_run: docker_stop docker_build $(XFER_DIR)
	@docker run \
		--detach \
		--hostname $(DOCKER_HOSTNAME) \
		--interactive \
		--name $(DOCKER_TAG) \
		--tty \
		--volume $(shell pwd)/$(XFER_DIR):/code/$(XFER_DIR) \
		$(DOCKER_TAG) \
		/bin/bash


.PHONY: docker_exec
docker_exec: docker_run
	@docker exec \
		--interactive \
		--tty \
		$(DOCKER_TAG) \
		/bin/bash

.PHONY: $(XFER_FILE)
$(XFER_FILE): docker_run
	@docker exec \
		$(DOCKER_TAG) \
		/bin/bash -c "\
		$(VENV)bin/skyperious export \
			--verbose \
			--type html \
			$(DB_FILE) ; \
		tar \
			--create \
			--verbose \
			--gzip \
			--file $@ \
			Export*/ ; \
		"

$(XFER_DIR):
	@$(mkdir)

.PHONY: clean
clean: docker_stop
	@docker rmi $(DOCKER_TAG) || true
	@docker image prune --force
	@rm -rf $(XFER_DIR)

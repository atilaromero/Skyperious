.PHONY: all build clean run

IMG = skyperious

all: run

run: xfer build
	@docker run \
		--interactive \
		--volume="$(shell pwd)/$<:/code/$<" \
		--tty \
		$(IMG)

build: Dockerfile main.db requirements.txt
	@docker build \
		--quiet \
		--tag $(IMG) \
		.

xfer:
	@mkdir $@

clean:
	@rm -rf ./xfer/

.PHONY: all build clean run

IMG = skyperious

all: build xfer run

build: Dockerfile main.db requirements.txt
	@docker build \
		--quiet \
		--tag $(IMG) \
		.

clean:
	@rm -rf ./xfer/

run: xfer build
	@docker run \
		--interactive \
		--volume="$(shell pwd)/$<:/code/$<" \
		--tty \
		$(IMG)

xfer:
	@mkdir $@

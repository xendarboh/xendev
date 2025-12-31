SHELL := /bin/bash

# https://unix.stackexchange.com/questions/235223/makefile-include-env-file
include .env
export
MAKEFILE_LIST = Makefile

# https://blog.testdouble.com/posts/2017-04-17-makefile-usability-tips/#step-3-parse-annotations
.PHONY: help
help: ## print this help message with some nifty mojo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: build-tty
build-tty: ## build tty-only docker image
	time docker compose build xen-dev

.PHONY: rebuild-tty
rebuild-tty: ## (re)build tty-only docker image with --no-cache --pull
	time docker compose build --no-cache --pull xen-dev

.PHONY: build
build: ## build docker images
	time docker compose build xen-x11
	time docker compose build \
		--build-arg IMAGE_BASE=xen/x11 \
		xen-dev
	time docker compose build xen-sys

.PHONY: retag
retag: ## tag docker images: latest --> prev
	docker rmi xen/sys:prev xen/dev:prev xen/x11:prev || true
	docker image tag xen/sys:latest xen/sys:prev
	docker image tag xen/dev:latest xen/dev:prev
	docker image tag xen/x11:latest xen/x11:prev

.PHONY: rebuild
rebuild: ## rebuild docker images
	time docker pull ${IMAGE_BASE}
	time docker \
		compose \
			--progress=plain \
		build \
			--no-cache \
			--pull \
			xen-x11
	time docker \
		compose \
			--progress=plain \
		build \
			--build-arg IMAGE_BASE=xen/x11 \
			--no-cache \
			xen-dev
	time docker \
		compose \
			--progress=plain \
		build \
			--no-cache \
			xen-sys

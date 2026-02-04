SHELL := /bin/bash
export BUILDKIT_PROGRESS := plain

# https://unix.stackexchange.com/questions/235223/makefile-include-env-file
include .env
export
MAKEFILE_LIST = Makefile

.PHONY: help build-tty rebuild-tty install-x11docker fetch-nvidia-driver build retag rebuild

# https://blog.testdouble.com/posts/2017-04-17-makefile-usability-tips/#step-3-parse-annotations
help: ## print this help message with some nifty mojo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build-tty: ## build tty-only docker image
	time docker compose build xen-dev

rebuild-tty: ## (re)build tty-only docker image with --no-cache --pull
	time docker compose build --no-cache --pull xen-dev

install-x11docker: ## install or update x11docker and pull xserver image
	curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | sudo bash -s -- --update
	docker pull x11docker/xserver

fetch-nvidia-driver: ## fetch versioned NVIDIA driver for x11docker
	@V=$$(grep -oP 'Kernel Module\s+\K[0-9.]+' /proc/driver/nvidia/version | head -1); \
	if [ -z "$$V" ]; then echo "Error: No NVIDIA driver detected" >&2; exit 1; fi; \
	echo "Detected: $$V"; \
	DL="$$HOME/.local/share/x11docker"; \
	mkdir -p "$$DL" && \
	curl -fL --progress-bar "https://http.download.nvidia.com/XFree86/Linux-x86_64/$$V/NVIDIA-Linux-x86_64-$$V.run" -o "$$DL/NVIDIA-Linux-x86_64-$$V.run"

build: ## build docker images
	time docker compose build xen-x11
	time docker compose build --build-arg IMAGE_BASE=xen/x11 xen-dev
	time docker compose build xen-sys

retag: ## tag docker images: latest --> prev
	-docker rmi xen/sys:prev xen/dev:prev xen/x11:prev
	docker image tag xen/sys:latest xen/sys:prev
	docker image tag xen/dev:latest xen/dev:prev
	docker image tag xen/x11:latest xen/x11:prev

rebuild: ## rebuild docker images (no cache, pull latest base images)
	time docker pull ${IMAGE_BASE}
	time docker compose build --no-cache --pull xen-x11
	time docker compose build --no-cache --build-arg IMAGE_BASE=xen/x11 xen-dev
	time docker compose build --no-cache xen-sys

SHELL := /bin/bash

# https://unix.stackexchange.com/questions/235223/makefile-include-env-file
include .env
export
MAKEFILE_LIST = Makefile

# https://blog.testdouble.com/posts/2017-04-17-makefile-usability-tips/#step-3-parse-annotations
.PHONY: help
help: ## print this help message with some nifty mojo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## build docker image
	time docker-compose build

.PHONY: rebuild
rebuild: ## (re)build docker image with --no-cache --pull
	time docker-compose build --no-cache --pull

.ONESHELL:
SHELL := /usr/bin/bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help
INFO_COLOR := \033[36;1m
ERROR_COLOR := \033[31;1m
SUCCESS_COLOR := \033[32;1m
WARNING_COLOR := \033[33;1m
RESET_COLOR := \033[m

help: ##shows this help
	@grep -hE "^[a-zA-Z0-9_-]+:.*?##" $(MAKEFILE_LIST)

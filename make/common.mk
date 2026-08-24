.ONESHELL:
SHELL := /usr/bin/bash
.SHELLFLAGS := -euo pipefail -c

help: ##shows this help
	@grep -hE "^[a-zA-Z0-9_-]+:.*?##" $(MAKEFILE_LIST)

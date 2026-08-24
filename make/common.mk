.ONESHELL:
SHELL := /usr/bin/bash
.SHELLFLAGS := -euo pipefail -c

help:
	@grep -hE "^[] $$" $(MAKEFILE_LIST)


.ONESHELL:
SHELL := /usr/bin/bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help
INFO_COLOR := \033[36;1m
ERROR_COLOR := \033[31;1m
SUCCESS_COLOR := \033[32;1m
WARNING_COLOR := \033[33;1m
RESET_COLOR := \033[m

tf.init: ##dryrun terraform init
	@echo "terraform init"
help: ##shows this help
	@echo -e "\n${INFO_COLOR}===MENU===${RESET_COLOR}\n"
	@grep -hE "^[a-zA-Z0-9_.-]+:.*?##" $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"}; {printf "${INFO_COLOR}%-20s${RESET_COLOR}\n", $$1, $$2}'
	@echo -e "\n${INFO_COLOR}===FIN MENU===${RESET_COLOR}\n"

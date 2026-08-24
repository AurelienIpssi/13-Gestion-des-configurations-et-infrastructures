REPO_NAME=$(shell basename $$(git rev-parse --show-toplevel))
VISIBILITY ?= private
.PHONY: gh.create
gh.create:
@gh repo create $(REPO_NAME) --$(VISIBILITY) --source=. --remote=origin --push

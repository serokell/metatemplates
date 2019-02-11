# Note: this file was copied from a repository with the following license:
# Copyright (c) 2017 Roman Gonzalez \
\
Permission is hereby granted, free of charge, to any person obtaining a copy \
of this software and associated documentation files (the "Software"), to deal \
in the Software without restriction, including without limitation the rights \
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell \
copies of the Software, and to permit persons to whom the Software is \
furnished to do so, subject to the following conditions: \
\
The above copyright notice and this permission notice shall be included in all \
copies or substantial portions of the Software. \
\
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR \
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, \
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE \
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER \
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, \
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE \
SOFTWARE.

# -*- mode: Makefile; -*-
################################################################################

TOOLS_DIR ?= $$(pwd)/tools/bin

STYLISH_BIN := $(TOOLS_DIR)/stylish-haskell
HLINT_BIN := $(TOOLS_DIR)/hlint
REFACTOR_BIN := $(TOOLS_DIR)/refactor
BRITTANY_BIN := $(TOOLS_DIR)/brittany

FIND_HASKELL_FILES := find . -name "*.hs" -not -path '*.stack-work*' -not -path "*tmp*" -not -name "Setup.hs"

STACK := stack --local-bin-path $(TOOLS_DIR)

################################################################################

$(STYLISH_BIN):
	$(STACK) install stylish-haskell

$(REFACTOR_BIN):
	$(STACK) install apply-refact

$(HLINT_BIN):
	$(STACK) install hlint

$(BRITTANY_BIN):
	$(STACK) install brittany

################################################################################

format: $(STYLISH_BIN) $(BRITTANY_BIN) ## Normalize style on source files
	for f in $$($(FIND_HASKELL_FILES)); do echo $$f; $(BRITTANY_BIN) --config-file .brittany.yml --write-mode inplace $$f; $(STYLISH_BIN) -i $$f; done
	git diff --exit-code
.PHONY: format

remove-lint: $(HLINT_BIN) $(REFACTOR_BIN) ## Fix lint on source files automatically
	for f in $$($(FIND_HASKELL_FILES)); do echo $$f; $(HLINT_BIN) --hint=./.hlint.yml --with= --with-refactor=$(REFACTOR_BIN) --refactor --refactor-options -i $$f; done
	git diff --exit-code
.PHONY: remove-lint

lint: $(HLINT_BIN) ## Execute linter on source files
	for f in $$($(FIND_HASKELL_FILES)); do echo $$f; $(HLINT_BIN) --hint=./.hlint.yml --with= $$f; done
.PHONY: lint

help:	## Display this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
.DEFAULT_GOAL := help


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

################################################################################

HASKELL_FILES := $(shell find . -name "*.hs" -not -path '*.stack-work*' | grep 'src\|test')

PROJECT_BIN_DIR:=./out/bin
PROJECT_BIN=$(PROJECT_BIN_DIR)/example

STACK:=stack $(STACK_ARGS) --local-bin-path $(PROJECT_BIN_DIR)

################################################################################

$(PROJECT_BIN): $(HASKELL_FILES)
	$(STACK) build --fast --copy-bins --test --no-run-tests --bench --no-run-benchmarks --haddock --no-haddock-deps

build: $(PROJECT_BIN)  ## Build library, binaries, tests, benchmarks and Haddocks
.PHONY: build

test: $(PROJECT_BIN) ## Execute test suites
	$(STACK) test --dump-logs
.PHONY: test

bench: $(PROJECT_BIN) ## Run benchmarks
	$(STACK) bench --dump-logs
.PHONY: bench

clean: ## Clean built artifacts
	rm -f $(PROJECT_BIN_DIR)/*
	rm -f out/*
	rm -rf tmp/*
	stack clean
.PHONY: clean

################################################################################

help:	## Display this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
.DEFAULT_GOAL := help


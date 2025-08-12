# Copyright 2020-2025 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
# Makefile for development of mio_client


#######################################################################################################################
# Documentation
.PHONY: help
#######################################################################################################################
# Prints Usage instruction
help:
	$(call print_banner, Help)
	@echo "Usage: make [target]"
	@echo
	@echo "Targets:"
	@echo "  venv                 : Sets up a virtual environment and installs dependencies"
	@echo "  test                 : Runs all pytest test suites"
	@echo "  test-core            : Runs tests which do not require licenses"
	@echo "  test-dsim            : Runs tests which require Metrics DSim"
	@echo "  test-vivado          : Runs tests which require Xilinx Vivado"
	@echo "  lint                 : Lints codebase with flake8"
	@echo "  docs                 : Generates Sphinx documentation"
	@echo "  build                : Builds package for PyPI"
	@echo "  publish              : Publishes package to PyPI"
	@echo "  publish-install      : Publishes package to PyPI and installs it"
	@echo "  publish-test         : Publishes package to TestPyPI"
	@echo "  publish-test-install : Publishes package to TestPyPI and installs it"
	@echo "  clean                : Calls all clean targets"
	@echo "  clean-venv           : Deletes venv"
	@echo "  clean-build          : Deletes build artifacts and caches"
	@echo "  clean-docs           : Deletes sphinx document outputs"


#######################################################################################################################
# Setup
#######################################################################################################################
.ONESHELL:
.DEFAULT_GOAL := test


#######################################################################################################################
# Constants
#######################################################################################################################
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
BOLD = "\033[1m"
RESET = "\033[0m"
TERM_WIDTH := $(shell tput cols)
FILLER := $(shell printf "%*s" $(TERM_WIDTH) "" | tr " " "*")


#######################################################################################################################
# Configuration parameters
#######################################################################################################################
PACKAGE_NAME := mooreio_client

#######################################################################################################################
# Functions
#######################################################################################################################
define print_banner
	@echo
	@echo $(BOLD)$(GREEN)$(FILLER)$(RESET)
	@echo $(CYAN)[$(MAGENTA)MIO$(CYAN)-$(MAGENTA)WEB$(CYAN)-$(MAGENTA)MAKE$(CYAN)]$(RESET)$(BOLD)$(1) ...
	@echo $(GREEN)$(FILLER)$(RESET)
endef


#######################################################################################################################
# Binaries
#######################################################################################################################
PYTHON         := python3.12
PIP            := venv/bin/pip3
PYTEST         := venv/bin/pytest
TWINE          := twine
FLAKE8         := venv/bin/flake8
SPHINX_API_DOC := sphinx-apidoc
SPHINX_BUILD   := sphinx-build


#######################################################################################################################
# Composite targets
#######################################################################################################################
clean: clean-venv clean-build
all: clean test lint build


#######################################################################################################################
# Environment Setup Targets
.PHONY: submodules venv reqs clean-venv
#######################################################################################################################
# Update the Git submodules
submodules:
	$(call print_banner, Updating Git submodules)
	git submodule sync
	git submodule update --init --recursive

# Set up a virtual environment and install dependencies
venv/bin/activate: requirements-dev.txt
	$(call print_banner, Setting up virtual environment and installing dependencies)
	python3 -m venv venv
	chmod +x venv/bin/activate
	. ./venv/bin/activate && $(PIP) install -r ./requirements.txt
	. ./venv/bin/activate && $(PIP) install -r ./requirements-dev.txt
venv: venv/bin/activate
	. ./venv/bin/activate

# Updates the contents of requirements-dev.txt
reqs: venv
	$(call print_banner, Updating requirements)
	$(PIP) freeze > ./requirements-dev.txt

# Delete venv
clean-venv:
	$(call print_banner, Deleting virtual environment)
	rm -rf ./__pycache__
	rm -rf ./venv


#######################################################################################################################
# Testing Targets
.PHONY: test test-core test-dsim test-vivado lint
#######################################################################################################################
# Run all pytest test suites
test: test-core test-integration test-dsim test-vivado

# Run only core tests
test-core: venv
	$(call print_banner, Running core tests)
	mkdir -p reports
	$(PYTEST) -m core
	$(PYTEST) -n 1 -m core_single

# Run only integration tests
test-integration: venv
	$(call print_banner, Running integration tests)
	mkdir -p reports
	$(PYTEST) -n 1 -m integration

# Run only dsim tests
test-dsim: venv
	$(call print_banner, Running DSim tests)
	mkdir -p reports
	$(PYTEST) -n 1 -m dsim

# Run only vivado tests
test-vivado: venv
	$(call print_banner, Running Vivado tests)
	mkdir -p reports
	$(PYTEST) -n 1 -m vivado

# Lints codebase
lint: venv
	$(call print_banner, Linting codebase)
	mkdir -p reports
	$(FLAKE8) mio_client --format=html --htmldir=reports/lint


#######################################################################################################################
# Build Targets
.PHONY: clean docs clean-docs build clean-build publish-test publish-test-install publish publish-install
#######################################################################################################################
# Clean all outputs
clean: clean-venv clean-build clean-docs
	$(call print_banner, Cleaning remaining outputs)
	rm -rf ./reports

# Generates documentation
docs: venv
	$(call print_banner, Generating documentation)
	$(SPHINX_API_DOC) -o ./docs/source/mio_client ./mio_client/
	$(SPHINX_BUILD) -b html ./docs/source docs/build

# Cleans up all docs output files
clean-docs:
	$(call print_banner, Cleaning up docs output files)
	rm -rf docs/build
	rm -rf docs/source/mio_client

# Builds package for PyPI
build: venv
	$(call print_banner, Building package)
	. ./venv/bin/activate && python -m pip install --upgrade build
	. ./venv/bin/activate && python -m build

# Cleans up all build files
clean-build:
	$(call print_banner, Cleaning up build files)
	rm -rf build
	rm -rf dist
	rm -rf *.egg-info
	rm -rf .eggs
	find . -type d -name '*.egg-info' -exec rm -rf {} +
	find . -name '__pycache__' -exec rm -rf {} +


TWINE_FILES := $(shell ls dist/*.tar.gz dist/*.whl 2>/dev/null)

# Publishes package to TestPyPI
publish-test: clean-build build
	$(call print_banner, Test Publishing package to TestPyPI)
	#. ./venv/bin/activate && twine check $(TWINE_FILES)
	. ./venv/bin/activate && twine upload --repository-url https://test.pypi.org/legacy/ ./dist/*
	@echo "Test publish complete: The package has been uploaded to TestPyPI"

# Installs package from TestPyPI
publish-test-install:
	$(call print_banner, Installing package from TestPyPI)
	$(PIP) install --index-url https://test.pypi.org/simple/ $(PACKAGE_NAME)

# Publishes package to PyPI
publish: clean-build build
	$(call print_banner, Publishing package to PyPI)
	#. ./venv/bin/activate && twine check $(TWINE_FILES)
	. ./venv/bin/activate && twine upload --repository pypi ./dist/*
	@echo "Publish complete: The package has been uploaded to PyPI"

# Installs package from TestPyPI
publish-install: publish
	$(call print_banner, Installing package from PyPI)
	$(PIP) install $(PACKAGE_NAME)


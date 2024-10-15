# Copyright 2020-2024 Datum Technology Corporation
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
	@echo "  all     : Sets up the virtual environment, runs tests, lints code, generates docs, and builds the package"
	@echo "  venv    : Sets up a virtual environment and installs dependencies"
	@echo "  test    : Runs all pytest test suites"
	@echo "  lint    : Lints codebase with flake8"
	@echo "  docs    : Generates Sphinx documentation"
	@echo "  build   : Builds package for PyPI"
	@echo "  clean   : Cleans up build artifacts and caches"


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


#######################################################################################################################
# Configuration parameters
#######################################################################################################################


#######################################################################################################################
# Functions
#######################################################################################################################
define print_banner
	@echo
	@echo $(BOLD)$(GREEN)***********************************************************************************************************************
	@echo $(CYAN)[$(MAGENTA)MIO$(CYAN)-$(MAGENTA)CLIENT$(CYAN)-$(MAGENTA)MAKE$(CYAN)]$(RESET)$(BOLD)$(1) ...
	@echo $(GREEN)***********************************************************************************************************************$(RESET)
endef


#######################################################################################################################
# Binaries
#######################################################################################################################
PYTHON         := venv/bin/python3
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
.PHONY: venv reqs clean-venv
#######################################################################################################################
# Set up a virtual environment and install dependencies
venv/bin/activate: requirements-dev.txt
	$(call print_banner, Setting up virtual environment and installing dependencies)
	python3 -m venv venv
	chmod +x venv/bin/activate
	. ./venv/bin/activate
	$(PIP) install -r ./requirements.txt
	$(PIP) install -r ./requirements-dev.txt
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
#######################################################################################################################
.PHONY: test lint
# Run all pytest test suites
test: venv
	$(call print_banner, Running all pytest tests)
	$(PYTEST)
#$(PYTEST) -v --tb=long -rA -s --showlocals --dist=loadscope
#$(PYTEST) -n auto --dist=loadscope

# Lints codebase
lint: venv
	$(call print_banner, Linting codebase)
	$(FLAKE8) mio_client


#######################################################################################################################
# Build Targets
.PHONY: docs build clean-build publish
#######################################################################################################################
# Generates documentation
docs: venv
	$(call print_banner, Generating documentation)
	$(SPHINX_API_DOC) -o docs/source/api .
	$(SPHINX_BUILD) -b html docs/source docs/build

# Builds package for PyPI
build: venv
	$(call print_banner, Building package)
	$(PYTHON) setup.py sdist bdist_wheel

# Cleans up all build files
clean-build:
	$(call print_banner, Cleaning up build files)
	rm -rf docs/build
	rm -rf build
	rm -rf dist
	rm -rf *.egg-info
	find . -name '__pycache__' -exec rm -rf {} +

# Publishes package to PyPI
publish: clean docs build
	$(call print_banner, Publishing package)
	$(TWINE) upload dist/*
	@echo "  publish : Cleans, builds, and publishes the package to PyPI"


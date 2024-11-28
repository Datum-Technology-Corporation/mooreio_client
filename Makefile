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
	@echo "  venv       : Sets up a virtual environment and installs dependencies"
	@echo "  test       : Runs all pytest test suites"
	@echo "  test-core  : Runs tests which do not require licenses"
	@echo "  test-dsim  : Runs tests which require Metrics DSim"
	@echo "  test-vivado: Runs tests which require Xilinx Vivado"
	@echo "  lint       : Lints codebase with flake8"
	@echo "  docs       : Generates Sphinx documentation"
	@echo "  build      : Builds package for PyPI"
	@echo "  clean      : Deletes venv, cleans up build artifacts and caches"


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
PACKAGE_NAME := mooreio_client

#######################################################################################################################
# Functions
#######################################################################################################################
define print_banner
	@echo
	@echo -e $(BOLD)$(GREEN)***********************************************************************************************************************
	@echo -e $(CYAN)[$(MAGENTA)MIO$(CYAN)-$(MAGENTA)CLIENT$(CYAN)-$(MAGENTA)MAKE$(CYAN)]$(RESET)$(BOLD)$(1) ...
	@echo -e $(GREEN)***********************************************************************************************************************$(RESET)
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
.PHONY: test lint
#######################################################################################################################
# Run all pytest test suites
test: venv
	$(call print_banner, Running all pytest tests)
	mkdir -p reports
	$(PYTEST)

# Run only core tests
test-core: venv
	$(call print_banner, Running core tests)
	mkdir -p reports
	$(PYTEST) -m core

# Run only dsim tests
test-dsim: venv
	$(call print_banner, Running DSim tests)
	mkdir -p reports
	$(PYTEST) -m dsim

# Run only vivado tests
test-vivado: venv
	$(call print_banner, Running Vivado tests)
	mkdir -p reports
	$(PYTEST) -m vivado

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
	. ./venv/bin/activate && $(PYTHON) setup.py sdist bdist_wheel

# Cleans up all build files
clean-build:
	$(call print_banner, Cleaning up build files)
	rm -rf build
	rm -rf dist
	rm -rf *.egg-info
	rm -rf .eggs
	find . -type d -name '*.egg-info' -exec rm -rf {} +
	find . -name '__pycache__' -exec rm -rf {} +

# Publishes package to TestPyPI
publish-test: clean build docs
	$(call print_banner, Test Publishing package to TestPyPI)
	. ./venv/bin/activate && $(TWINE) upload --repository-url https://test.pypi.org/legacy/ dist/*
	@echo "Test publish complete: The package has been uploaded to TestPyPI"

# Installs package from TestPyPI
publish-test-install: publish-test
	$(call print_banner, Installing package from TestPyPI)
	$(PIP) install --index-url https://test.pypi.org/simple/ $(PACKAGE_NAME)

# Publishes package to PyPI
publish: clean build docs
	$(call print_banner, Publishing package to PyPI)
	. ./venv/bin/activate && $(TWINE) upload --repository pypi dist/*
	@echo "Publish complete: The package has been uploaded to PyPI"

# Installs package from TestPyPI
publish-install: publish
	$(call print_banner, Installing package from PyPI)
	$(PIP) install $(PACKAGE_NAME)


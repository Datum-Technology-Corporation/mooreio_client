# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
# Makefile for development of mio_cli


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
	@echo $(CYAN)[$(MAGENTA)MIO$(CYAN)-$(MAGENTA)MAKE$(CYAN)]$(RESET)$(BOLD)$(1) ...
	@echo $(GREEN)***********************************************************************************************************************$(RESET)
endef


#######################################################################################################################
# Binaries
#######################################################################################################################
PYTHON         := python3
PIP            := pip
COVERAGE       := coverage3
TWINE          := twine
FLAKE8         := flake8
SPHINX_BUILD   := sphinx-build
SPHINX_API_DOC := sphinx-apidoc


#######################################################################################################################
# Phonies
#######################################################################################################################
.PHONY: all venv test lint docs build clean publish


#######################################################################################################################
# Composite targets
#######################################################################################################################
all: venv test lint docs build


#######################################################################################################################
# Targets
#######################################################################################################################
# Set up a virtual environment and install dependencies
venv:
	$(call print_banner, Setting up virtual environment)
	python3 -m venv venv
	$(call print_banner, Activating virtual environment and installing dependencies)
	source ./venv/bin/activate && $(PIP) install -r ./requirements-dev.txt

# Run all pytest test suites
test:
	$(call print_banner, Running all pytest tests)
	$(COVERAGE) pytest --parallel $(DJANGO_TESTS_NUM_PARALLEL_JOBS)

lint:
	$(FLAKE8) mio_cli

docs:
    $(SPHINX_API_DOC) -o docs/source .
	$(SPHINX_BUILD) -b html docs/source docs/build

build:
	$(PYTHON) setup.py sdist bdist_wheel

clean:
	rm -rf docs/build
	rm -rf build
	rm -rf dist
	rm -rf *.egg-info
	find . -name '__pycache__' -exec rm -rf {} +

publish: clean build
	$(TWINE) upload dist/*

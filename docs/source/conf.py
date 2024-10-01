# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
# Configuration file for the Sphinx documentation builder.
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html


import os
import sys


#######################################################################################################################
sys.path.insert(0, os.path.abspath('../../mio_cli'))
#######################################################################################################################


#######################################################################################################################
# Project information
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
#######################################################################################################################
project = 'Moore.io CLI Client'
copyright = '2024, Datum Technology Corporation'
author = 'Datum Technology Corporation'
release = '2.0.0'


#######################################################################################################################
# General configuration
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration
#######################################################################################################################
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon'
]
templates_path = ['_templates']
exclude_patterns = []


#######################################################################################################################
# Options for HTML output
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
#######################################################################################################################
html_theme = 'alabaster'
html_static_path = ['_static']

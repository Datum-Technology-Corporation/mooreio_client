# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
# Configuration file for the Sphinx documentation builder.
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html
import os
import sys
from docutils import nodes
from docutils.parsers.rst import Directive


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
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon',
    'sphinx.ext.autosectionlabel',
    "sphinx_autodoc_typehints"
]
templates_path = ['_templates']
exclude_patterns = []


#######################################################################################################################
# Options for HTML output
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
#######################################################################################################################
#html_theme = 'furo'
html_theme = 'alabaster'
html_logo = '_static/mio_logo.png'
html_theme_options = {
}
html_css_files = [
    '_static/custom.css',
]
html_static_path = ['_static']


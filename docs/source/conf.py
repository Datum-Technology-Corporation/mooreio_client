# Copyright 2020-2025 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
# Configuration file for the Sphinx documentation builder.
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html
import os
import sys
from docutils import nodes
from docutils.parsers.rst import Directive
#import sphinx_rtd_theme


#######################################################################################################################
# Project information
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information
#######################################################################################################################
project = 'Moore.io CLI Client'
copyright = '2025, Datum Technology Corporation'
author = 'Datum Technology Corporation'
release = '2.1.3'


#######################################################################################################################
# General configuration
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration
#######################################################################################################################
extensions = [
    #'sphinx_book_theme',
    #'sphinx.ext.viewcode',
    #'sphinx.ext.napoleon',
    #'sphinx.ext.autosectionlabel',
    #"sphinx_autodoc_typehints"
]
templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


#######################################################################################################################
# Options for HTML output
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
#######################################################################################################################
html_theme = 'sphinx_book_theme'
html_logo = '_static/mio_logo.png'
html_copy_source = True
html_sourcelink_suffix = ""
html_theme_options = {
    "path_to_docs": "docs",
    "repository_url": "https://github.com/Datum-Technology-Corporation/mooreio_client",
    "use_edit_page_button": True,
    "use_issues_button": True,
    "use_repository_button": True,
    "use_download_button": True,
    "use_sidenotes": True,
    "show_toc_level": 2,
}
html_css_files = [
    '_static/custom.css',
]
html_static_path = ['_static']


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
    'sphinx.ext.viewcode',
    'sphinx.ext.napoleon'
    'sphinx.ext.autosectionlabel',
]
templates_path = ['_templates']
exclude_patterns = []


#######################################################################################################################
# Options for HTML output
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
#######################################################################################################################
html_theme = 'furo'
html_static_path = ['_static']


#######################################################################################################################
# Sync with help text from source
#######################################################################################################################
# Function to include help text
def extract_help_text():
    from mio_client.cli import HELP_TEXT
    return HELP_TEXT
# Custom directive to insert help text
def setup(app):
    app.add_config_value('cli_help_text', '', 'html')
    app.add_directive('cli_help_text', CLIHelpTextDirective)
class CLIHelpTextDirective(Directive):
    def run(self):
        paragraph_node = nodes.paragraph(text=extract_help_text())
        return [paragraph_node]


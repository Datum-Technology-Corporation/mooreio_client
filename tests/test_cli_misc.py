# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from pathlib import Path

import pytest

import mio_client.cli
from mio_client import cli
from tests.common import OutputCapture


class TestCliMisc:
    @pytest.fixture(autouse=True)
    def setup(self):
        pass

    def run_cmd(self, capsys, args: [str]) -> OutputCapture:
        return_code = cli.main(args)
        text = capsys.readouterr().out.rstrip()
        return OutputCapture(return_code, text)

    def test_cli_help(self, capsys):
        result = self.run_cmd(capsys, ['--help'])
        self.check_help(result)
        result = self.run_cmd(capsys, ['-h'])
        self.check_help(result)

    def check_help(self, result: OutputCapture):
        assert result.return_code == 0
        assert "Moore.io" in result.text
        assert "Client" in result.text
        assert "https://mio-client.readthedocs.io" in result.text
        assert "Usage" in result.text
        assert "Options" in result.text
        assert "Full Command List" in result.text

    def test_cli_version(self, capsys):
        result = self.run_cmd(capsys, ['--version'])
        self.check_version(result)
        result = self.run_cmd(capsys, ['-v'])
        self.check_version(result)

    def check_version(self, result: OutputCapture):
        assert result.return_code == 0
        assert "Moore.io Client" in result.text
        assert mio_client.cli.VERSION in result.text

    def test_cli_help_command_help(self, capsys):
        result = self.run_cmd(capsys, ['help', 'help'])
        assert result.return_code == 0
        assert "Moore.io" in result.text
        assert "Help Command" in result.text
        assert "User Manual" in result.text
        assert "https://mio-client.readthedocs.io" in result.text
        assert "Usage" in result.text
        assert "Examples" in result.text

    def test_cli_help_command_login(self, capsys):
        result = self.run_cmd(capsys, ['help', 'login'])
        assert result.return_code == 0
        assert "Moore.io" in result.text
        assert "User Login Command" in result.text
        assert "Usage" in result.text
        assert "Options" in result.text
        assert "Examples" in result.text



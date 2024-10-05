# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path

import pytest

import mio_client.cli
from mio_client import cli


class OutputCapture:
    def __init__(self, return_code: int, text: str):
        self.return_code = return_code
        self.text = text


class TestCliUser:
    @pytest.fixture(autouse=True)
    def setup(self):
        pass

    def run_cmd(self, capsys, args: [str]) -> OutputCapture:
        return_code = cli.main(args)
        text = capsys.readouterr().out.rstrip()
        return OutputCapture(return_code, text)

    def test_cli_login(self, capsys):
        result = self.run_cmd(capsys, ['login', '-u admin', '-p admin'])
        assert result.return_code == 0



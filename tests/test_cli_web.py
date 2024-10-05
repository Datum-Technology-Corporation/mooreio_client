# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path

import pytest

import mio_client.cli
from mio_client import cli
from tests.test_cli_misc import OutputCapture


class TestCliUser:
    @pytest.fixture(autouse=True)
    def setup(self):
        mio_client.cli.URL_BASE = "http://localhost:8000"
        mio_client.cli.URL_AUTHENTICATION = f'{mio_client.cli.URL_BASE}/auth/token'

    def run_cmd(self, capsys, args: [str]) -> OutputCapture:
        return_code = cli.main(args)
        text = capsys.readouterr().out.rstrip()
        return OutputCapture(return_code, text)

    def test_cli_login(self, capsys):
        result = self.run_cmd(capsys, ['login', '-u admin', '-p admin'])
        assert result.return_code == 0



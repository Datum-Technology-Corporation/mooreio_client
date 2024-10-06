# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path
from unittest import SkipTest

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

    def login(self, capsys, username: str, password: str) -> OutputCapture:
        result = self.run_cmd(capsys, ['login', f'-u {username}', f'-p {password}'])
        return result

    def logout(self, capsys) -> OutputCapture:
        result = self.run_cmd(capsys, ['logout'])
        return result

    #@SkipTest
    def test_cli_login_logout(self, capsys):
        result = self.login(capsys, 'admin', 'admin')
        assert result.return_code == 0
        assert "Logged in successfully" in result.text
        assert mio_client.cli.root_manager.user.authenticated == True
        result = self.logout(capsys)
        assert result.return_code == 0
        assert "Logged out successfully" in result.text
        assert mio_client.cli.root_manager.user.authenticated == False



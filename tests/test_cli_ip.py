# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from pathlib import Path

import pytest

import mio_client.cli
from mio_client import cli
from tests.common import OutputCapture


class TestCliIp:
    @pytest.fixture(autouse=True)
    def setup(self):
        pass

    def run_cmd(self, capsys, args: [str]) -> OutputCapture:
        return_code = cli.main(args)
        text = capsys.readouterr().out.rstrip()
        return OutputCapture(return_code, text)

    def test_cli_list_ip(self, capsys):
        test_project_path = os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest")
        result = self.run_cmd(capsys, [f'--wd={test_project_path}', 'list'])
        assert result.return_code == 0
        assert "Found 2" in result.text



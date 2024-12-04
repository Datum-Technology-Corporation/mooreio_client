# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from pathlib import Path
from unittest import SkipTest

import pytest

import mio_client.cli
from .common import OutputCapture, TestBase


class TestCliUser(TestBase):
    @pytest.fixture(autouse=True)
    def setup(self):
        mio_client.cli.URL_BASE = "http://localhost:8000"
        mio_client.cli.TEST_MODE = True

    @pytest.mark.single_process
    #@pytest.mark.integration
    def test_cli_login_logout(self, capsys):
        result = self.login(capsys, 'admin', 'admin')
        result = self.logout(capsys)


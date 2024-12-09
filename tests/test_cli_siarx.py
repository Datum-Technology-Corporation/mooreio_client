# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
import shutil
from pathlib import Path
from typing import Dict
from unittest import SkipTest

import pytest

import mio_client.cli
from .common import OutputCapture, TestBase


class TestCliSiArx(TestBase):
    @pytest.fixture(autouse=True)
    def setup(self):
        mio_client.cli.URL_BASE = "http://localhost:8000"
        mio_client.cli.TEST_MODE = True
        self.mapu_raw_path: Path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "mapu_raw"))
        self.mapu_update_path: Path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "mapu_update"))
        self.assert_directory_exists(self.mapu_raw_path)

    def reset_workspace(self):
        self.remove_directory(self.mapu_raw_path / ".mio")
        self.remove_directory(self.mapu_raw_path / "sim")
        self.remove_directory(self.mapu_raw_path / "docs")
        self.remove_directory(self.mapu_raw_path / "dv")
        self.remove_file(self.mapu_raw_path / "mio.toml")
        self.remove_directory(self.mapu_update_path / ".mio")
        self.remove_directory(self.mapu_update_path / "sim")

    def siarx(self, capsys, project_path: Path, project_id: str) -> OutputCapture:
        result = self.run_cmd(capsys, [f'--wd={project_path}', '--dbg', 'x', f'--project-id={project_id}'])
        assert result.return_code == 0
        return result

    @pytest.mark.single_process
    @pytest.mark.integration
    def test_cli_siarx_gen_project(self, capsys):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.mapu_raw_path, '2')

    @pytest.mark.single_process
    #@pytest.mark.integration
    def test_cli_siarx_update_project(self, capsys):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.mapu_update_path, '2')

    def cli_siarx_gen_project_sim_dsim(self, capsys, app: str):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.mapu_raw_path, '2')
        result = self.one_shot_sim_ip(capsys, self.mapu_raw_path, app, "uvmt_mapu_b", "fix_stim", 1)

    def cli_siarx_update_project_sim_dsim(self, capsys, app: str):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.mapu_update_path, '2')
        result = self.one_shot_sim_ip(capsys, self.mapu_update_path, app, "uvmt_mapu_b", "fix_stim", 1)

    @pytest.mark.single_process
    @pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_sim_dsim(self, capsys):
        self.cli_siarx_gen_project_sim_dsim(capsys, 'dsim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_update_project_sim_dsim(self, capsys):
        self.cli_siarx_update_project_sim_dsim(capsys, 'dsim')



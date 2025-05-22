# Copyright 2020-2025 Datum Technology Corporation
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
        self.rvmcu_raw_path: Path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "rvmcu_raw"))
        self.assert_directory_exists(self.mapu_raw_path)

    def reset_workspace(self):
        self.remove_directory(self.mapu_raw_path / ".mio")
        self.remove_directory(self.mapu_raw_path / "sim")
        self.remove_directory(self.mapu_raw_path / "docs")
        self.remove_directory(self.mapu_raw_path / "dv")
        self.remove_file(self.mapu_raw_path / "mio.toml")
        self.remove_directory(self.mapu_update_path / ".mio")
        self.remove_directory(self.mapu_update_path / "sim")
        # TEMPORARY RV-MCU
        self.remove_directory(self.rvmcu_raw_path / ".mio")
        self.remove_directory(self.rvmcu_raw_path / "sim")
        self.remove_directory(self.rvmcu_raw_path / "docs")
        self.remove_directory(self.rvmcu_raw_path / "dv")
        self.remove_file(self.rvmcu_raw_path / "mio.toml")

    def siarx(self, capsys, project_path: Path, project_id: str) -> OutputCapture:
        result = self.run_cmd(capsys, [f'--wd={project_path}', '--dbg', 'x', f'--project-id={project_id}'])
        assert result.return_code == 0
        return result

    @pytest.mark.single_process
    #@pytest.mark.integration
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

    def cli_siarx_gen_project_cmpelab_ip(self, capsys, app: str, ip: str):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.mapu_raw_path, '2')
        result = self.cmpelab_ip(capsys, self.mapu_raw_path, app, ip)

    def cli_siarx_gen_project_sim_ip_test(self, capsys, app: str, ip: str, test: str):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.mapu_raw_path, '2')
        result = self.one_shot_sim_ip(capsys, self.mapu_raw_path, app, ip, test, 1, args_boolean=["__DATUM_DBG"])

    def cli_siarx_update_project_sim_ip_test(self, capsys, app: str, ip: str, test: str):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.mapu_update_path, '2')
        result = self.one_shot_sim_ip(capsys, self.mapu_update_path, app, ip, test, 1)

    def cli_siarx_sim_ip_test(self, capsys, path: Path, app: str, ip: str, test: str):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.one_shot_sim_ip(capsys, path, app, ip, test, 1)


    ###################################################################################################################
    # MAPU
    ###################################################################################################################
    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_cmpelab_mapu_dsim(self, capsys):
        self.cli_siarx_gen_project_cmpelab_ip(capsys, 'dsim', "uvmt_mapu_b")

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_sim_mapu_fix_stim_dsim(self, capsys):
        self.cli_siarx_gen_project_sim_ip_test(capsys, 'dsim', 'uvmt_mapu_b', 'fix_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_sim_mapu_rand_stim_dsim(self, capsys):
        self.cli_siarx_gen_project_sim_ip_test(capsys, 'dsim', 'uvmt_mapu_b', 'rand_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_update_project_sim_mapu_fix_stim_dsim(self, capsys):
        self.cli_siarx_update_project_sim_ip_test(capsys, 'dsim', 'uvmt_mapu_b', 'fix_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_update_project_sim_mapu_rand_stim_dsim(self, capsys):
        self.cli_siarx_update_project_sim_ip_test(capsys, 'dsim', 'uvmt_mapu_b', 'rand_stim')


    ###################################################################################################################
    # MSTREAM
    ###################################################################################################################
    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_cmpelab_mstream_dsim(self, capsys):
        self.cli_siarx_gen_project_cmpelab_ip(capsys, 'dsim', "uvmt_mstream_st")

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_sim_mstream_fix_stim_dsim(self, capsys):
        self.cli_siarx_gen_project_sim_ip_test(capsys, 'dsim', 'uvmt_mstream_st', 'fix_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_sim_mstream_rand_stim_dsim(self, capsys):
        self.cli_siarx_gen_project_sim_ip_test(capsys, 'dsim', 'uvmt_mstream_st', 'rand_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_update_project_sim_mstream_fix_stim_dsim(self, capsys):
        self.cli_siarx_update_project_sim_ip_test(capsys, 'dsim', 'uvmt_mstream_st', 'fix_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_update_project_sim_mstream_rand_stim_dsim(self, capsys):
        self.cli_siarx_update_project_sim_ip_test(capsys, 'dsim', 'uvmt_mstream_st', 'rand_stim')


    ###################################################################################################################
    # MPB
    ###################################################################################################################
    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_cmpelab_mpb_dsim(self, capsys):
        self.cli_siarx_gen_project_cmpelab_ip(capsys, 'dsim', "uvmt_mpb_st")

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_sim_mpb_fix_stim_dsim(self, capsys):
        self.cli_siarx_gen_project_sim_ip_test(capsys, 'dsim', 'uvmt_mpb_st', 'fix_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_sim_mpb_bit_bash_dsim(self, capsys):
        self.cli_siarx_gen_project_sim_ip_test(capsys, 'dsim', 'uvmt_mpb_st', 'bit_bash')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_update_project_sim_mpb_fix_stim_dsim(self, capsys):
        self.cli_siarx_update_project_sim_ip_test(capsys, 'dsim', 'uvmt_mpb_st', 'fix_stim')

    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_update_project_sim_mpb_rand_stim_dsim(self, capsys):
        self.cli_siarx_update_project_sim_ip_test(capsys, 'dsim', 'uvmt_mpb_st', 'bit_bash')


    ###################################################################################################################
    # MTX
    ###################################################################################################################
    @pytest.mark.single_process
    #@pytest.mark.integration
    @pytest.mark.dsim
    def test_cli_siarx_gen_project_cmpelab_mtx_dsim(self, capsys):
        self.cli_siarx_gen_project_cmpelab_ip(capsys, 'dsim', "uvmt_mtx_ss")



    ###################################################################################################################
    # *TEMPORARY* RV-MCU
    ###################################################################################################################
    @pytest.mark.single_process
    #@pytest.mark.integration
    def test_cli_siarx_gen_project_rvmcu(self, capsys):
        self.reset_workspace()
        result = self.login(capsys, 'admin', 'admin')
        result = self.siarx(capsys, self.rvmcu_raw_path, '1000')

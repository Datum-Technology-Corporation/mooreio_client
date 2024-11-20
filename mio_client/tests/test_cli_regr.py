# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from pathlib import Path
from unittest import SkipTest

import pytest
import shutil

from docutils.nodes import target

import mio_client.cli
from .common import OutputCapture


class TestCliRegr:
    @pytest.fixture(autouse=True)
    def setup(self):
        mio_client.cli.URL_BASE = "http://localhost:8000"
        mio_client.cli.URL_AUTHENTICATION = f'{mio_client.cli.URL_BASE}/auth/token'

    def run_cmd(self, capsys, args: [str]) -> OutputCapture:
        return_code = mio_client.cli.main(args)
        text: str = capsys.readouterr().out.rstrip()
        return OutputCapture(return_code, text)

    def remove_file(self, path: Path):
        try:
            if not os.path.exists(path):
                return
            shutil.rmtree(path)
        except OSError as e:
            print(f"An error occurred while removing file '{path}': {e}")

    def remove_directory(self, path: Path):
        try:
            if not os.path.exists(path):
                return
            shutil.rmtree(path)
        except OSError as e:
            print(f"An error occurred while removing directory '{path}': {e}")

    def reset_workspace(self):
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest", ".mdc")))
        self.remove_file(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest", "mdc_config.yml")))
        self.remove_file(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest", "mdc_ignore")))
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest", ".mio")))
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest", "sim")))
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets", ".mdc")))
        self.remove_file(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets", "mdc_config.yml")))
        self.remove_file(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets", "mdc_ignore")))
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets", ".mio")))
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets", "sim")))

    def regr_ip(self, capsys, app: str, project_path: Path, ip_name: str, regression_name: str="", dry_mode: bool=False, target_name: str="", test_suite_name: str="") -> OutputCapture:
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        if target_name != "":
            ip_str = f"{ip_name}#{target_name}"
        else:
            ip_str = ip_name
        if test_suite_name != "":
            regression_str = f"{test_suite_name}.{regression_name}"
        else:
            regression_str = regression_name
        optional_args = []
        if app != "":
            optional_args.append(f'--app={app}')
        if dry_mode:
            optional_args.append('--dry')
        results: OutputCapture = self.run_cmd(capsys, [
            f'--wd={project_path}', 'regr', ip_str, regression_str
        ] + optional_args)
        assert results.return_code == 0
        if dry_mode:
            assert 'DSim Cloud Simulation Job File' in results.text
        return results

    def check_regr_results(self, result: OutputCapture, dry_mode: bool, num_tests_expected: int):
        if dry_mode:
            assert f'Regression Dry Mode - {num_tests_expected} tests would have been run:' in result.text
            assert f"DSim Cloud Simulation Job File:" in result.text
        else:
            assert f'Regression passed: {num_tests_expected} tests' in result.text

    def cli_regr_dry_no_target_no_ts(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        results = self.regr_ip(capsys, app, test_project_path, "def_ss_tb", "sanity", True)
        self.check_regr_results(results, True, 1)

    def cli_regr_dry_target_no_ts(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets"))
        results = self.regr_ip(capsys, app, test_project_path, "def_ss_tb", "nightly", True, 'abc')
        self.check_regr_results(results, True, 2)

    def cli_regr_dry_target_ts(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets"))
        results = self.regr_ip(capsys, app, test_project_path, "def_ss_tb", "weekly", True, 'abc', 'special')
        self.check_regr_results(results, True, 4)

    def cli_regr_wet_no_target_no_ts(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        results = self.regr_ip(capsys, app, test_project_path, "def_ss_tb", "bugs", False)
        self.check_regr_results(results, False, 1)

    def cli_regr_wet_target_no_ts(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets"))
        results = self.regr_ip(capsys, app, test_project_path, "def_ss_tb", "weekly", False, 'abc')
        self.check_regr_results(results, False, 3)

    def cli_regr_wet_target_ts(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets"))
        results = self.regr_ip(capsys, app, test_project_path, "def_ss_tb", "nightly", False, 'abc', 'special')
        self.check_regr_results(results, False, 3)

    # DSim
    @pytest.mark.single_process
    def test_cli_regr_dry_no_target_no_ts_dsim(self, capsys):
        self.cli_regr_dry_no_target_no_ts(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_regr_dry_target_no_ts_dsim(self, capsys):
        self.cli_regr_dry_target_no_ts(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_regr_dry_target_ts_dsim(self, capsys):
        self.cli_regr_dry_target_ts(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_regr_wet_no_target_no_ts_dsim(self, capsys):
        self.cli_regr_wet_no_target_no_ts(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_regr_wet_target_no_ts_dsim(self, capsys):
        self.cli_regr_wet_target_no_ts(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_regr_wet_target_ts_dsim(self, capsys):
        self.cli_regr_wet_target_ts(capsys, "dsim")

    # Vivado
    @pytest.mark.single_process
    def test_cli_regr_dry_no_target_no_ts_vivado(self, capsys):
        self.cli_regr_dry_no_target_no_ts(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_regr_dry_target_no_ts_vivado(self, capsys):
        self.cli_regr_dry_target_no_ts(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_regr_dry_target_ts_vivado(self, capsys):
        self.cli_regr_dry_target_ts(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_regr_wet_no_target_no_ts_vivado(self, capsys):
        self.cli_regr_wet_no_target_no_ts(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_regr_wet_target_no_ts_vivado(self, capsys):
        self.cli_regr_wet_target_no_ts(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_regr_wet_target_ts_vivado(self, capsys):
        self.cli_regr_wet_target_ts(capsys, "vivado")
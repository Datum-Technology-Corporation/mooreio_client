# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from pathlib import Path
from unittest import SkipTest

import pytest
import shutil

import mio_client.cli
from .common import OutputCapture


class TestCliSim:
    @pytest.fixture(autouse=True)
    def setup(self):
        mio_client.cli.URL_BASE = "http://localhost:8000"
        mio_client.cli.URL_AUTHENTICATION = f'{mio_client.cli.URL_BASE}/auth/token'
        mio_client.cli.TEST_MODE = True

    def remove_directory(self, path:Path):
        try:
            if not os.path.exists(path):
                return
            shutil.rmtree(path)
        except OSError as e:
            print(f"An error occurred while removing directory '{path}': {e}")

    def reset_workspace(self):
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest", ".mio")))
        self.remove_directory(Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest", "sim")))

    def run_cmd(self, capsys, args: [str]) -> OutputCapture:
        return_code = mio_client.cli.main(args)
        text = capsys.readouterr().out.rstrip()
        return OutputCapture(return_code, text)

    def login(self, capsys, username: str, password: str) -> OutputCapture:
        os.environ['MIO_AUTHENTICATION_PASSWORD'] = password
        result = self.run_cmd(capsys, ['login', f'-u {username}', f'--no-input'])
        assert result.return_code == 0
        assert "Logged in successfully" in result.text
        assert mio_client.cli.root_manager.user.authenticated == True
        return result

    def logout(self, capsys) -> OutputCapture:
        result = self.run_cmd(capsys, ['logout'])
        assert result.return_code == 0
        assert "Logged out successfully" in result.text
        assert mio_client.cli.root_manager.user.authenticated == False
        return result

    def publish_ip(self, capsys, project_path: Path, ip_name: str) -> OutputCapture:
        result = self.run_cmd(capsys, [f'--wd={project_path}', 'publish', ip_name])
        assert result.return_code == 0
        assert "Published IP" in result.text
        assert "successfully" in result.text
        return result

    def install_ip(self, capsys, project_path:Path, ip_name: str="") -> OutputCapture:
        if ip_name == "":
            result = self.run_cmd(capsys, [f'--wd={project_path}', 'install'])
        else:
            result = self.run_cmd(capsys, [f'--wd={project_path}', 'install', ip_name])
        assert result.return_code == 0
        if ip_name == "":
            assert "Installed all IPs successfully" in result.text
        else:
            assert "Installed IP" in result.text
            assert "successfully" in result.text
        return result

    def uninstall_ip(self, capsys, project_path:Path, ip_name: str="") -> OutputCapture:
        if ip_name == "":
            result = self.run_cmd(capsys, [f'--wd={project_path}', 'uninstall'])
        else:
            result = self.run_cmd(capsys, [f'--wd={project_path}', 'uninstall', ip_name])
        assert result.return_code == 0
        if ip_name == "":
            assert "Uninstalled all IPs successfully" in result.text
        else:
            assert "Uninstalled IP" in result.text
            assert "successfully" in result.text
        return result

    def cmp_ip(self, capsys, project_path: Path, app: str, ip_name: str) -> OutputCapture:
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        result = self.run_cmd(capsys, [f'--wd={project_path}', 'sim', ip_name, '-C', '-a', app])
        assert result.return_code == 0
        return result

    def elab_ip(self, capsys, project_path: Path, app: str, ip_name: str) -> OutputCapture:
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        result = self.run_cmd(capsys, [f'--wd={project_path}', 'sim', ip_name, '-E', '-a', app])
        assert result.return_code == 0
        return result

    def cmpelab_ip(self, capsys, project_path: Path, app: str, ip_name: str) -> OutputCapture:
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        result = self.run_cmd(capsys, [f'--wd={project_path}', 'sim', ip_name, '-CE', '-a', app])
        assert result.return_code == 0
        return result

    def sim_ip(self, capsys, project_path: Path, app: str, ip_name:str, test_name: str, seed: int=1, waves: bool=False,
               cov: bool=False, args_boolean: list[str]=[], args_value: dict[str,str]={}) -> OutputCapture:
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        optional_args = []
        if waves:
            optional_args.append('-w')
        if cov:
            optional_args.append('-c')
        if len(args_boolean) > 0 or len(args_value) > 0:
            plus_args = ["-+"]
            for arg in args_boolean:
                plus_args.append(f"+{arg}")
            for arg in args_value:
                plus_args.append(f"+{arg}={args_value[arg]}")
        else:
            plus_args = []
        result = self.run_cmd(capsys, [
            f'--wd={project_path}', 'sim', ip_name, '-S', f'-t {test_name}', f'-s {seed}', '-a', app
        ] + optional_args + plus_args)
        assert result.return_code == 0
        return result

    def one_shot_sim_ip(self, capsys, project_path: Path, app: str, ip_name: str, test_name: str, seed: int=1, waves: bool=False,
                        cov: bool=False, defines_boolean: list[str]=[], defines_value: dict[str,str]={},
                        args_boolean: list[str]=[], args_value: dict[str,str]={}) -> OutputCapture:
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        optional_args = []
        if waves:
            optional_args.append('-w')
        if cov:
            optional_args.append('-c')
        if len(defines_boolean) > 0 or len(defines_value) > 0 or len(args_boolean) > 0 or len(args_value) > 0:
            plus_args = ["-+"]
            for define in defines_boolean:
                plus_args.append(f"+define+{define}")
            for define in defines_value:
                plus_args.append(f"+define+{define}={defines_value[define]}")
            for arg in args_boolean:
                plus_args.append(f"+{arg}")
            for arg in args_value:
                plus_args.append(f"+{arg}={args_value[arg]}")
        else:
            plus_args = []
        result = self.run_cmd(capsys, [
            f'--wd={project_path}', '--dbg', 'sim', ip_name, f'-t {test_name}', f'-s {seed}', '-a', app
        ] + optional_args + plus_args)
        assert result.return_code == 0
        if cov:
            assert os.path.isdir(mio_client.cli.root_manager.command.coverage_merge_report.output_path)
            if mio_client.cli.root_manager.command.coverage_merge_report.has_html_report:
                assert os.path.isdir(mio_client.cli.root_manager.command.coverage_merge_report.html_report_path)
                assert os.path.isfile(mio_client.cli.root_manager.command.coverage_merge_report.html_report_index_path)
                assert os.path.getsize(mio_client.cli.root_manager.command.coverage_merge_report.html_report_index_path) > 0
            if mio_client.cli.root_manager.command.coverage_merge_report.has_merge_log:
                assert os.path.isfile(mio_client.cli.root_manager.command.coverage_merge_report.merge_log_file_path)
                assert os.path.getsize(mio_client.cli.root_manager.command.coverage_merge_report.merge_log_file_path) > 0
        return result

    def clean_ip(self, capsys, project_path: Path, ip_name: str):
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        result = self.run_cmd(capsys, [f'--wd={project_path}', '--dbg', 'clean', ip_name])

    def deep_clean(self, capsys, project_path: Path):
        result = self.run_cmd(capsys, [f'--wd={project_path}', '--dbg', 'clean', '--deep'])
        assert result.return_code == 0
        assert not (project_path / ".mio").exists()

    def check_ip_database(self, exp_count:int):
        if mio_client.cli.root_manager.ip_database.num_ips != exp_count:
            raise Exception(f"Expected {exp_count} IPs in database, found {mio_client.cli.root_manager.ip_database.num_ips}")

    def get_sim_log_text(self):
        log_path = mio_client.cli.root_manager.command.simulation_report.log_path
        with open(log_path, 'r') as log_file:
            log_text = log_file.read()
        return log_text

    def cli_cmp_ip(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        self.cmp_ip(capsys, test_project_path, app, "def_ss")
        self.clean_ip(capsys, test_project_path, "def_ss")
        self.deep_clean(capsys, test_project_path)

    def cli_cmp_elab_ip(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        self.cmp_ip(capsys, test_project_path, app, "def_ss_tb")
        self.elab_ip(capsys, test_project_path, app, "def_ss_tb")
        self.clean_ip(capsys, test_project_path, "def_ss_tb")
        self.deep_clean(capsys, test_project_path)

    def cli_cmpelab_ip(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        self.cmpelab_ip(capsys, test_project_path, app, "def_ss")
        self.clean_ip(capsys, test_project_path, "def_ss")
        self.deep_clean(capsys, test_project_path)

    def cli_cmp_elab_sim_ip(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        self.cmp_ip(capsys, test_project_path, app, "def_ss_tb")
        self.elab_ip(capsys, test_project_path, app, "def_ss_tb")
        self.sim_ip(capsys, test_project_path, app, "def_ss_tb", "smoke", 1)
        self.clean_ip(capsys, test_project_path, "def_ss_tb")
        self.deep_clean(capsys, test_project_path)

    def cli_cmpelab_sim_ip(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        self.cmpelab_ip(capsys, test_project_path, app, "def_ss_tb")
        self.sim_ip(capsys, test_project_path, app, "def_ss_tb", "smoke", 1, waves=True, cov=False)
        self.clean_ip(capsys, test_project_path, "def_ss_tb")
        self.deep_clean(capsys, test_project_path)

    def cli_sim_args_ip(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        defines_boolean = [
            "ABC_BLOCK_ENABLED",
        ]
        defines_value = {
            "DATA_WIDTH": "32",
        }
        args_boolean = [
            "INCLUDE_SECOND_MESSAGE"
        ]
        args_value = {
            "LUCKY_NUMBER": "42",
        }
        result = self.one_shot_sim_ip(capsys, test_project_path, app, "def_ss_tb", "smoke", 1,
                                      waves=False, cov=True, defines_boolean=defines_boolean,
                                      defines_value=defines_value, args_boolean=args_boolean, args_value=args_value)
        log_text = self.get_sim_log_text()
        assert "Hello, World!" in log_text
        assert "DATA_WIDTH=32" in log_text
        assert "ABC_BLOCK is enabled" in log_text
        assert "Your lucky number is 42" in log_text
        self.clean_ip(capsys, test_project_path, "def_ss_tb")
        self.deep_clean(capsys, test_project_path)

    def cli_sim_targets_ip(self, capsys, app: str):
        self.reset_workspace()
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_targets"))
        defines_boolean = []
        defines_value = {}
        args_boolean = []
        args_value = {}
        result = self.one_shot_sim_ip(capsys, test_project_path, app, "def_ss_tb#abc", "smoke", 1,
                                      waves=False, cov=True, defines_boolean=defines_boolean,
                                      defines_value=defines_value, args_boolean=args_boolean, args_value=args_value)
        log_text = self.get_sim_log_text()
        assert "My number is 456" in log_text
        assert "DATA_WIDTH is 64" in log_text
        assert "ABC_BLOCK_ENABLED is true" in log_text
        result = self.one_shot_sim_ip(capsys, test_project_path, app, "def_ss_tb", "smoke", 1,
                                      waves=False, cov=True, defines_boolean=defines_boolean,
                                      defines_value=defines_value, args_boolean=args_boolean, args_value=args_value)
        log_text = self.get_sim_log_text()
        assert "My number is 123" in log_text
        assert "DATA_WIDTH is 32" in log_text
        assert "ABC_BLOCK_ENABLED is true" in log_text
        self.clean_ip(capsys, test_project_path, "def_ss_tb")
        self.deep_clean(capsys, test_project_path)

    # DSim
    @pytest.mark.single_process
    def test_cli_cmp_ip_dsim(self, capsys):
        self.cli_cmp_ip(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_cmp_elab_ip_dsim(self, capsys):
        self.cli_cmp_elab_ip(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_cmpelab_ip_dsim(self, capsys):
        self.cli_cmpelab_ip(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_cmp_elab_sim_ip_dsim(self, capsys):
        self.cli_cmp_elab_sim_ip(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_cmpelab_sim_ip_dsim(self, capsys):
        self.cli_cmpelab_sim_ip(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_sim_args_ip_dsim(self, capsys):
        self.cli_sim_args_ip(capsys, "dsim")
    @pytest.mark.single_process
    def test_cli_sim_targets_ip_dsim(self, capsys):
        self.cli_sim_targets_ip(capsys, "dsim")

    # Vivado
    @pytest.mark.single_process
    def test_cli_cmp_ip_vivado(self, capsys):
        self.cli_cmp_ip(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_cmp_elab_ip_vivado(self, capsys):
        self.cli_cmp_elab_ip(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_cmp_elab_sim_ip_vivado(self, capsys):
        self.cli_cmp_elab_sim_ip(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_sim_args_ip_vivado(self, capsys):
        self.cli_sim_args_ip(capsys, "vivado")
    @pytest.mark.single_process
    def test_cli_sim_targets_ip_vivado(self, capsys):
        self.cli_sim_targets_ip(capsys, "vivado")



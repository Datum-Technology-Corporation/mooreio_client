# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from pathlib import Path
from unittest import SkipTest

import pytest
import shutil

import mio_client.cli
from mio_client import cli
from tests.common import OutputCapture


class TestCliSim:
    @pytest.fixture(autouse=True)
    def setup(self):
        mio_client.cli.URL_BASE = "http://localhost:8000"
        mio_client.cli.URL_AUTHENTICATION = f'{mio_client.cli.URL_BASE}/auth/token'

    def remove_directory(self, path:Path):
        try:
            if not os.path.exists(path):
                return
            shutil.rmtree(path)
        except OSError as e:
            print(f"An error occurred while removing directory '{path}': {e}")

    def run_cmd(self, capsys, args: [str]) -> OutputCapture:
        return_code = cli.main(args)
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

    def publish_ip(self, capsys, project_path: Path, ip_name: str):
        result = self.run_cmd(capsys, [f'--wd={project_path}', 'publish', ip_name])
        assert result.return_code == 0
        assert "Published IP" in result.text
        assert "successfully" in result.text

    def install_ip(self, capsys, project_path:Path, ip_name:str=""):
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

    def uninstall_ip(self, capsys, project_path:Path, ip_name:str=""):
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

    def cmp_ip(self, capsys, project_path:Path, ip_name:str):
        if ip_name == "":
            raise Exception(f"IP name cannot be empty!")
        result = self.run_cmd(capsys, [f'--wd={project_path}', 'sim', ip_name, '-C'])
        assert result.return_code == 0

    def check_ip_database(self, exp_count:int):
        if mio_client.cli.root_manager.ip_database.num_ips != exp_count:
            raise Exception(f"Expected {exp_count} IPs in database, found {mio_client.cli.root_manager.ip_database.num_ips}")

    def test_cli_cmp_ip(self, capsys):
        test_project_path = Path(os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest"))
        self.cmp_ip(capsys, test_project_path, "def_ss")



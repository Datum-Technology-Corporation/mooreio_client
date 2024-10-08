# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from pathlib import Path
from unittest import SkipTest

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

    def login(self, capsys, username: str, password: str) -> OutputCapture:
        os.environ['MIO_AUTHENTICATION_PASSWORD'] = password
        result = self.run_cmd(capsys, ['login', f'-u {username}', f'--no-input'])
        assert result.return_code == 0
        return result

    def logout(self, capsys) -> OutputCapture:
        result = self.run_cmd(capsys, ['logout'])
        assert result.return_code == 0
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

    def test_cli_list_ip(self, capsys):
        test_project_path = os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest")
        result = self.run_cmd(capsys, [f'--wd={test_project_path}', 'list'])
        assert result.return_code == 0
        assert "Found 2" in result.text

    @SkipTest
    def test_cli_publish_ip(self, capsys):
        p1_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p1"))
        p2_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p2"))
        p3_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p3"))
        p4_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p4"))
        # 1. Login
        self.login(capsys, 'admin', 'admin')
        # 2. Publish A from P1
        self.publish_ip(capsys, p1_path, 'a_vlib')
        # 3. Install A from P2
        self.install_ip(capsys, p2_path, 'a_vlib')
        # 4. Publish B from P2
        self.publish_ip(capsys, p2_path, 'b_agent')
        # 5. Install * from P3
        self.install_ip(capsys, p3_path)
        # 6. Publish C from P3
        self.publish_ip(capsys, p3_path, 'c_block')
        # 7. Publish D from P3
        self.publish_ip(capsys, p3_path, 'd_lib')
        # 8. Install A from P4
        self.install_ip(capsys, p4_path, 'a_vlib')
        # 9. Install E from P4
        self.install_ip(capsys, p4_path, 'e_ss')
        # 10. Install * from P4
        self.install_ip(capsys, p4_path)
        # 11. Uninstall E from P4
        self.uninstall_ip(capsys, p4_path, 'e_ss')
        # 12. Uninstall * from P4
        self.uninstall_ip(capsys, p4_path)
        # 13. Logout from P1
        self.logout(capsys)



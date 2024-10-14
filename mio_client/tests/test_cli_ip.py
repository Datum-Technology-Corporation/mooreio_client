# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
import tarfile
from pathlib import Path
from unittest import SkipTest

import pytest
import shutil

import mio_client.cli
from .common import OutputCapture


class TestCliIp:
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

    def package_ip(self, capsys, project_path: Path, ip_name: str, destination:Path):
        result = self.run_cmd(capsys, [f'--wd={project_path}', 'package', ip_name, str(destination)])
        assert result.return_code == 0
        assert "Packaged IP" in result.text
        assert "successfully" in result.text
        assert destination.exists()
        assert destination.is_file()
        assert destination.stat().st_size > 0, "Packaged IP file is empty"
        with tarfile.open(destination, "r:gz") as tar:
            assert tar.getmembers(), "Packaged IP file is not a valid compressed tarball or is empty"

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

    def check_ip_database(self, exp_count:int):
        if mio_client.cli.root_manager.ip_database.num_ips != exp_count:
            raise Exception(f"Expected {exp_count} IPs in database, found {mio_client.cli.root_manager.ip_database.num_ips}")

    def reset_workspace(self):
        p1_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p1"))
        p2_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p2"))
        p3_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p3"))
        p4_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p4"))
        self.remove_directory(p1_path / ".mio")
        self.remove_directory(p2_path / ".mio")
        self.remove_directory(p3_path / ".mio")
        self.remove_directory(p4_path / ".mio")
        self.remove_directory(p1_path / "sim")
        self.remove_directory(p2_path / "sim")
        self.remove_directory(p3_path / "sim")
        self.remove_directory(p4_path / "sim")

    def test_cli_list_ip(self, capsys):
        test_project_path = os.path.join(os.path.dirname(__file__), "data", "project", "valid_local_simplest")
        result = self.run_cmd(capsys, [f'--wd={test_project_path}', 'list'])
        assert result.return_code == 0
        assert "Found 2" in result.text

    def test_cli_package_ip(self, capsys):
        self.reset_workspace()
        p1_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p1"))
        wd_path = Path(os.path.join(os.path.dirname(__file__), "wd"))
        self.package_ip(capsys, p1_path, "a_vlib", Path(wd_path / "a_vlib.tgz"))

    @pytest.mark.integration
    def test_cli_publish_ip(self, capsys):
        self.reset_workspace()
        p1_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p1"))
        p2_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p2"))
        p3_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p3"))
        p4_path = Path(os.path.join(os.path.dirname(__file__), "data", "integration", "p4"))

        # 1. Login
        self.login(capsys, 'admin', 'admin')

        # 2. Publish A from P1
        self.publish_ip(capsys, p1_path, 'a_vlib')
        self.check_ip_database(1)

        # 3. Install A from P2
        self.install_ip(capsys, p2_path, 'a_vlib')
        self.check_ip_database(2)

        # 4. Publish B from P2
        self.publish_ip(capsys, p2_path, 'b_agent')
        self.check_ip_database(2)

        # 5. Install * from P3
        self.install_ip(capsys, p3_path)
        self.check_ip_database(2)

        # 6. Publish C from P3
        self.publish_ip(capsys, p3_path, 'c_block')
        self.check_ip_database(2)

        # 7. Publish D from P3
        self.publish_ip(capsys, p3_path, 'd_lib')
        self.check_ip_database(2)

        # 8. Install A from P4
        self.install_ip(capsys, p4_path, 'a_vlib')
        self.check_ip_database(4)

        # 9. Install E from P4
        self.install_ip(capsys, p4_path, 'e_ss')
        self.check_ip_database(6)

        # 10. Install * from P4
        self.install_ip(capsys, p4_path)
        self.check_ip_database(7)

        # 11. Uninstall E from P4
        self.uninstall_ip(capsys, p4_path, 'e_ss')
        self.check_ip_database(5)

        # 12. Uninstall * from P4
        self.uninstall_ip(capsys, p4_path)
        self.check_ip_database(3)

        # 13. Logout from P1
        self.logout(capsys)



# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
import unittest
from pathlib import Path
from typing import Optional, Dict

import pytest
import yaml
from semantic_version import SimpleSpec

from mio_client.models.ip import Ip, Spec, Structure, HdlSource, DesignUnderTest, Target
from pydantic import constr, BaseModel


def get_fixture_data(file: str) -> Dict:
    file_path = os.path.join(os.path.dirname(__file__), "data", "ip", file) + ".yml"
    with open(file_path, "r") as file:
        return yaml.safe_load(file)


@pytest.fixture(scope="session")
def valid_local_dv_agent_1_data():
    return get_fixture_data("valid_local_dv_agent_1")
@pytest.fixture(scope="session")
def valid_local_dv_tb_fsoc_1_data():
    return get_fixture_data("valid_local_dv_tb_fsoc_1")


class TestIp:
    @pytest.fixture(autouse=True)
    def setup(self, valid_local_dv_agent_1_data, valid_local_dv_tb_fsoc_1_data):
        self.valid_local_dv_agent_1_data = valid_local_dv_agent_1_data
        self.valid_local_dv_tb_fsoc_1_data = valid_local_dv_tb_fsoc_1_data

    def test_agent_instance_creation(self):
        ip_instance = Ip(**self.valid_local_dv_agent_1_data)
        assert isinstance(ip_instance, Ip)

    def test_ip_agent_instance_required_fields(self):
        ip_instance = Ip(**self.valid_local_dv_agent_1_data)
        assert hasattr(ip_instance, 'ip')
        assert hasattr(ip_instance, 'structure')
        assert hasattr(ip_instance, 'hdl_src')
        assert hasattr(ip_instance.ip, 'sync')

    def test_tb_instance_has_all_fields(self):
        ip_instance = Ip(**self.valid_local_dv_tb_fsoc_1_data)
        assert hasattr(ip_instance, 'ip')
        assert hasattr(ip_instance.ip, 'sync')
        assert hasattr(ip_instance.ip, 'type')
        assert hasattr(ip_instance.ip, 'owner')
        assert hasattr(ip_instance.ip, 'name')
        assert hasattr(ip_instance.ip, 'full_name')
        assert hasattr(ip_instance.ip, 'version')
        assert hasattr(ip_instance, 'dut')
        assert hasattr(ip_instance.dut, 'type')
        assert hasattr(ip_instance.dut, 'name')
        assert hasattr(ip_instance.dut, 'target')
        assert hasattr(ip_instance, 'dependencies')
        assert 'datron/xyz' in ip_instance.dependencies
        assert 'gigamicro/jkl' in ip_instance.dependencies
        assert hasattr(ip_instance, 'structure')
        assert hasattr(ip_instance.structure, 'scripts_path')
        assert hasattr(ip_instance.structure, 'docs_path')
        assert hasattr(ip_instance.structure, 'examples_path')
        assert hasattr(ip_instance.structure, 'src_path')
        assert hasattr(ip_instance, 'hdl_src')
        assert hasattr(ip_instance.hdl_src, 'directories')
        assert hasattr(ip_instance.hdl_src, 'top_sv_files')
        assert hasattr(ip_instance.hdl_src, 'top_vhdl_files')
        assert hasattr(ip_instance.hdl_src, 'so_libs')
        assert hasattr(ip_instance, 'targets')
        assert 'default' in ip_instance.targets
        assert 'abc' in ip_instance.targets
        assert 'xyz' in ip_instance.targets
        assert hasattr(ip_instance.targets['default'], 'cmp')
        assert hasattr(ip_instance.targets['default'], 'sim')
        assert hasattr(ip_instance.targets['abc'], 'elab')
        assert hasattr(ip_instance.targets['xyz'], 'sim')

    def test_tb_invalid_dependencies_name(self):
        invalid_data = self.valid_local_dv_agent_1_data.copy()
        invalid_data['dependencies'] = {
            "invalid name": SimpleSpec(">1.0")
        }
        with pytest.raises(ValueError):
            Ip(**invalid_data)

    def test_agent_invalid_target_name(self):
        invalid_data = self.valid_local_dv_agent_1_data.copy()
        invalid_data['targets']['abc']['cmp'] = {
            "invalid name": 123,
            "valid_name": "invalid data"
        }
        with pytest.raises(ValueError):
            Ip(**invalid_data)

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################


import unittest
from typing import Optional, Dict

import pytest
import yaml

from mio_client.models.ip import Ip, Spec, Structure, HdlSource, DesignUnderTest, Target
from pydantic import constr, BaseModel

VALID_IP_OWNER_NAME_REGEX = r"^\w+$"
VALID_NAME_REGEX = r"^\w+$"


@pytest.fixture(scope="session")
def valid_local_dv_agent_1_data():
    with open("data/ip/valid_local_dv_agent_1.yaml", "r") as file:
        return yaml.safe_load(file)


class TestIp:
    @pytest.fixture(autouse=True)
    def setup(self, valid_local_dv_agent_1_data):
        self.valid_local_dv_agent_1_data = valid_local_dv_agent_1_data

    def test_agent_instance_creation(self):
        ip_instance = Ip(**self.valid_local_dv_agent_1_data)
        assert isinstance(ip_instance, Ip)

    def test_ip_instance_required_fields(self):
        ip_instance = Ip(**self.valid_local_dv_agent_1_data)
        assert hasattr(ip_instance, 'synced')
        assert hasattr(ip_instance, 'structure')
        assert hasattr(ip_instance, 'hdl_src')

    def test_agent_instance_field_values(self):
        ip_instance = Ip(**self.valid_local_dv_agent_1_data)
        assert ip_instance.synced == self.valid_local_dv_agent_1_data["synced"]
        assert ip_instance.type == self.valid_local_dv_agent_1_data["type"]
        assert ip_instance.owner == self.valid_local_dv_agent_1_data["owner"]
        assert ip_instance.name == self.valid_local_dv_agent_1_data["name"]
        assert ip_instance.full_name == self.valid_local_dv_agent_1_data["full_name"]
        assert ip_instance.version == self.valid_local_dv_agent_1_data["version"]
        assert ip_instance.description == self.valid_local_dv_agent_1_data["description"]
        assert ip_instance.block_diagram == self.valid_local_dv_agent_1_data["block_diagram"]
        assert ip_instance.structure.scripts_path == self.valid_local_dv_agent_1_data["structure"]["scripts_path"]
        assert ip_instance.structure.docs_path == self.valid_local_dv_agent_1_data["structure"]["docs_path"]
        assert ip_instance.structure.examples_path == self.valid_local_dv_agent_1_data["structure"]["examples_path"]
        assert ip_instance.structure.src_path == self.valid_local_dv_agent_1_data["structure"]["src_path"]
        assert ip_instance.hdl_src.directories == self.valid_local_dv_agent_1_data["hdl_src"]["directories"]
        assert ip_instance.hdl_src.top_files == self.valid_local_dv_agent_1_data["hdl_src"]["top_files"]
        assert ip_instance.hdl_src.so_libs == self.valid_local_dv_agent_1_data["hdl_src"]["so_libs"]

    def test_agent_invalid_dependencies_name(self):
        invalid_data = self.valid_local_dv_agent_1_data.copy()
        invalid_data['dependencies'] = {
            "invalid name": Spec(">1.0")
        }
        with pytest.raises(ValueError):
            Ip(**invalid_data)

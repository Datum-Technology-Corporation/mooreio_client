# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
import unittest
from pathlib import Path
from typing import Optional, Dict

import pytest
import toml
import yaml

from mio_client.models.configuration import Configuration
from pydantic import constr, BaseModel


def get_fixture_data(file: str) -> Dict:
    file_path = os.path.join(os.path.dirname(__file__), "data", "configuration", file) + ".toml"
    with open(file_path, "r") as file:
        return toml.load(file)


@pytest.fixture(scope="session")
def valid_local_1_data():
    return get_fixture_data("valid_local_1")
@pytest.fixture(scope="session")
def valid_sync_1_data():
    return get_fixture_data("valid_sync_1")


class TestConfiguration:
    @pytest.fixture(autouse=True)
    def setup(self, valid_local_1_data, valid_sync_1_data):
        self.valid_local_1_data = valid_local_1_data
        self.valid_sync_1_data = valid_sync_1_data

    def test_agent_instance_creation(self):
        config_instance = Configuration(**self.valid_local_1_data)
        assert isinstance(config_instance, Configuration)

    def test_configuration_agent_instance_required_fields(self):
        config_instance = Configuration(**self.valid_sync_1_data)
        assert hasattr(config_instance, 'project')
        assert hasattr(config_instance, 'logic_simulation')
        assert hasattr(config_instance, 'synthesis')
        assert hasattr(config_instance, 'lint')
        assert hasattr(config_instance, 'ip')
        assert hasattr(config_instance, 'docs')
        assert hasattr(config_instance, 'encryption')

    def test_tb_instance_has_all_fields(self):
        config_instance = Configuration(**self.valid_local_1_data)
        assert hasattr(config_instance, 'project')
        assert hasattr(config_instance.project, 'sync')
        assert hasattr(config_instance.project, 'name')
        assert hasattr(config_instance.project, 'full_name')
        assert hasattr(config_instance, 'logic_simulation')
        assert hasattr(config_instance.logic_simulation, 'root_path')
        assert hasattr(config_instance.logic_simulation, 'regression_directory_name')
        assert hasattr(config_instance.logic_simulation, 'results_directory_name')
        assert hasattr(config_instance.logic_simulation, 'logs_directory')
        assert hasattr(config_instance.logic_simulation, 'test_result_path_template')
        assert hasattr(config_instance.logic_simulation, 'uvm_version')
        assert hasattr(config_instance.logic_simulation, 'timescale')
        assert hasattr(config_instance.logic_simulation, 'metrics_dsim_path')
        assert hasattr(config_instance, 'synthesis')
        assert hasattr(config_instance.synthesis, 'root_path')
        assert hasattr(config_instance, 'lint')
        assert hasattr(config_instance.lint, 'root_path')
        assert hasattr(config_instance, 'ip')
        assert hasattr(config_instance.ip, 'global_paths')
        assert hasattr(config_instance.ip, 'local_paths')
        assert hasattr(config_instance, 'docs')
        assert hasattr(config_instance.docs, 'root_path')
        assert hasattr(config_instance, 'encryption')
        assert hasattr(config_instance.encryption, 'metrics_dsim_key_path')

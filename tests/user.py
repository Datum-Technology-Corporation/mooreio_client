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

from mio_client.models.user import User
from pydantic import constr, BaseModel


def get_fixture_data(file: str) -> Dict:
    file_path = os.path.join(os.path.dirname(__file__), "data", "user", file) + ".yml"
    with open(file_path, "r") as file:
        return yaml.safe_load(file)


@pytest.fixture(scope="session")
def valid_local_1_data():
    return get_fixture_data("valid_local_1")

@pytest.fixture(scope="session")
def valid_authenticated_1():
    return get_fixture_data("valid_authenticated_1")


class TestConfiguration:
    @pytest.fixture(autouse=True)
    def setup(self, valid_local_1_data, valid_authenticated_1):
        self.valid_local_1_data = valid_local_1_data
        self.valid_authenticated_1 = valid_authenticated_1

    def test_agent_instance_creation(self):
        config_instance = User(**self.valid_local_1_data)
        assert isinstance(config_instance, User)

    def test_configuration_agent_instance_required_fields(self):
        config_instance = User(**self.valid_local_1_data)
        assert hasattr(config_instance, 'authenticated')

    def test_tb_instance_has_all_fields(self):
        config_instance = User(**self.valid_authenticated_1)
        assert hasattr(config_instance, 'authenticated')
        assert hasattr(config_instance, 'username')
        assert hasattr(config_instance, 'token')

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################


import yaml

from mio_cli.core.model import Model


class TestSuite(Model):
    def __init__(self, name, ip, settings, target, functional, error):
        self.name = name
        self.ip = ip
        self.settings = settings
        self.target = target
        self.functional = functional
        self.error = error

    @classmethod
    def from_yaml(cls, yaml_data):
        return cls(
            name=yaml_data['test-suite']['name'],
            ip=yaml_data['test-suite']['ip'],
            settings=yaml_data['test-suite']['settings'],
            target=yaml_data['test-suite']['target'],
            functional=yaml_data['functional'],
            error=yaml_data['error'],
        )


def load_test_suite(file_path):
    with open(file_path, 'r') as f:
        data = yaml.safe_load(f)
        return TestSuite.from_yaml(data)

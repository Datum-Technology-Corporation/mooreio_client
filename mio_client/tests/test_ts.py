# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from typing import Dict

import pytest
import yaml
from semantic_version import SimpleSpec

from mio_client.core.ip import Ip
from mio_client.services.regression import TestSuite


def get_fixture_data(file: str) -> Dict:
    file_path = os.path.join(os.path.dirname(__file__), "data", "ts", file) + ".ts.yml"
    with open(file_path, "r") as file:
        return yaml.safe_load(file)


@pytest.fixture(scope="session")
def basic_valid_1_data():
    return get_fixture_data("basic_valid_1")


class TestIp:
    @pytest.fixture(autouse=True)
    def setup(self, basic_valid_1_data):
        self.basic_valid_1_data = basic_valid_1_data

    def test_ts_instance_creation(self):
        ts_instance = TestSuite(**self.basic_valid_1_data)
        assert isinstance(ts_instance, TestSuite)

    def test_ts_instance_required_fields(self):
        ts_instance = TestSuite(**self.basic_valid_1_data)
        assert hasattr(ts_instance, 'ts')
        assert hasattr(ts_instance.ts, 'name')
        assert hasattr(ts_instance.ts, 'ip')
        assert hasattr(ts_instance.ts, 'target')
        assert hasattr(ts_instance.ts, 'settings')
        assert hasattr(ts_instance, 'sets')

    def test_ts_instance_has_all_fields(self):
        ts_instance = TestSuite(**self.basic_valid_1_data)
        assert hasattr(ts_instance, 'ts')
        assert hasattr(ts_instance.ts, 'name')
        assert hasattr(ts_instance.ts, 'ip')
        assert hasattr(ts_instance.ts, 'target')
        assert hasattr(ts_instance.ts, 'settings')
        assert hasattr(ts_instance.ts.settings, 'waves')
        assert hasattr(ts_instance.ts.settings, 'cov')
        assert hasattr(ts_instance.ts.settings, 'verbosity')
        assert hasattr(ts_instance.ts.settings, 'max_duration')
        assert hasattr(ts_instance.ts.settings, 'max_jobs')
        assert 'sanity' in ts_instance.ts.settings.waves
        assert 'bugs' in ts_instance.ts.settings.waves
        assert 'nightly' in ts_instance.ts.settings.cov
        assert 'weekly' in ts_instance.ts.settings.cov
        assert 'sanity' in ts_instance.ts.settings.verbosity
        assert 'nightly' in ts_instance.ts.settings.verbosity
        assert 'weekly' in ts_instance.ts.settings.verbosity
        assert 'bugs' in ts_instance.ts.settings.verbosity
        assert 'sanity' in ts_instance.ts.settings.max_duration
        assert 'nightly' in ts_instance.ts.settings.max_duration
        assert 'weekly' in ts_instance.ts.settings.max_duration
        assert 'bugs' in ts_instance.ts.settings.max_duration
        assert 'sanity' in ts_instance.ts.settings.max_jobs
        assert 'nightly' in ts_instance.ts.settings.max_jobs
        assert 'weekly' in ts_instance.ts.settings.max_jobs
        assert 'bugs' in ts_instance.ts.settings.max_jobs

        assert hasattr(ts_instance, 'sets')

        assert 'functional' in ts_instance.sets
        functional_set = ts_instance.sets['functional']
        assert 'fixed_stim' in functional_set
        fixed_stim_group = functional_set['fixed_stim']
        assert 'sanity' in fixed_stim_group
        assert 'nightly' in fixed_stim_group
        assert 'weekly' in fixed_stim_group
        assert 'rand_stim' in functional_set
        rand_stim_group = functional_set['rand_stim']
        sanity_test_spec = rand_stim_group['sanity']
        args = sanity_test_spec.args
        assert 'ABC' in args
        assert 'DEF' in args
        nightly_test_spec = rand_stim_group['nightly']
        args = nightly_test_spec.args
        assert 'DEF' in args
        assert 'weekly' in rand_stim_group
        assert 'bugs' in rand_stim_group

        assert 'error' in ts_instance.sets
        error_set = ts_instance.sets['error']
        assert 'fixed_err_stim' in error_set
        fixed_err_stim_group = error_set['fixed_err_stim']
        assert 'sanity' in fixed_err_stim_group
        assert 'nightly' in fixed_err_stim_group
        assert 'weekly' in fixed_err_stim_group
        weekly_test_spec = fixed_err_stim_group['weekly']
        assert 'bugs' in fixed_err_stim_group
        rand_err_stim_group = error_set['rand_err_stim']
        sanity_test_spec = rand_err_stim_group['sanity']
        args = sanity_test_spec.args
        assert 'ABC' in args
        assert 'DEF' in args
        nightly_test_spec = rand_err_stim_group['nightly']
        assert 'DEF' in args
        assert 'weekly' in rand_err_stim_group

    def test_ts_invalid_name(self):
        invalid_data = self.basic_valid_1_data.copy()
        invalid_data['ts']['name'] = ""
        with pytest.raises(ValueError):
            Ip(**invalid_data)

    def test_ts_invalid_ip(self):
        invalid_data = self.basic_valid_1_data.copy()
        invalid_data['ts']['ip'] = ""
        with pytest.raises(ValueError):
            Ip(**invalid_data)

    def test_ts_invalid_target(self):
        invalid_data = self.basic_valid_1_data.copy()
        invalid_data['ts']['target'] = []
        with pytest.raises(ValueError):
            Ip(**invalid_data)

    def test_ts_invalid_settings(self):
        invalid_data = self.basic_valid_1_data.copy()
        invalid_data['ts']['settings'] = []
        with pytest.raises(ValueError):
            Ip(**invalid_data)

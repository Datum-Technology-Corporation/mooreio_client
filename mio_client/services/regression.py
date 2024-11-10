# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import re
import warnings
from pathlib import Path
from random import randint
from typing import Optional, List, Dict, Union, Any

import yaml
from pydantic import PositiveInt, PositiveFloat
from pydantic.types import constr
from enum import Enum


from mio_client.core.scheduler import JobScheduler, Job, JobSchedulerConfiguration
from mio_client.core.service import Service, ServiceType
from mio_client.core.ip import Ip
from mio_client.core.model import Model, VALID_NAME_REGEX
from simulation import LogicSimulatorSimulationConfiguration, LogicSimulatorCompilationConfiguration, \
    LogicSimulatorElaborationConfiguration, LogicSimulatorCompilationAndElaborationConfiguration


#######################################################################################################################
# API Entry Point
#######################################################################################################################
def get_services():
    return []


#######################################################################################################################
# Models
#######################################################################################################################
VALID_TARGET_NAME_REGEX = re.compile(r"^((\*)|(\w+))$")
class UVMVerbosityLevels(Enum):
    UVM_NONE = "none"
    UVM_LOW = "low"
    UVM_MEDIUM = "medium"
    UVM_HIGH = "high"
    UVM_FULL = "full"
    UVM_DEBUG = "debug"
    
class TestSpecTypes(Enum):
    NUM_RAND_SEEDS = "repeat"
    SEED_LIST = "seed_list"
    
class DSimCloudComputeSizes(Enum):
    S4 = "s4"
    S8 = "s8"
        
        

class DSimCloudTaskResource(Model):
    name: str
    path: Path

class DSimCloudTaskInputs(Model):
    working: List[DSimCloudTaskResource]

class DSimCloudTaskOutputs(Model):
    working: Optional[List[DSimCloudTaskResource]] = []
    artifacts: Optional[List[DSimCloudTaskResource]] = []

class DSimCloudTask(Model):
    name: str
    compute_size: Optional[DSimCloudComputeSizes] = DSimCloudComputeSizes.S4
    depends: List[str]
    commands: List[str]
    inputs: Optional[DSimCloudTaskInputs] = None
    outputs: DSimCloudTaskOutputs

class DSimCloudJob(Model):
    name: str
    keep_for_support: Optional[bool] = False
    tasks: List[DSimCloudTask]



class Settings(Model):
    cov: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    waves: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    max_duration: Optional[Dict[constr(pattern=VALID_NAME_REGEX), PositiveFloat]] = {}
    max_errors: Optional[Dict[constr(pattern=VALID_NAME_REGEX), PositiveInt]] = {}
    max_jobs: Optional[Dict[constr(pattern=VALID_NAME_REGEX), PositiveInt]] = {}
    verbosity: Optional[Dict[constr(pattern=VALID_NAME_REGEX), UVMVerbosityLevels]] = {}


class About(Model):
    name: constr(pattern=VALID_NAME_REGEX)
    ip: constr(pattern=VALID_NAME_REGEX)
    target: List[constr(pattern=VALID_TARGET_NAME_REGEX)]
    settings: Settings


class ResolvedTestSpec:
    test_name: str
    spec_type: TestSpecTypes
    num_rand_seeds: int
    specific_seeds: List[int]
    args: Dict[str, Union[bool, str]] = {}
    test_suite:'TestSuite'
    regression:'Regression'
    test_set:'TestSet'
    test_group:'TestGroup'


class TestGroup:
    name: str
    test_specs: List[ResolvedTestSpec] = []
    test_set:'TestSet'
    regression:'Regression'
    test_suite:'TestSuite'

    def __init__(self, name:str, test_set: 'TestSet'):
        self.name = name
        self.test_set = test_set
        self.regression = test_set.regression
        self.test_suite = self.regression.test_suite
    
    def add_test_spec(self, test_spec: ResolvedTestSpec):
        self.test_specs.append(test_spec)
        test_spec.test_group = self
        test_spec.test_set = self.test_set
        test_spec.regression = self.regression
        test_spec.test_suite = self.test_suite


class TestSet:
    name: str
    test_groups: Dict[str, TestGroup] = {}
    regression:'Regression'
    test_suite:'TestSuite'

    def __init__(self, name:str, regression: 'Regression'):
        self.name = name
        self.regression = regression
        self.test_suite = regression.test_suite
    
    def add_test_group(self, name: str) -> TestGroup:
        if name in self.test_groups:
            return self.test_groups[name]
        else:
            test_group = TestGroup(name, self)
            self.test_groups[name] = test_group
            return test_group


class Regression:
    name: str
    test_sets: Dict[str, TestSet] = {}
    waves_enabled:bool = False
    cov_enabled:bool = False
    verbosity:UVMVerbosityLevels = UVMVerbosityLevels.UVM_MEDIUM
    max_errors:int = 10
    max_duration:float = 1.0
    max_jobs:int = 1
    test_suite: 'TestSuite'

    def __init__(self, name:str, test_suite: 'TestSuite'):
        self.name = name
        self.test_suite = test_suite
    
    def add_test_set(self, name: str) -> TestSet:
        if name in self.test_sets:
            return self.test_sets[name]
        else:
            test_set = TestSet(name, self)
            self.test_sets[name] = test_set
            return test_set
    
    def render_cmp_config(self, target_name:str="default") -> LogicSimulatorCompilationConfiguration:
        config = LogicSimulatorCompilationConfiguration()
        config.max_errors = self.max_errors
        config.enable_waveform_capture = self.waves_enabled
        config.enable_coverage = self.waves_enabled
        config.target = target_name
        return config
    
    def render_elab_config(self, target_name:str="default") -> LogicSimulatorElaborationConfiguration:
        config = LogicSimulatorElaborationConfiguration()
        return config
    
    def render_cmp_elab_config(self, target_name:str="default") -> LogicSimulatorCompilationAndElaborationConfiguration:
        config = LogicSimulatorCompilationAndElaborationConfiguration()
        config.max_errors = self.max_errors
        config.enable_waveform_capture = self.waves_enabled
        config.enable_coverage = self.waves_enabled
        config.target = target_name
        return config
    
    def render_sim_configs(self, target_name:str="default") -> List[LogicSimulatorSimulationConfiguration]:
        sim_configs = []
        for set_name in self.test_sets:
            for group_name in self.test_sets[set_name].test_groups:
                for test_spec in self.test_sets[set_name].test_groups[group_name].test_specs:
                    seeds = []
                    if test_spec.spec_type == TestSpecTypes.SEED_LIST:
                        seeds = test_spec.specific_seeds
                    elif test_spec.spec_type == TestSpecTypes.NUM_RAND_SEEDS:
                        seeds = [randint(1, ((1 << 31)-1)) for _ in range(test_spec.num_rand_seeds)]
                    for seed in seeds:
                        config = LogicSimulatorSimulationConfiguration()
                        config.seed = seed
                        config.verbosity = self.verbosity
                        config.max_errors = self.max_errors
                        config.gui_mode = False
                        config.enable_waveform_capture = self.waves_enabled
                        config.enable_coverage = self.cov_enabled
                        config.test_name = test_spec.test_name
                        for key, value in test_spec.args.items():
                            if isinstance(value, bool):
                                if value:
                                    config.args_boolean.append(key)
                            else:
                                config.args_value[key] = value
                        config.target = target_name
                        sim_configs.append(config)
        return sim_configs
        
    def render_dsim_cloud_job(self) -> DSimCloudJob:
        tasks = []
        job_data = {
            'name': f"{self.test_suite.resolved_ip.ip.name}-{self.name}",
            'tasks': tasks
        }
        return DSimCloudJob(**job_data)



SpecTestArg = Union[str, int, float, bool]

class TestSpec(Model):
    seeds: Union[PositiveInt, List[PositiveInt]]
    args: Optional[Dict[constr(pattern=VALID_NAME_REGEX), SpecTestArg]] = {}

SpecRegression = Union[TestSpec, PositiveInt, List[PositiveInt]]
SpecTest = Dict[constr(pattern=VALID_NAME_REGEX), SpecRegression]
SpecTestGroup = Dict[constr(pattern=VALID_NAME_REGEX), SpecTest]


class TestSuite(Model):
    ts: About
    sets: Dict[constr(pattern=VALID_NAME_REGEX), SpecTestGroup]

    def __init__(self, **data: Any):
        super().__init__(**data)
        self._file_path: Path = None
        self._file_path_set: bool = False
        self._resolved_ip:Ip = None
        self._supports_all_targets:bool = False
        self._resolved_valid_targets:List[str] = []
        self._resolved_regressions:Dict[str, Regression] = {}

    def __str__(self):
        return f"{self.ts.ip}/{self.ts.name}"

    @classmethod
    def load(cls, file_path):
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)
            if data is None:
                data = {}
            instance = cls(**data)
            instance.file_path = file_path
            return instance

    @property
    def name(self) -> str:
        return self.ts.name

    @property
    def file_path(self) -> Path:
        return self._file_path
    @file_path.setter
    def file_path(self, value: str):
        self._file_path_set = True
        self._file_path = Path(value)
    
    @property
    def resolved_ip(self) -> Ip:
        return self._resolved_ip
    @resolved_ip.setter
    def resolved_ip(self, value: Ip):
        self._resolved_ip = value
    
    @property
    def supports_all_targets(self) -> bool:
        return self._supports_all_targets
    
    @property
    def resolved_valid_targets(self) -> List[str]:
        return self._resolved_valid_targets

    @property
    def resolved_regressions(self) -> Dict[str, Regression]:
        return self._resolved_regressions

    def add_regression(self, name:str) -> Regression:
        if name in self._resolved_regressions:
            return self._resolved_regressions[name]
        else:
            regression = Regression(name, self)
            self._resolved_regressions[name] = regression
            return regression
    
    def check(self):
        # Check targets
        if len(self.ts.target) == 0:
            raise Exception(f"Must specify target(s)")
        for target in self.ts.target:
            clean_target = target.strip().lower()
            if clean_target == "*":
                self._supports_all_targets = True
                if len(self.ts.target) > 1:
                    warnings.warn(
                        f"Warning for test suite '{self}': target entries are being ignored due to the presence of wildcard '*' in the target list.")
                break
            else:
                self._resolved_valid_targets.append(clean_target)
        # Resolve test sets/groups/specs/regressions
        for test_set_name in self.sets:
            test_set_spec = self.sets[test_set_name]
            for test_group_name in test_set_spec:
                test_group_spec = test_set_spec[test_group_name]
                for test_spec_name in test_group_spec:
                    test_spec_data = test_group_spec[test_spec_name]
                    for regression_name in test_spec_data:
                        regression = self.add_regression(regression_name)
                        test_set = regression.add_test_set(test_set_name)
                        test_group = test_set.add_test_group(test_group_name)
                        regression_data = test_spec_data[regression_name]
                        if type(regression_data) is int:
                            test_spec = ResolvedTestSpec()
                            test_spec.test_name = test_spec_name
                            test_spec.spec_type = TestSpecTypes.NUM_RAND_SEEDS
                            test_spec.num_rand_seeds = int(regression_data)
                            test_group.add_test_spec(test_spec)
                        elif type(regression_data) is list:
                            for regression_entry in regression_data:
                                if type(regression_entry) is TestSpec:
                                    test_spec = ResolvedTestSpec()
                                    test_spec.test_name = test_spec_name
                                    test_spec.args = regression_entry.args
                                    if type(regression_entry.seeds) is int:
                                        test_spec.spec_type = TestSpecTypes.NUM_RAND_SEEDS
                                        test_spec.num_rand_seeds = regression_entry.seeds
                                    elif type(regression_entry.seeds) is list:
                                        test_spec.spec_type = TestSpecTypes.SEED_LIST
                                        test_spec.specific_seeds = regression_entry.seeds
                                    test_group.add_test_spec(test_spec)
                                elif type(regression_entry) is list:
                                    test_spec = ResolvedTestSpec()
                                    test_spec.test_name = test_spec_name
                                    test_spec.spec_type = TestSpecTypes.SEED_LIST
                                    test_spec.specific_seeds = regression_entry
                                    test_group.add_test_spec(test_spec)
        # Ensure regression names in settings exist and apply settings to regressions
        for regression_name in self.settings.cov:
            if regression_name not in self._resolved_regressions:
                warnings.warn(f"Regression '{regression_name}' does not exist and its coverage setting is ignored")
            else:
                self._resolved_regressions[regression_name].cov_enabled = True
        for regression_name in self.settings.waves:
            if regression_name not in self._resolved_regressions:
                warnings.warn(f"Regression '{regression_name}' does not exist and its wave capture setting is ignored")
            else:
                self._resolved_regressions[regression_name].waves_enabled = True
        for regression_name in self.settings.max_duration:
            if regression_name not in self._resolved_regressions:
                warnings.warn(f"Regression '{regression_name}' does not exist and its max duration setting is ignored")
            else:
                self._resolved_regressions[regression_name].max_duration = self.settings.max_duration[regression_name]
        for regression_name in self.settings.max_errors:
            if regression_name not in self._resolved_regressions:
                warnings.warn(f"Regression '{regression_name}' does not exist and its max errors setting is ignored")
            else:
                self._resolved_regressions[regression_name].max_errors = self.settings.max_errors[regression_name]
        for regression_name in self.settings.max_jobs:
            if regression_name not in self._resolved_regressions:
                warnings.warn(f"Regression '{regression_name}' does not exist and its max jobs setting is ignored")
            else:
                self._resolved_regressions[regression_name].max_jobs = self.settings.max_jobs[regression_name]
        for regression_name in self.settings.verbosity:
            if regression_name not in self._resolved_regressions:
                warnings.warn(f"Regression '{regression_name}' does not exist and its verbosity setting is ignored")
            else:
                self._resolved_regressions[regression_name].verbosity = self.settings.verbosity[regression_name]
        

class RegressionReport(Model):
    pass



class RegressionDatabase(Service):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, 'datum', 'regression_database', 'Regression Database')
        self._type = ServiceType.REGRESSION
        self._test_suites:List[TestSuite] = []
    
    def discover_test_suites(self, path:Path):
        path = Path(path)  # Ensure `path` is a Path object
        ts_files = path.rglob('*ts.yml')
        for ts_file in ts_files:
            try:
                test_suite = TestSuite.load(ts_file)
                test_suite.check()
                self._test_suites.append(test_suite)
            except Exception as e:
                warnings.warn(f"Failed to process {ts_file}: {e}")

    def find_regression(self, test_suite_name:str, regression_name:str, raise_exception_if_not_found:bool=False):
        # Search for the test suite with the specified name
        for test_suite in self._test_suites:
            if test_suite.name == test_suite_name:
                # Search for the regression in the found test suite
                if regression_name in test_suite.resolved_regressions:
                    return test_suite.resolved_regressions[regression_name]
                else:
                    if raise_exception_if_not_found:
                        raise Exception(f"Regression '{regression_name}' not found in Test Suite '{test_suite_name}'")
                    return None
        # If no matching test suite is found
        if raise_exception_if_not_found:
            raise Exception(f"Test suite '{test_suite_name}' not found")
        return None

    def find_regression_default_test_suite(self, regression_name:str, raise_exception_if_not_found:bool=False):
        if len(self._test_suites) == 0:
            raise Exception(f"No Test Suites")
        elif len(self._test_suites) == 1:
            if regression_name in self._test_suites[0].resolved_regressions:
                return self._test_suites[0].resolved_regressions[regression_name]
            else:
                if raise_exception_if_not_found:
                    raise Exception(f"Regression '{regression_name}' not found in default Test Suite")
                return None
        else:
            raise Exception(f"More than one Test Suite present, must specify (cannot use default)")
# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import datetime
import os
import re
import warnings
from pathlib import Path
from random import randint
from typing import Optional, List, Dict, Union, Any
from concurrent.futures import ThreadPoolExecutor, as_completed
from xml.etree import ElementTree

from semantic_version import Version
from tqdm import tqdm

import yaml
from pydantic import PositiveInt, PositiveFloat
from pydantic.types import constr
from enum import Enum

from configuration import LogicSimulators
from mio_client.core.scheduler import JobScheduler, Job, JobSchedulerConfiguration
from mio_client.core.service import Service, ServiceType
from mio_client.core.ip import Ip
from mio_client.core.model import Model, VALID_NAME_REGEX
from phase import Phase
from scheduler import JobResults
from simulation import LogicSimulatorSimulationConfiguration, LogicSimulatorCompilationConfiguration, \
    LogicSimulatorElaborationConfiguration, LogicSimulatorCompilationAndElaborationConfiguration, \
    LogicSimulatorSimulationReport, LogicSimulator, LogicSimulatorCompilationReport, LogicSimulatorElaborationReport, \
    LogicSimulatorCompilationAndElaborationReport, SimulatorMetricsDSim, DSimCloudJob, DSimCloudSimulationConfiguration, \
    UvmVerbosity


#######################################################################################################################
# API Entry Point
#######################################################################################################################
def get_services():
    return [RegressionDatabase]


#######################################################################################################################
# Models
#######################################################################################################################
VALID_TARGET_NAME_REGEX = re.compile(r"^((\*)|(\w+))$")

class TestSpecTypes(Enum):
    NUM_RAND_SEEDS = "repeat"
    SEED_LIST = "seed_list"


class About(Model):
    name: constr(pattern=VALID_NAME_REGEX)
    ip: constr(pattern=VALID_NAME_REGEX)
    target: List[constr(pattern=VALID_TARGET_NAME_REGEX)]
    cov: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    waves: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    max_duration: Optional[Dict[constr(pattern=VALID_NAME_REGEX), PositiveFloat]] = {}
    max_errors: Optional[Dict[constr(pattern=VALID_NAME_REGEX), PositiveInt]] = {}
    max_jobs: Optional[Dict[constr(pattern=VALID_NAME_REGEX), PositiveInt]] = {}
    verbosity: Optional[Dict[constr(pattern=VALID_NAME_REGEX), UvmVerbosity]] = {}


class ResolvedTestSpec:
    def __init__(self):
        self.test_name: str = ""
        self.spec_type: TestSpecTypes = TestSpecTypes.NUM_RAND_SEEDS
        self.num_rand_seeds: int = 0
        self.specific_seeds: List[int] = []
        self.args: Dict[str, Union[bool, str]] = {}
        self.test_suite: 'TestSuite' = None
        self.regression: 'Regression' = None
        self.test_set: 'TestSet' = None
        self.test_group: 'TestGroup' = None


class TestGroup:
    def __init__(self, name: str, test_set: 'TestSet'):
        self.name: str = name
        self.test_set: 'TestSet' = test_set
        self.test_specs: List[ResolvedTestSpec] = []
        self.regression: 'Regression' = test_set.regression
        self.test_suite: 'TestSuite' = self.regression.test_suite
    
    def add_test_spec(self, test_spec: ResolvedTestSpec):
        test_spec.test_group = self
        test_spec.test_set = self.test_set
        test_spec.regression = self.regression
        test_spec.test_suite = self.test_suite
        self.test_specs.append(test_spec)


class TestSet:
    def __init__(self, name: str, regression: 'Regression'):
        self.name: str = name
        self.test_groups: Dict[str, TestGroup] = {}
        self.regression: 'Regression' = regression
        self.test_suite: 'TestSuite' = regression.test_suite
    
    def add_test_group(self, name: str) -> TestGroup:
        if name in self.test_groups:
            return self.test_groups[name]
        else:
            test_group = TestGroup(name, self)
            self.test_groups[name] = test_group
            return test_group


class Regression:
    def __init__(self, name: str, test_suite: 'TestSuite'):
        self.name: str = name
        self.directory_name: str = ""
        self.results_path: Path = Path()
        self.test_suite = test_suite
        self.db: 'RegressionDatabase' = self.test_suite.db
        self.rmh: 'RootManager' = self.db.rmh
        self.ip: Ip = None
        self.timestamp_start: datetime.datetime = datetime.datetime.now()
        self.timestamp_end: datetime.datetime = None
        self.duration: datetime.timedelta = datetime.timedelta()
        self.test_sets: Dict[str, TestSet] = {}
        self.waves_enabled: bool = False
        self.cov_enabled: bool = False
        self.verbosity: UvmVerbosity = UvmVerbosity.MEDIUM
        self.max_errors: int = 10
        self.max_duration: float = 1.0
        self.max_jobs: int = 1
        self.test_suite: 'TestSuite'
        self.test_specs: Dict[int, ResolvedTestSpec] = {}

    def set_ip(self, ip: Ip):
        self.ip = ip
        self.test_suite.resolved_ip = self.ip
        sim_path: Path = self.rmh.project_root_path / self.rmh.configuration.logic_simulation.root_path
        regression_dir_name: str = self.rmh.configuration.logic_simulation.regression_directory_name
        timestamp_start: str = self.timestamp_start.strftime("%Y_%m_%d_%H_%M_%S")
        self.directory_name: str = f"{self.ip.result_file_name}_{self.name}_{timestamp_start}"
        self.results_path: Path = Path(os.path.join(sim_path, regression_dir_name, self.directory_name))

    def add_test_set(self, name: str) -> TestSet:
        if name in self.test_sets:
            return self.test_sets[name]
        else:
            test_set = TestSet(name, self)
            self.test_sets[name] = test_set
            return test_set
    
    def render_cmp_config(self, target_name: str="default") -> LogicSimulatorCompilationConfiguration:
        config = LogicSimulatorCompilationConfiguration()
        config.use_custom_results_path = True
        config.custom_sim_results_path = self.results_path
        config.max_errors = self.max_errors
        config.enable_waveform_capture = self.waves_enabled
        config.enable_coverage = self.waves_enabled
        config.target = target_name
        return config
    
    def render_elab_config(self, target_name: str="default") -> LogicSimulatorElaborationConfiguration:
        config = LogicSimulatorElaborationConfiguration()
        config.use_custom_results_path = True
        config.custom_sim_results_path = self.results_path
        return config
    
    def render_cmp_elab_config(self, target_name: str="default") -> LogicSimulatorCompilationAndElaborationConfiguration:
        config = LogicSimulatorCompilationAndElaborationConfiguration()
        config.use_custom_results_path = True
        config.custom_sim_results_path = self.results_path
        config.max_errors = self.max_errors
        config.enable_waveform_capture = self.waves_enabled
        config.enable_coverage = self.waves_enabled
        config.target = target_name
        return config
    
    def render_sim_configs(self, target_name: str="default") -> Dict[int, LogicSimulatorSimulationConfiguration]:
        sim_configs: Dict[int, LogicSimulatorSimulationConfiguration] = {}
        for set_name in self.test_sets:
            for group_name in self.test_sets[set_name].test_groups:
                for test_spec in self.test_sets[set_name].test_groups[group_name].test_specs:
                    seeds = []
                    if test_spec.spec_type == TestSpecTypes.SEED_LIST:
                        seeds = test_spec.specific_seeds
                    elif test_spec.spec_type == TestSpecTypes.NUM_RAND_SEEDS:
                        for _ in range(test_spec.num_rand_seeds):
                            random_int = randint(1, ((1 << 31) - 1))
                            while random_int in sim_configs:
                                random_int = randint(1, ((1 << 31) - 1))
                            seeds.append(random_int)
                    for seed in seeds:
                        config = LogicSimulatorSimulationConfiguration()
                        config.use_custom_results_path = True
                        config.custom_sim_results_path = self.results_path
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
                        sim_configs[seed] = config
                        self.test_specs[seed] = test_spec
        return sim_configs


SpecTestArg = Union[str, int, float, bool]

class TestSpec(Model):
    seeds: Union[PositiveInt, List[PositiveInt]]
    args: Optional[Dict[constr(pattern=VALID_NAME_REGEX), SpecTestArg]] = {}

SpecTestGroups = Dict[constr(pattern=VALID_NAME_REGEX), TestSpec]
SpecRegression = Union[TestSpec, SpecTestGroups, PositiveInt, List[PositiveInt]]
SpecTest = Dict[constr(pattern=VALID_NAME_REGEX), SpecRegression]
SpecTestSet = Dict[constr(pattern=VALID_NAME_REGEX), SpecTest]


class TestSuite(Model):
    ts: About
    tests: Dict[constr(pattern=VALID_NAME_REGEX), SpecTestSet]

    def __init__(self, **data: Any):
        super().__init__(**data)
        self._db: 'RegressionDatabase' = None
        self._file_path: Path = None
        self._file_path_set: bool = False
        self._resolved_ip: Ip = None
        self._supports_all_targets: bool = False
        self._resolved_valid_targets: List[str] = []
        self._resolved_regressions: Dict[str, Regression] = {}

    def __str__(self):
        return f"{self.ts.ip}/{self.ts.name}"
    
    @property
    def db(self) -> 'RegressionDatabase':
        return self._db

    @classmethod
    def load(cls, db: 'RegressionDatabase', file_path: Path):
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)
            if data is None:
                data = {}
            instance = cls(**data)
            instance._db = db
            instance._file_path = file_path
            return instance

    @property
    def name(self) -> str:
        return self.ts.name

    @property
    def file_path(self) -> Path:
        return self._file_path
    
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
                    self.db.rmh.warning(
                        f"Warning for test suite '{self}': target entries are being ignored due to the presence of wildcard '*' in the target list.")
                break
            else:
                self._resolved_valid_targets.append(clean_target)
        # Resolve test sets/groups/specs/regressions
        for test_set_name in self.tests:
            test_set_spec = self.tests[test_set_name]
            for test_name in test_set_spec:
                test_spec = test_set_spec[test_name]
                for regression_name in test_spec:
                    regression = self.add_regression(regression_name)
                    test_set = regression.add_test_set(test_set_name)
                    regression_data = test_spec[regression_name]
                    if type(regression_data) is int:
                        resolved_test_spec = ResolvedTestSpec()
                        resolved_test_spec.test_name = test_name
                        resolved_test_spec.spec_type = TestSpecTypes.NUM_RAND_SEEDS
                        resolved_test_spec.num_rand_seeds = int(regression_data)
                        test_group = test_set.add_test_group("default")
                        test_group.add_test_spec(resolved_test_spec)
                    elif type(regression_data) is TestSpec:
                        resolved_test_spec = ResolvedTestSpec()
                        resolved_test_spec.test_name = test_name
                        if 'args' in regression_data:
                            resolved_test_spec.args = regression_data['args']
                        if type(regression_data['seeds']) is int:
                            resolved_test_spec.spec_type = TestSpecTypes.NUM_RAND_SEEDS
                            resolved_test_spec.num_rand_seeds = regression_data['seeds']
                        elif type(regression_data['seeds']) is list:
                            resolved_test_spec.spec_type = TestSpecTypes.SEED_LIST
                            resolved_test_spec.specific_seeds = regression_data['seeds']
                        test_group = test_set.add_test_group("default")
                        test_group.add_test_spec(resolved_test_spec)
                    elif type(regression_data) is dict:
                        for test_group_name in regression_data:
                            test_group_spec = regression_data[test_group_name]
                            resolved_test_spec = ResolvedTestSpec()
                            resolved_test_spec.test_name = test_name
                            if 'args' in test_group_spec:
                                resolved_test_spec.args = test_group_spec['args']
                            if type(test_group_spec['seeds']) is int:
                                resolved_test_spec.spec_type = TestSpecTypes.NUM_RAND_SEEDS
                                resolved_test_spec.num_rand_seeds = test_group_spec['seeds']
                            elif type(test_group_spec['seeds']) is list:
                                resolved_test_spec.spec_type = TestSpecTypes.SEED_LIST
                                resolved_test_spec.specific_seeds = test_group_spec['seeds']
                            test_group = test_set.add_test_group(test_group_name)
                            test_group.add_test_spec(resolved_test_spec)
                    elif type(regression_data) is list:
                        resolved_test_spec = ResolvedTestSpec()
                        resolved_test_spec.test_name = test_name
                        resolved_test_spec.spec_type = TestSpecTypes.SEED_LIST
                        resolved_test_spec.specific_seeds = regression_data
                        test_group = test_set.add_test_group("default")
                        test_group.add_test_spec(resolved_test_spec)
        # Ensure regression names in settings exist and apply settings to regressions
        for regression_name in self.ts.cov:
            if regression_name not in self._resolved_regressions:
                self.db.rmh.warning(f"Regression '{regression_name}' does not exist and its coverage setting is ignored")
            else:
                self._resolved_regressions[regression_name].cov_enabled = True
        for regression_name in self.ts.waves:
            if regression_name not in self._resolved_regressions:
                self.db.rmh.warning(f"Regression '{regression_name}' does not exist and its wave capture setting is ignored")
            else:
                self._resolved_regressions[regression_name].waves_enabled = True
        for regression_name in self.ts.max_duration:
            if regression_name not in self._resolved_regressions:
                self.db.rmh.warning(f"Regression '{regression_name}' does not exist and its max duration setting is ignored")
            else:
                self._resolved_regressions[regression_name].max_duration = self.ts.max_duration[regression_name]
        for regression_name in self.ts.max_errors:
            if regression_name not in self._resolved_regressions:
                self.db.rmh.warning(f"Regression '{regression_name}' does not exist and its max errors setting is ignored")
            else:
                self._resolved_regressions[regression_name].max_errors = self.ts.max_errors[regression_name]
        for regression_name in self.ts.max_jobs:
            if regression_name not in self._resolved_regressions:
                self.db.rmh.warning(f"Regression '{regression_name}' does not exist and its max jobs setting is ignored")
            else:
                self._resolved_regressions[regression_name].max_jobs = self.ts.max_jobs[regression_name]
        for regression_name in self.ts.verbosity:
            if regression_name not in self._resolved_regressions:
                self.db.rmh.warning(f"Regression '{regression_name}' does not exist and its verbosity setting is ignored")
            else:
                self._resolved_regressions[regression_name].verbosity = self.ts.verbosity[regression_name]


class RegressionConfiguration:
    def __init__(self):
        self.target: str = ""
        self.dry_mode: bool = False
        self.app: LogicSimulators = LogicSimulators.UNDEFINED
        self.compilation_config: LogicSimulatorCompilationConfiguration = None
        self.elaboration_config: LogicSimulatorElaborationConfiguration = None
        self.compilation_and_elaboration_config: LogicSimulatorCompilationAndElaborationConfiguration = None
        self.simulation_configs: Dict[int, LogicSimulatorSimulationConfiguration] = {}

class RegressionSimulationReport:
    def __init__(self):
        self.test_spec: ResolvedTestSpec
        self.sim_report: LogicSimulatorSimulationReport

class RegressionReport(Model):
    regression: Optional[Regression] = None
    success: Optional[bool] = False
    compilation_report: Optional[LogicSimulatorCompilationReport] = None
    elaboration_report: Optional[LogicSimulatorElaborationReport] = None
    compilation_and_elaboration_report: Optional[LogicSimulatorCompilationAndElaborationReport] = None
    simulation_reports: Optional[List[RegressionSimulationReport]] = []
    all_passing_tests: Optional[List[RegressionSimulationReport]] = []
    passing_tests_with_no_warnings: Optional[List[RegressionSimulationReport]] = []
    passing_tests_with_warnings: Optional[List[RegressionSimulationReport]] = []
    failing_tests: Optional[List[RegressionSimulationReport]] = []
    dsim_cloud_simulation_job_file_path: Path = Path()
    has_coverage: bool = False

    def __init__(self, **data):
        super().__init__(**data)
        self._xml_report_file_name: Path = Path()
        self._html_report_file_name: Path = Path()
        self._coverage_report_file_name: Path = Path()

    @property
    def xml_report_file_name(self) -> Path:
        return self._xml_report_file_name
    @property
    def html_report_file_name(self) -> Path:
        return self._html_report_file_name
    @property
    def coverage_report_file_name(self) -> Path:
        return self._coverage_report_file_name

    def generate_xml_report(self):
        pass

    def generate_html_report(self):
        pass


class RegressionRunner:
    def __init__(self, db: 'RegressionDatabase', ip: Ip, regression: Regression, simulator: LogicSimulator, config: RegressionConfiguration):
        self.db: 'RegressionDatabase' = db
        self.rmh: 'RootManager' = self.db.rmh
        self.config: RegressionConfiguration = config
        self.report: RegressionReport = RegressionReport()
        self.phase: Phase = None
        self.ip: Ip = ip
        self.regression: Regression = regression
        self.simulator: LogicSimulator = simulator
        self.scheduler: JobScheduler = None
    
    def __str__(self):
        return f"{self.ip.lib_name}_{self.regression.name}"
        
    def execute_regression(self, scheduler: JobScheduler) -> RegressionReport:
        self.scheduler = scheduler
        self.config.simulation_configs = self.regression.render_sim_configs(self.config.target)
        self.rmh.create_directory(self.regression.results_path)
        if self.config.app == LogicSimulators.DSIM:
            self.dsim_cloud_simulation()
        else:
            self.parallel_simulation()
        self.regression.timestamp_end = datetime.datetime.now()
        self.regression.duration = self.regression.timestamp_end - self.regression.timestamp_start
        if self.config.dry_mode:
            self.report.success = True
            if self.ip.has_vhdl_content:
                self.report.compilation_report.success = True
                self.report.elaboration_report.success = True
            else:
                self.report.compilation_and_elaboration_report.success = True
        else:
            for simulation_report in self.report.simulation_reports:
                if simulation_report.sim_report.success:
                    self.report.all_passing_tests.append(simulation_report)
                    if simulation_report.sim_report.num_warnings == 0:
                        self.report.passing_tests_with_no_warnings.append(simulation_report)
                    else:
                        self.report.passing_tests_with_warnings.append(simulation_report)
                else:
                    self.report.failing_tests.append(simulation_report)
        return self.report
    
    def parallel_simulation(self):
        if not self.config.dry_mode:
            timeout = self.regression.max_duration * 3600
            with ThreadPoolExecutor(max_workers=self.regression.max_jobs) as executor:
                future_simulations = [executor.submit(self.launch_simulation, self.config.simulation_configs[seed]) for seed in
                                      self.config.simulation_configs]
                with tqdm(total=len(self.config.simulation_configs), desc="Simulations") as pbar:
                    for future in as_completed(future_simulations):
                        try:
                            result = future.result(timeout=timeout)
                        except Exception as e:
                            self.rmh.current_phase.error = e
                        finally:
                            pbar.update(1)
            self.report.success = True
            for simulation_report in self.report.simulation_reports:
                self.report.success &= simulation_report.success
    
    def launch_simulation(self, config: LogicSimulatorSimulationConfiguration):
        sim_report: LogicSimulatorSimulationReport = self.simulator.simulate(self.ip, config, self.scheduler)
        test_spec: ResolvedTestSpec = self.regression.test_specs[config.seed]
        regression_sim_report: RegressionSimulationReport = RegressionSimulationReport()
        regression_sim_report.test_spec = test_spec
        regression_sim_report.sim_report = sim_report
        self.report.simulation_reports.append(regression_sim_report)
    
    def dsim_cloud_simulation(self):
        # 1. Prep simulator
        if self.simulator.name != "dsim":
            raise TypeError(
                f"The simulator must be an instance of SimulatorMetricsDSim, got {type(self.simulator).__name__}")
        if not self.rmh.configuration.project.local_mode:
            raise Exception(f"DSim Cloud requires Project to be configured in 'local_mode'")
        simulator: SimulatorMetricsDSim = self.simulator
        simulator.cloud_mode = True
        # 2. Amass configuration objects for compilation/elaboration
        if self.ip.has_vhdl_content:
            self.config.compilation_config = self.regression.render_cmp_config(self.config.target)
            self.config.compilation_config.use_relative_paths = True
            self.config.elaboration_config = self.regression.render_elab_config(self.config.target)
            self.config.elaboration_config.use_relative_paths = True
        else:
            self.config.compilation_and_elaboration_config = self.regression.render_cmp_elab_config(self.config.target)
            self.config.compilation_and_elaboration_config.use_relative_paths = True
        # 3. Create DSim Cloud Configuration object and fill it in from our regression configuration
        cloud_simulation_config: DSimCloudSimulationConfiguration = DSimCloudSimulationConfiguration()
        cloud_simulation_config.name = f"{self.ip.ip.name}-{self.regression.name}"
        cloud_simulation_config.results_path = self.regression.results_path
        cloud_simulation_config.dry_mode = self.config.dry_mode
        cloud_simulation_config.timeout = self.regression.max_duration
        cloud_simulation_config.max_parallel_tasks = self.regression.max_jobs
        cloud_simulation_config.compute_size = self.db.rmh.configuration.logic_simulation.metrics_dsim_cloud_max_compute_size
        cloud_simulation_config.compilation_config = self.config.compilation_config
        cloud_simulation_config.elaboration_config = self.config.elaboration_config
        cloud_simulation_config.compilation_and_elaboration_config = self.config.compilation_and_elaboration_config
        for seed in self.config.simulation_configs:
            simulation_config = self.config.simulation_configs[seed]
            cloud_simulation_config.simulation_configs.append(simulation_config)
        # 4. Launch job on the cloud via simulator
        cloud_simulation_report = simulator.dsim_cloud_simulate(self.ip, cloud_simulation_config, self.scheduler)
        # 5. Populate regression report from DSim Cloud Report
        self.report.success = cloud_simulation_report.success
        self.report.dsim_cloud_simulation_job_file_path = cloud_simulation_report.cloud_job_file_path
        self.report.compilation_report = cloud_simulation_report.compilation_report
        self.report.elaboration_report = cloud_simulation_report.elaboration_report
        self.report.compilation_and_elaboration_report = cloud_simulation_report.compilation_and_elaboration_report
        for simulation_report in cloud_simulation_report.simulation_reports:
            test_spec: ResolvedTestSpec = self.regression.test_specs[simulation_report.seed]
            regression_sim_report: RegressionSimulationReport = RegressionSimulationReport()
            regression_sim_report.test_spec = test_spec
            regression_sim_report.sim_report = simulation_report
            self.report.simulation_reports.append(regression_sim_report)


class RegressionDatabase(Service):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, 'datum', 'regression_database', 'Regression Database')
        self._type = ServiceType.REGRESSION
        self._test_suites: List[TestSuite] = []

    def is_available(self) -> bool:
        return True

    def create_directory_structure(self):
        pass

    def create_files(self):
        pass

    def get_version(self) -> Version:
        return Version('1.0.0')
    
    def discover_test_suites(self, path: Path):
        path = Path(path)  # Ensure `path` is a Path object
        ts_files = path.rglob('*ts.yml')
        for ts_file in ts_files:
            try:
                test_suite = TestSuite.load(self, ts_file)
                self.add_test_suite(test_suite)
            except Exception as e:
                self.rmh.warning(f"Failed to process {ts_file}: {e}")
    
    def add_test_suite(self, test_suite: TestSuite):
        try:
            test_suite.check()
        except Exception as e:
            self.rmh.warning(f"Test Suite {test_suite} failed consistency check: {e}")
        else:
            self.rmh.debug(f"Added test suite '{test_suite}'")
            self._test_suites.append(test_suite)
    
    def find_regression(self, test_suite_name: str, regression_name: str, raise_exception_if_not_found: bool=False):
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

    def find_regression_default_test_suite(self, regression_name: str, raise_exception_if_not_found: bool=False):
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
    
    def get_regression_runner(self, ip: Ip, regression: Regression, simulator: LogicSimulator, config: RegressionConfiguration) -> RegressionRunner:
        regression_runner: RegressionRunner = RegressionRunner(self, ip, regression, simulator, config)
        return regression_runner
    
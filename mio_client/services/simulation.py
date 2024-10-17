# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from enum import Enum
from pathlib import Path
from random import random, randint
from typing import List, Optional, Dict, Union

from jinja2 import Template
from semantic_version import Version

from mio_client.core.scheduler import JobScheduler, Job, JobSchedulerConfiguration
from mio_client.core.service import Service, ServiceType
from mio_client.core.ip import Ip
from abc import ABC, abstractmethod

from mio_client.core.model import Model, UNDEFINED_CONST


#######################################################################################################################
# API Entry Point
#######################################################################################################################
def get_services():
    return [SimulatorMetricsDSim]


#######################################################################################################################
# Support Types
#######################################################################################################################
class LogicSimulators(Enum):
    DSIM = "Metrics DSim"
    VIVADO = "Xilinx Vivado"
    VCS = "Synopsys VCS"
    XCELIUM = "Cadence XCelium"
    QUESTA = "Siemens QuestaSim"
    RIVIERA_PRO = "Aldec Riviera-PRO"

class UvmVerbosity(Enum):
    NONE = "none"
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    DEBUG = "debug"



#######################################################################################################################
# Models
#######################################################################################################################
class LogicSimulatorReport(Model, ABC):
    name: str
    success: Optional[bool] = False
    num_errors: Optional[int] = 0
    num_warnings: Optional[int] = 0
    num_fatals: Optional[int] = 0
    errors: Optional[List[int]] = []
    warnings: Optional[List[int]] = []
    fatals: Optional[List[int]] = []
    work_directory: Optional[Path] = Path()
    scheduler_config: Optional[JobSchedulerConfiguration] = None

class LogicSimulatorLibraryCreationReport(LogicSimulatorReport):
    pass

class LogicSimulatorLibraryDeletionReport(LogicSimulatorReport):
    pass

class LogicSimulatorCompilationReport(LogicSimulatorReport):
    ordered_dependencies: Optional[list[Ip]] = []
    has_sv_files_to_compile: Optional[bool] = False
    has_vhdl_files_to_compile: Optional[bool] = False
    sv_compilation_success: Optional[bool] = False
    vhdl_compilation_success: Optional[bool] = False
    sv_file_list_path: Optional[Path] = Path()
    vhdl_file_list_path: Optional[Path] = Path()
    sv_log_path: Optional[Path] = Path()
    vhdl_log_path: Optional[Path] = Path()
    defines_boolean: Optional[list[str]] = []
    defines_value: Optional[dict[str, str]] = {}

class LogicSimulatorElaborationReport(LogicSimulatorReport):
    log_path: Optional[Path] = Path()
    elaboration_success: Optional[bool] = False

class LogicSimulatorCompilationAndElaborationReport(LogicSimulatorReport):
    ordered_dependencies: Optional[list[Ip]] = []
    has_files_to_compile: Optional[bool] = False
    file_list_path: Optional[Path] = Path()
    log_path: Optional[Path] = Path()
    compilation_and_elaboration_success: Optional[bool] = False
    defines_boolean: Optional[list[str]] = []
    defines_value: Optional[dict[str, str]] = {}

class LogicSimulatorSimulationReport(LogicSimulatorReport):
    test_name: Optional[str] = UNDEFINED_CONST
    seed: Optional[int] = -1
    verbosity: Optional[UvmVerbosity] = UvmVerbosity.DEBUG
    coverage: Optional[bool] = False
    waveform_capture: Optional[bool] = False
    waveform_file_path: Optional[Path] = Path()
    args_boolean:Optional[list[str]] = []
    args_value:Optional[dict[str, str] ]= {}
    test_results_path: Optional[Path] = Path()
    log_path: Optional[Path] = Path()
    coverage_directory: Optional[Path] = Path()
    simulation_success: Optional[bool] = False
    

class LogicSimulatorEncryptionReport(LogicSimulatorReport):
    mlicense_key: Optional[str] = UNDEFINED_CONST
    path_to_encrypted_files: Optional[Path] = Path()
    sv_encryption_success: Optional[bool] = False
    vhdl_encryption_success: Optional[bool] = False
    has_sv_files_to_encrypt: Optional[bool] = False
    has_vhdl_files_to_encrypt: Optional[bool] = False
    sv_files_to_encrypt: Optional[list[Path]] = []
    vhdl_files_to_encrypt: Optional[list[Path]] = []


class LogicSimulatorConfiguration(ABC):
    pass

class LogicSimulatorLibraryCreationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorLibraryDeletionConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorCompilationConfiguration(LogicSimulatorConfiguration):
    enable_coverage: bool = False
    enable_waveform_capture: bool = False
    max_errors: int = 10
    defines_boolean:list[str] = []
    defines_value:dict[str, str] = {}

class LogicSimulatorElaborationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorCompilationAndElaborationConfiguration(LogicSimulatorCompilationConfiguration):
    pass

class LogicSimulatorSimulationConfiguration(LogicSimulatorConfiguration):
    enable_coverage: bool = False
    enable_waveform_capture: bool = False
    gui_mode: bool = False
    max_errors: int = 10
    args_boolean:list[str] = []
    args_value:dict[str, str] = {}
    test_name: str = "__UNDEFINED__"
    seed: int = randint(1, ((1 << 31)-1))
    verbosity: UvmVerbosity = UvmVerbosity.DEBUG

class LogicSimulatorEncryptionConfiguration(LogicSimulatorConfiguration):
    add_license_key_checks: bool = False
    mlicense_key: str = UNDEFINED_CONST
    mlicense_customer: int = -1


class LogicSimulatorFileList(Model):
    name:str
    defines_boolean: Optional[list[str]] = []
    defines_values: Optional[dict[str, str]] = {}
    directories: Optional[list[Path]] = []
    files: Optional[list[Path]] = []

class LogicSimulatorMasterFileList(LogicSimulatorFileList):
    sub_file_lists: Optional[List[LogicSimulatorFileList]] = []




#######################################################################################################################
# Logic Simulator Abstract Base Class
#######################################################################################################################
class LogicSimulator(Service, ABC):
    def __init__(self, rmh: 'RootManager', vendor_name: str, name: str, full_name: str,):
        super().__init__(rmh, vendor_name, name, full_name)
        self._type = ServiceType.LOGIC_SIMULATION
        self._work_root_path = self.rmh.md / "logic_simulation"
        self._work_path = self.work_root_path / self.name
        self._work_temp_path = self.work_path / "temp"
        self._simulation_root_path = self.rmh.wd / self.rmh.configuration.logic_simulation.root_path
        self._simulation_results_path = self.simulation_root_path / self.rmh.configuration.logic_simulation.results_directory_name
        self._regression_root_path = self.simulation_root_path / self.rmh.configuration.logic_simulation.regression_directory_name
        self._simulation_logs_path = self.simulation_root_path / self.rmh.configuration.logic_simulation.logs_directory

    @property
    @abstractmethod
    def installation_path(self) -> Path:
        pass

    def is_available(self) -> bool:
        return self.rmh.directory_exists(self.installation_path)

    @property
    def work_root_path(self) -> Path:
        return self._work_root_path

    @property
    def work_path(self) -> Path:
        return self._work_path

    @property
    def work_temp_path(self) -> Path:
        return self._work_temp_path

    @property
    def simulation_root_path(self) -> Path:
        return self._simulation_root_path

    @property
    def simulation_results_path(self) -> Path:
        return self._simulation_results_path

    @property
    def regression_root_path(self) -> Path:
        return self._regression_root_path

    @property
    def simulation_logs_path(self) -> Path:
        return self._simulation_logs_path

    def create_directory_structure(self):
        self.rmh.create_directory(self.work_root_path)
        self.rmh.create_directory(self.work_path)
        self.rmh.create_directory(self.work_temp_path)
        self.rmh.create_directory(self.simulation_root_path)
        self.rmh.create_directory(self.simulation_results_path)
        self.rmh.create_directory(self.regression_root_path)
        self.rmh.create_directory(self.simulation_logs_path)

    def create_files(self):
        pass

    def create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, scheduler: JobScheduler) -> LogicSimulatorLibraryCreationReport:
        report = LogicSimulatorLibraryCreationReport()
        scheduler_config = JobSchedulerConfiguration(self.rmh)
        scheduler_config.output_to_terminal = False
        self.do_create_library(ip, config, report, scheduler, scheduler_config)
        self.parse_library_creation_logs(ip, config, report)
        report.scheduler_config = scheduler_config
        return report

    def delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration, scheduler: JobScheduler) -> LogicSimulatorLibraryDeletionReport:
        report = LogicSimulatorLibraryDeletionReport()
        scheduler_config = JobSchedulerConfiguration(self.rmh)
        scheduler_config.output_to_terminal = False
        self.do_delete_library(ip, config, report, scheduler, scheduler_config)
        report.scheduler_config = scheduler_config
        return report

    def compile(self, ip: Ip, config: LogicSimulatorCompilationConfiguration, scheduler: JobScheduler) -> LogicSimulatorCompilationReport:
        report = LogicSimulatorCompilationReport(name=f"Compilation for '{ip}' using '{self.full_name}'")
        scheduler_config = JobSchedulerConfiguration(self.rmh)
        scheduler_config.output_to_terminal = False
        report.ordered_dependencies = ip.get_dependencies_in_order()
        self.build_sv_flist(ip, config, report)
        self.build_vhdl_flist(ip, config, report)
        if (not report.has_sv_files_to_compile) and (not report.has_vhdl_files_to_compile):
            raise Exception(f"No files to compile for IP '{ip}'")
        # TODO Add defines values from IP target
        report.defines_boolean = config.defines_boolean
        report.defines_value = config.defines_value
        report.work_directory = self.work_path / f"{ip.work_directory_name}"
        report.sv_log_path = self.simulation_logs_path / f"{ip.result_file_name}.cmp.sv.{self.name}.log"
        report.vhdl_log_path = self.simulation_logs_path / f"{ip.result_file_name}.cmp.vhdl.{self.name}.log"
        self.rmh.create_directory(report.work_directory)
        self.do_compile(ip, config, report, scheduler, scheduler_config)
        report.success = (report.sv_compilation_success and report.vhdl_compilation_success)
        self.parse_compilation_logs(ip, config, report)
        report.scheduler_config = scheduler_config
        return report

    def elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, scheduler: JobScheduler) -> LogicSimulatorElaborationReport:
        report = LogicSimulatorElaborationReport(name=f"Elaboration for '{ip}' using '{self.full_name}'")
        scheduler_config = JobSchedulerConfiguration(self.rmh)
        scheduler_config.output_to_terminal = False
        report.work_directory = self.work_path / f"{ip.work_directory_name}"
        report.log_path = self.simulation_logs_path / f"{ip.result_file_name}.elab.{self.name}.log"
        self.do_elaborate(ip, config, report, scheduler, scheduler_config)
        report.success = report.elaboration_success
        self.parse_elaboration_logs(ip, config, report)
        report.scheduler_config = scheduler_config
        return report

    def compile_and_elaborate(self, ip: Ip, config: LogicSimulatorCompilationAndElaborationConfiguration, scheduler: JobScheduler) -> LogicSimulatorCompilationAndElaborationReport:
        report = LogicSimulatorCompilationAndElaborationReport(name=f"Compilation+Elaboration for '{ip}' using '{self.full_name}'")
        scheduler_config = JobSchedulerConfiguration(self.rmh)
        scheduler_config.output_to_terminal = False
        report.ordered_dependencies = ip.get_dependencies_in_order()
        self.build_sv_flist(ip, config, report)
        if not report.has_files_to_compile:
            raise Exception(f"No files to compile for IP '{ip}'")
        # TODO Add defines values from IP target
        report.defines_boolean = config.defines_boolean
        report.defines_value = config.defines_value
        report.work_directory = self.work_path / f"{ip.work_directory_name}"
        report.log_path = self.simulation_logs_path / f"{ip.result_file_name}.cmpelab.{self.name}.log"
        self.rmh.create_directory(report.work_directory)
        self.do_compile_and_elaborate(ip, config, report, scheduler, scheduler_config)
        report.success = report.compilation_and_elaboration_success
        self.parse_compilation_and_elaboration_logs(ip, config, report)
        report.scheduler_config = scheduler_config
        return report

    def simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, scheduler: JobScheduler) -> LogicSimulatorSimulationReport:
        report = LogicSimulatorSimulationReport(name=f"Simulation for '{ip}' using '{self.full_name}'")
        scheduler_config = JobSchedulerConfiguration(self.rmh)
        scheduler_config.output_to_terminal = True
        report.work_directory = self.work_path / f"{ip.work_directory_name}"
        test_template = Template(ip.hdl_src.tests_name_template)
        test_result_dir_template = Template(self.rmh.configuration.logic_simulation.test_result_path_template)
        # TODO Add arg values from IP target
        final_args_boolean = config.args_boolean
        final_args_value = config.args_value
        final_args = []
        for arg in final_args_boolean:
            final_args.append(arg)
        for arg in final_args_value:
            final_args.append(f"{arg}={final_args_value[arg]}")
        # TODO Load Shared Objects
        # TODO Load Moore.io Licensing DPI Shared Object for DSim
        report.test_name = test_template.render(name=config.test_name)
        test_result_directory_name = test_result_dir_template.render(vendor=ip.ip.vendor, ip=ip.ip.name, test=config.test_name,
                                                                     seed=config.seed, args=final_args)
        final_args_boolean.append("UVM_NO_RELNOTES")
        final_args_value["UVM_TESTNAME"] = report.test_name
        final_args_value["UVM_VERBOSITY"] = f"UVM_{config.verbosity.value.upper()}"
        final_args_value["UVM_MAX_QUIT_COUNT"] = str(config.max_errors)
        report.test_results_path = self.simulation_results_path / test_result_directory_name
        final_args_value["__MIO_TEST_RESULTS_PATH"] = str(report.test_results_path)
        final_args_value["__MIO_SIM_RESULTS_PATH"] = str(self.simulation_results_path)
        if self.rmh.user.authenticated:
            final_args_value["__MIO_USER_TOKEN"] = self.rmh.user.access_token
        report.log_path = report.test_results_path / f"sim.{self.name}.log"
        report.waveform_file_path = report.test_results_path / f"waves.{self.name}"
        report.coverage_directory = report.test_results_path / f"cov.{self.name}"
        report.args_boolean = final_args_boolean
        report.args_value = final_args_value
        self.rmh.create_directory(report.test_results_path)
        if config.enable_coverage:
            self.rmh.create_directory(report.coverage_directory)
        self.do_simulate(ip, config, report, scheduler, scheduler_config)
        report.success = report.simulation_success
        report.waveform_capture = config.enable_waveform_capture
        report.coverage = config.enable_coverage
        report.seed = config.seed
        report.verbosity = config.verbosity
        self.parse_simulation_logs(ip, config, report)
        report.scheduler_config = scheduler_config
        return report

    def encrypt(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, scheduler: JobScheduler) -> LogicSimulatorEncryptionReport:
        report = LogicSimulatorEncryptionReport(name=f"Encryption for '{ip}' using '{self.full_name}'")
        report.path_to_encrypted_files = self.work_temp_path / f'encrypt_{ip.lib_name}'
        self.rmh.copy_directory(ip.resolved_src_path, report.path_to_encrypted_files)
        # Find all SystemVerilog files within `ip.resolved_src_path` (recursively)
        sv_file_extensions = ["v", "vh", "sv", "svh"]
        for ext in sv_file_extensions:
            report.sv_files_to_encrypt += list(report.path_to_encrypted_files.rglob(f"*.{ext}"))
        report.has_sv_files_to_encrypt = len(report.sv_files_to_encrypt) > 0
        # Find all VHDL files within `ip.resolved_src_path` (recursively)
        vhdl_file_extensions = ["vhd", "vhdl"]
        for ext in vhdl_file_extensions:
            report.vhdl_files_to_encrypt += list(report.path_to_encrypted_files.rglob(f"*.{ext}"))
        report.has_vhdl_files_to_encrypt = len(report.vhdl_files_to_encrypt) > 0
        if (not report.has_sv_files_to_encrypt) and (not report.has_vhdl_files_to_encrypt):
            raise Exception(f"No SystemVerilog or VHDL files found to encrypt for IP '{ip}'")
        for file_path in report.sv_files_to_encrypt:
            with file_path.open("r") as file:
                file_content = file.read()
                file_content = f"`pragma protect begin\n{file_content}\n`pragma protect end\n"
                with file_path.open("w") as file:
                    file.write(file_content)
        for file_path in report.vhdl_files_to_encrypt:
            with file_path.open("r") as file:
                file_content = file.read()
                file_content = f"`protect begin\n{file_content}\n`protect end\n"
                with file_path.open("w") as file:
                    file.write(file_content)
        if ip.ip.mlicensed and config.add_license_key_checks:
            found_key_check = False
            # Search and replace in all SystemVerilog
            search_string = "`__MIO_LICENSE_KEY_CHECK_PHONY__"
            replace_string = f'`__MIO_LICENSE_KEY_CHECK__("{config.mlicense_key}", "{config.mlicense_customer}")'
            for file_path in report.sv_files_to_encrypt:
                with file_path.open("r") as file:
                    file_content = file.read()
                if search_string in file_content:
                    file_content = file_content.replace(search_string, replace_string)
                    with file_path.open("w") as file:
                        file.write(file_content)
                    found_key_check = True
            # Search and replace in all VHDL files
            search_string = "-- __MIO_LICENSE_KEY_CHECK_PHONY__"
            replace_string = f'__MIO_LICENSE_KEY_CHECK__("{config.mlicense_key}", "{config.mlicense_customer}");'  # TODO This is just theory
            for file_path in report.vhdl_files_to_encrypt:
                with file_path.open("r") as file:
                    file_content = file.read()
                if search_string in file_content:
                    file_content = file_content.replace(search_string, replace_string)
                    with file_path.open("w") as file:
                        file.write(file_content)
                    found_key_check = True
            if not found_key_check:
                raise Exception(f"Did not find Moore.io License Key Check insertion points in HDL source code")
        scheduler_config = JobSchedulerConfiguration(self.rmh)
        scheduler_config.output_to_terminal = False
        self.do_encrypt(ip, config, report, scheduler, scheduler_config)
        self.parse_encryption_logs(ip, config, report)
        report.scheduler_config = scheduler_config
        return report

    def parse_library_creation_logs(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, report: LogicSimulatorLibraryCreationReport) -> None:
        report.name = f"Library creation for '{ip}' using '{self.full_name}'"
        #for log_path in log_paths:
        #    report.errors   += self.rmh.search_file_for_patterns(log_path, self.library_creation_error_patterns)
        #    report.warnings += self.rmh.search_file_for_patterns(log_path, self.library_creation_warning_patterns)
        #    report.fatals   += self.rmh.search_file_for_patterns(log_path, self.library_creation_fatal_patterns)
        #report.num_errors = len(report.errors)
        #report.num_warnings = len(report.warnings)
        #report.num_fatals = len(report.fatals)
        #report.success = (len(report.errors) == 0) and (len(report.fatals) == 0)

    def parse_compilation_logs(self, ip: Ip, config: LogicSimulatorCompilationConfiguration, report: LogicSimulatorCompilationReport) -> None:
        if report.has_sv_files_to_compile:
            report.errors   += self.rmh.search_file_for_patterns(report.sv_log_path, self.compilation_error_patterns)
            report.warnings += self.rmh.search_file_for_patterns(report.sv_log_path, self.compilation_warning_patterns)
            report.fatals   += self.rmh.search_file_for_patterns(report.sv_log_path, self.compilation_fatal_patterns)
        if report.has_vhdl_files_to_compile:
            report.errors   += self.rmh.search_file_for_patterns(report.vhdl_log_path, self.compilation_error_patterns)
            report.warnings += self.rmh.search_file_for_patterns(report.vhdl_log_path, self.compilation_warning_patterns)
            report.fatals   += self.rmh.search_file_for_patterns(report.vhdl_log_path, self.compilation_fatal_patterns)
        report.num_errors = len(report.errors)
        report.num_warnings = len(report.warnings)
        report.num_fatals = len(report.fatals)
        report.success &= (report.num_errors == 0) and (report.num_fatals == 0)

    def parse_elaboration_logs(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, report: LogicSimulatorElaborationReport) -> None:
        report.errors   += self.rmh.search_file_for_patterns(report.log_path, self.elaboration_error_patterns)
        report.warnings += self.rmh.search_file_for_patterns(report.log_path, self.elaboration_warning_patterns)
        report.fatals   += self.rmh.search_file_for_patterns(report.log_path, self.elaboration_fatal_patterns)
        report.num_errors = len(report.errors)
        report.num_warnings = len(report.warnings)
        report.num_fatals = len(report.fatals)
        report.success &= (report.num_errors == 0) and (report.num_fatals == 0)

    def parse_compilation_and_elaboration_logs(self, ip: Ip, config: LogicSimulatorCompilationAndElaborationConfiguration, report: LogicSimulatorCompilationAndElaborationReport) -> None:
        report.errors   += self.rmh.search_file_for_patterns(report.log_path, self.compilation_and_elaboration_error_patterns)
        report.warnings += self.rmh.search_file_for_patterns(report.log_path, self.compilation_and_elaboration_warning_patterns)
        report.fatals   += self.rmh.search_file_for_patterns(report.log_path, self.compilation_and_elaboration_fatal_patterns)
        report.num_errors = len(report.errors)
        report.num_warnings = len(report.warnings)
        report.num_fatals = len(report.fatals)
        report.success &= (report.num_errors == 0) and (report.num_fatals == 0)

    def parse_simulation_logs(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, report: LogicSimulatorSimulationReport) -> None:
        report.errors   += self.rmh.search_file_for_patterns(report.log_path, self.simulation_error_patterns)
        report.warnings += self.rmh.search_file_for_patterns(report.log_path, self.simulation_warning_patterns)
        report.fatals   += self.rmh.search_file_for_patterns(report.log_path, self.simulation_fatal_patterns)
        report.num_errors = len(report.errors)
        report.num_warnings = len(report.warnings)
        report.num_fatals = len(report.fatals)
        report.success &= (report.num_errors == 0) and (report.num_fatals == 0)

    def parse_encryption_logs(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, report: LogicSimulatorEncryptionReport) -> None:
        if report.sv_encryption_success and report.vhdl_encryption_success:
            report.success = True
        else:
            report.success = False

    def build_sv_flist(self, ip:Ip,
                       config:Union[LogicSimulatorCompilationConfiguration, LogicSimulatorCompilationAndElaborationConfiguration],
                       report:Union[LogicSimulatorCompilationReport, LogicSimulatorCompilationAndElaborationReport]):
        has_files_to_compile:bool = False
        file_list = LogicSimulatorMasterFileList(name=ip.as_ip_definition)
        for dep in report.ordered_dependencies:
            sub_file_list = LogicSimulatorFileList(name=dep.as_ip_definition)
            if dep.ip.mlicensed:
                if self.name not in dep.resolved_encrypted_hdl_directories:
                    raise Exception(f"IP '{dep}' is licensed but has no encrypted HDL content defined for '{self.name}'")
                else:
                    directories = dep.resolved_encrypted_hdl_directories[self.name]
                    files = dep.resolved_encrypted_top_sv_files[self.name]
            else:
                directories = dep.resolved_hdl_directories
                files = dep.resolved_top_sv_files
            for directory in directories:
                sub_file_list.directories.append(directory)
            for file in files:
                sub_file_list.files.append(file)
                has_files_to_compile = True
            # TODO Add defines from targets
            file_list.sub_file_lists.append(sub_file_list)
        if isinstance(config, LogicSimulatorCompilationConfiguration):
            file_list.defines_boolean += config.defines_boolean
            file_list.defines_values.update(config.defines_value)
        else:
            file_list.defines_boolean += config.defines_boolean
            file_list.defines_values.update(config.defines_value)
        if ip.ip.mlicensed:
            if self.name not in ip.resolved_encrypted_hdl_directories:
                raise Exception(f"IP '{ip}' is licensed but has no encrypted HDL content defined for '{self.name}'")
            else:
                directories = ip.resolved_encrypted_hdl_directories[self.name]
                files = ip.resolved_encrypted_top_sv_files[self.name]
        else:
            directories = ip.resolved_hdl_directories
            files = ip.resolved_top_sv_files
        for directory in directories:
            file_list.directories.append(directory)
        for file in files:
            file_list.files.append(file)
            has_files_to_compile = True
        if isinstance(report, LogicSimulatorCompilationReport):
            report.has_sv_files_to_compile = has_files_to_compile
        else:
            report.has_files_to_compile = has_files_to_compile
        if has_files_to_compile:
            # Load the Jinja2 templates from disk
            template = self.rmh.j2_env.get_template(f"flist.sv.{self.name}.j2")
            # Render the templates with the master file lists
            filelist_rendered = template.render(data=file_list)
            # Save the rendered templates to disk
            flist_path = self.work_temp_path / f"{ip.result_file_name}.sv.{self.name}.flist"
            with open(flist_path, "w") as flist:
                flist.write(filelist_rendered)
            if isinstance(report, LogicSimulatorCompilationReport):
                report.sv_file_list_path = flist_path
            else:
                report.file_list_path = flist_path

    def build_vhdl_flist(self, ip:Ip, config:LogicSimulatorCompilationConfiguration, report:LogicSimulatorCompilationReport):
        file_list = LogicSimulatorMasterFileList(name=ip.as_ip_definition)
        for dep in report.ordered_dependencies:
            sub_file_list = LogicSimulatorFileList(name=dep.as_ip_definition)
            if dep.ip.mlicensed:
                if self.name not in dep.resolved_encrypted_hdl_directories:
                    raise Exception(f"IP '{dep}' is licensed but has no encrypted HDL content defined for '{self.name}'")
                else:
                    directories = dep.resolved_encrypted_hdl_directories[self.name]
                    files = dep.resolved_encrypted_top_vhdl_files[self.name]
            else:
                directories = dep.resolved_hdl_directories
                files = dep.resolved_top_vhdl_files
            for directory in directories:
                sub_file_list.directories.append(directory)
            for file in files:
                sub_file_list.files.append(file)
                report.has_vhdl_files_to_compile = True
            # TODO Add defines from targets
            file_list.sub_file_lists.append(sub_file_list)
        file_list.defines_boolean += config.defines_boolean
        file_list.defines_values.update(config.defines_value)
        if ip.ip.mlicensed:
            if self.name not in ip.resolved_encrypted_hdl_directories:
                raise Exception(f"IP '{ip}' is licensed but has no encrypted HDL content defined for '{self.name}'")
            else:
                directories = ip.resolved_encrypted_hdl_directories[self.name]
                files = ip.resolved_encrypted_top_vhdl_files[self.name]
        else:
            directories = ip.resolved_hdl_directories
            files = ip.resolved_top_vhdl_files
        for directory in directories:
            file_list.directories.append(directory)
        for file in files:
            file_list.files.append(file)
            report.has_vhdl_files_to_compile = True
        if report.has_vhdl_files_to_compile:
            # Load the Jinja2 templates from disk
            template = self.rmh.j2_env.get_template(f"flist.vhdl.{self.name}.j2")
            # Render the templates with the master file lists
            filelist_rendered = template.render(data=file_list)
            # Save the rendered templates to disk
            flist_path = self.work_temp_path / f"{ip.result_file_name}.{self.name}.vhdl.flist"
            with open(flist_path, "w") as flist:
                flist.write(filelist_rendered)
            report.vhdl_file_list_path = flist_path
    
    @property
    @abstractmethod
    def library_creation_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def library_creation_warning_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def library_creation_fatal_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def compilation_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def compilation_warning_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def compilation_fatal_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def elaboration_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def elaboration_warning_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def elaboration_fatal_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def compilation_and_elaboration_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def compilation_and_elaboration_warning_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def compilation_and_elaboration_fatal_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def simulation_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def simulation_warning_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def simulation_fatal_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def encryption_error_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def encryption_warning_patterns(self) -> List[str]:
        pass

    @property
    @abstractmethod
    def encryption_fatal_patterns(self) -> List[str]:
        pass
    
    @abstractmethod
    def do_create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, report: LogicSimulatorLibraryCreationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    @abstractmethod
    def do_delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration, report: LogicSimulatorLibraryDeletionReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    @abstractmethod
    def do_compile(self, ip: Ip, config: LogicSimulatorCompilationConfiguration, report: LogicSimulatorCompilationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    @abstractmethod
    def do_elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, report: LogicSimulatorElaborationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    @abstractmethod
    def do_compile_and_elaborate(self, ip: Ip, config: LogicSimulatorCompilationAndElaborationConfiguration, report: LogicSimulatorCompilationAndElaborationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    @abstractmethod
    def do_simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, report: LogicSimulatorSimulationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    @abstractmethod
    def do_encrypt(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, report: LogicSimulatorEncryptionReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass




#######################################################################################################################
# Logic Simulator Implementation: Metrics Design Automation© DSim (TM)
#######################################################################################################################
class SimulatorMetricsDSim(LogicSimulator):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, "Metrics Design Automation", "dsim", "DSim")

    @property
    def installation_path(self) -> Path:
        return self.rmh.configuration.logic_simulation.metrics_dsim_installation_path

    @property
    def library_creation_error_patterns(self) -> List[str]:
        return [r'^.*=E:.*$']
    @property
    def library_creation_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$']
    @property
    def library_creation_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$']
    @property
    def compilation_error_patterns(self) -> List[str]:
        return [r'^.*=E:.*$']
    @property
    def compilation_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$']
    @property
    def compilation_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$']
    @property
    def elaboration_error_patterns(self) -> List[str]:
        return [r'^.*=E:.*$']
    @property
    def elaboration_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$']
    @property
    def elaboration_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$']
    @property
    def compilation_and_elaboration_error_patterns(self) -> List[str]:
        return [r'^.*=E:.*$']
    @property
    def compilation_and_elaboration_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$']
    @property
    def compilation_and_elaboration_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$']
    @property
    def simulation_error_patterns(self) -> List[str]:
        return [r'^.*=E:.*$', r'^UVM_ERROR @.*$']
    @property
    def simulation_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$', r'^UVM_WARNING @.*$']
    @property
    def simulation_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$', r'^UVM_FATAL @.*$']
    @property
    def encryption_error_patterns(self) -> List[str]:
        return [r'^.*=E:.*$']
    @property
    def encryption_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$']
    @property
    def encryption_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$']

    def get_version(self) -> Version:
        # TODO Get version string from dsim
        return Version('1.0.0')

    def set_job_env(self, job:Job):
        job.env_vars["DSIM_HOME"] = self.rmh.configuration.logic_simulation.metrics_dsim_installation_path
        job.env_vars["DSIM_LICENSE"] = self.rmh.configuration.logic_simulation.metrics_dsim_license_path
        job.env_vars["LLVM_HOME"] = "${DSIM_HOME}/llvm_small"
        job.env_vars["STD_LIBS"] = "$DSIM_HOME/std_pkgs/lib"
        job.env_vars["UVM_HOME"] = "${DSIM_HOME}/uvm/" + self.rmh.configuration.logic_simulation.uvm_version.value
        job.env_vars["DSIM_LD_LIBRARY_PATH"] = "${DSIM_HOME}/lib:${LD_LIBRARY_PATH}:${DSIM_HOME}/llvm_small/lib"
        job.env_vars["LD_LIBRARY_PATH"] = "${DSIM_LD_LIBRARY_PATH}"
        job.pre_path = "${DSIM_HOME}/bin:${DSIM_HOME}/" + self.rmh.configuration.logic_simulation.uvm_version.value + "/bin:${DSIM_HOME}/llvm_small/bin"

    def do_create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, report: LogicSimulatorLibraryCreationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    def do_delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration, report: LogicSimulatorLibraryDeletionReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        pass

    def do_compile(self, ip: Ip, config:LogicSimulatorCompilationConfiguration, report:LogicSimulatorCompilationReport, scheduler:JobScheduler, scheduler_config: JobSchedulerConfiguration):
        defines_str = ""
        for define in report.defines_boolean:
            defines_str += f" +define+{define}"
        for define in report.defines_value:
            defines_str += f" +define+{define}={report.defines_value[define]}"
        if report.has_sv_files_to_compile:
            args = self.rmh.configuration.logic_simulation.metrics_dsim_default_compilation_sv_arguments + [
                defines_str,
                f"-F {report.sv_file_list_path}",
                f"-uvm {self.rmh.configuration.logic_simulation.uvm_version.value}",
                f"-lib {ip.lib_name}",
                f"-l {report.sv_log_path}"
            ]
            job_cmp_sv = Job(self.rmh, report.work_directory, f"dsim_sv_compilation_{ip.lib_name}", os.path.join(self.installation_path, "bin", "dvlcom"), args)
            self.set_job_env(job_cmp_sv)
            results_cmp_sv = scheduler.dispatch_job(job_cmp_sv, scheduler_config)
            report.sv_compilation_success = (results_cmp_sv.return_code == 0)
        else:
            report.sv_compilation_success = True
        if report.has_vhdl_files_to_compile:
            args = self.rmh.configuration.logic_simulation.metrics_dsim_default_compilation_vhdl_arguments + [
                defines_str,
                f"-F {report.vhdl_file_list_path}",
                f"-uvm {self.rmh.configuration.logic_simulation.uvm_version.value}",
                f"-lib {ip.lib_name}",
                f"-l {report.vhdl_log_path}"
            ]
            job_cmp_vhdl = Job(self.rmh, report.work_directory, f"dsim_vhdl_compilation_{ip.lib_name}", os.path.join(self.installation_path, "bin", "dvhcom"), args)
            self.set_job_env(job_cmp_vhdl)
            results_cmp_vhdl = scheduler.dispatch_job(job_cmp_vhdl, scheduler_config)
            report.vhdl_compilation_success = (results_cmp_vhdl.return_code == 0)
        else:
            report.vhdl_compilation_success = True

    def do_elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, report: LogicSimulatorElaborationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        top_str = ""
        for top in ip.hdl_src.top:
            top_str = f"{top_str} -top {ip.lib_name}.{top}"
        args = self.rmh.configuration.logic_simulation.metrics_dsim_default_elaboration_arguments + [
            f"-genimage {ip.lib_name}",
            f"-uvm {self.rmh.configuration.logic_simulation.uvm_version.value}",
            top_str,
            f"-lib {ip.lib_name}",
            f"-l {report.log_path}",
        ]
        job_elaborate = Job(self.rmh, report.work_directory, f"dsim_elaboration_{ip.lib_name}", os.path.join(self.installation_path, "bin", "dsim"), args)
        self.set_job_env(job_elaborate)
        results_elaborate = scheduler.dispatch_job(job_elaborate, scheduler_config)
        report.elaboration_success = (results_elaborate.return_code == 0)

    def do_compile_and_elaborate(self, ip: Ip, config: LogicSimulatorCompilationAndElaborationConfiguration, report: LogicSimulatorCompilationAndElaborationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        if not ip.has_vhdl_content:
            defines_str = ""
            for define in report.defines_boolean:
                defines_str += f" +define+{define}"
            for define in report.defines_value:
                defines_str += f" +define+{define}={report.defines_value[define]}"
            top_str = ""
            for top in ip.hdl_src.top:
                top_str = f"{top_str} -top {ip.lib_name}.{top}"
            args = self.rmh.configuration.logic_simulation.metrics_dsim_default_compilation_and_elaboration_arguments + [
                f"-genimage {ip.lib_name}",
                defines_str,
                f"-F {report.file_list_path}",
                f"-uvm {self.rmh.configuration.logic_simulation.uvm_version.value}",
                top_str,
                f"-lib {ip.lib_name}",
                f"-l {report.log_path}"
            ]
            job_compile_and_elaborate = Job(self.rmh, report.work_directory, f"dsim_compilation_and_elaboration_{ip.lib_name}", os.path.join(self.installation_path, "bin", "dsim"), args)
            self.set_job_env(job_compile_and_elaborate)
            results_elaborate = scheduler.dispatch_job(job_compile_and_elaborate, scheduler_config)
            report.compilation_and_elaboration_success = (results_elaborate.return_code == 0)
        else:
            raise Exception(f"Cannot perform Compilation+Elaboration with DSim for IPs containing VHDL content: IP '{ip}'")

    def do_simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, report: LogicSimulatorSimulationReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        args_str = ""
        for arg in report.args_boolean:
            args_str += f" +{arg}"
        for arg in report.args_value:
            args_str += f" +{arg}={report.args_value[arg]}"
        args = self.rmh.configuration.logic_simulation.metrics_dsim_default_simulation_arguments + [
            f"-image {ip.lib_name}",
            args_str,
            f"-sv_seed {config.seed}",
            f"-uvm {self.rmh.configuration.logic_simulation.uvm_version.value}",
            #f"-sv_lib libcurl.so",
            f"-timescale {self.rmh.configuration.logic_simulation.timescale}",
            f"-l {report.log_path}"
        ]
        if config.enable_waveform_capture:
            args.append(f"-waves {report.waveform_file_path}.vcd.gz")
        if config.enable_coverage:
            args.append(f"-code-cov a")
            args.append(f"-cov-db {report.coverage_directory}")
        job_simulate = Job(self.rmh, report.work_directory, f"dsim_simulation_{ip.lib_name}",
                            os.path.join(self.installation_path, "bin", "dsim"), args)
        self.set_job_env(job_simulate)
        results_simulate = scheduler.dispatch_job(job_simulate, scheduler_config)
        report.simulation_success = (results_simulate.return_code == 0)

    def do_encrypt(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, report: LogicSimulatorEncryptionReport, scheduler: JobScheduler, scheduler_config: JobSchedulerConfiguration):
        if report.has_sv_files_to_encrypt:
            report.sv_encryption_success = True
            for file in report.sv_files_to_encrypt:
                file_encrypted = Path(f"{file}.encrypted")
                sv_args = []
                sv_args.append(str(file))
                sv_args.append(f"-i {self.rmh.configuration.encryption.metrics_dsim_sv_key_path}")
                sv_args.append(f"-o {file_encrypted}")
                job_encrypt_sv = Job(self.rmh, report.work_directory, f"dsim_encryption_sv_{ip.lib_name}_{file.name}",
                                     os.path.join(self.installation_path, "bin", "dvlencrypt"), sv_args)
                self.set_job_env(job_encrypt_sv)
                results_encrypt_sv = scheduler.dispatch_job(job_encrypt_sv, scheduler_config)
                report.sv_encryption_success &= (results_encrypt_sv.return_code == 0)
                if report.sv_encryption_success and os.path.isfile(file_encrypted) and os.path.getsize(file_encrypted) > 0:
                    with open(file, 'rb') as original_file, open(file_encrypted, 'rb') as encrypted_file:
                        if original_file.read() != encrypted_file.read():
                            self.rmh.move_file(file_encrypted, file)
                        else:
                            report.sv_encryption_success = False
                            raise Exception(f"Failed to encrypt file {file}")
                else:
                    report.sv_encryption_success = False
                    raise Exception(f"Failed to encrypt file {file}")
        else:
            report.sv_encryption_success = True
        if report.has_vhdl_files_to_encrypt:
            report.vhdl_encryption_success = True
            for file in report.vhdl_files_to_encrypt:
                file_encrypted = Path(f"{file}.encrypted")
                vhdl_args = []
                vhdl_args.append(str(file))
                vhdl_args.append(f"-i {self.rmh.configuration.encryption.metrics_dsim_vhdl_key_path}")
                vhdl_args.append(f"-o {file_encrypted}")
                job_encrypt_vhdl = Job(self.rmh, report.work_directory, f"dsim_encryption_vhdl_{ip.lib_name}_{file.name}",
                                       os.path.join(self.installation_path, "bin", "dvhencrypt"), vhdl_args)
                self.set_job_env(job_encrypt_vhdl)
                results_encrypt_vhdl = scheduler.dispatch_job(job_encrypt_vhdl, scheduler_config)
                report.vhdl_encryption_success &= (results_encrypt_vhdl.return_code == 0)
                if report.vhdl_encryption_success and os.path.isfile(file_encrypted) and os.path.getsize(file_encrypted) > 0:
                    with open(file, 'rb') as original_file, open(file_encrypted, 'rb') as encrypted_file:
                        if original_file.read() != encrypted_file.read():
                            self.rmh.move_file(file_encrypted, file)
                        else:
                            report.vhdl_encryption_success = False
                            raise Exception(f"Failed to encrypt file {file}")
                else:
                    report.vhdl_encryption_success = False
                    raise Exception(f"Failed to encrypt file {file}")
        else:
            report.vhdl_encryption_success = True
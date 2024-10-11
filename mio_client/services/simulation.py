# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
from enum import Enum
from pathlib import Path
from typing import List, Optional, Dict

from semantic_version import Version

from core.scheduler import JobScheduler, Job, JobSchedulerConfiguration
from core.service import Service, ServiceType
from core.ip import Ip
from abc import ABC, abstractmethod

from model import Model


def get_services():
    return [SimulatorMetricsDSim]


class LogicSimulators(Enum):
    DSIM = "Metrics DSim"
    VIVADO = "Xilinx Vivado"
    VCS = "Synopsys VCS"
    XCELIUM = "Cadence XCelium"
    QUESTA = "Siemens QuestaSim"
    RIVIERA_PRO = "Aldec Riviera-PRO"



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
    scheduler_cfg: Optional[JobSchedulerConfiguration] = None


class LogicSimulatorElaborationReport(LogicSimulatorReport):
    pass


class LogicSimulatorCompilationAndElaborationReport(LogicSimulatorReport):
    pass


class LogicSimulatorSimulationReport(LogicSimulatorReport):
    test_name: str
    seed: int


class LogicSimulatorEncryptionReport(LogicSimulatorReport):
    pass



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
    defines_values:dict[str, str] = {}

class LogicSimulatorElaborationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorElaborationAndCompilationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorSimulationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorEncryptionConfiguration(LogicSimulatorConfiguration):
    pass


class LogicSimulatorFileList(Model):
    name:str
    defines_boolean: Optional[list[str]] = []
    defines_values: Optional[dict[str, str]] = {}
    directories: Optional[list[Path]] = []
    files: Optional[list[Path]] = []
    
    
class LogicSimulatorMasterFileList(LogicSimulatorFileList):
    sub_file_lists: Optional[List[LogicSimulatorFileList]] = []


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
        self._library_results_path = self.simulation_logs_path / "library"
        self._compilation_results_path = self.simulation_logs_path / "compilation"
        self._elaboration_results_path = self.simulation_logs_path / "elaboration"
        self._compilation_and_elaboration_results_path = self.simulation_logs_path / "compilation_and_elaboration"

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

    @property
    def library_results_path(self) -> Path:
        return self._library_results_path

    @property
    def compilation_results_path(self) -> Path:
        return self._compilation_results_path

    @property
    def elaboration_results_path(self) -> Path:
        return self._elaboration_results_path

    @property
    def compilation_and_elaboration_results_path(self) -> Path:
        return self._compilation_and_elaboration_results_path

    def create_directory_structure(self):
        self.rmh.create_directory(self.work_root_path)
        self.rmh.create_directory(self.work_path)
        self.rmh.create_directory(self.work_temp_path)
        self.rmh.create_directory(self.simulation_root_path)
        self.rmh.create_directory(self.simulation_results_path)
        self.rmh.create_directory(self.regression_root_path)
        self.rmh.create_directory(self.simulation_logs_path)
        self.rmh.create_directory(self.library_results_path)
        self.rmh.create_directory(self.compilation_results_path)
        self.rmh.create_directory(self.elaboration_results_path)
        self.rmh.create_directory(self.compilation_and_elaboration_results_path)

    def create_files(self):
        pass

    def create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, scheduler: JobScheduler) -> LogicSimulatorLibraryCreationReport:
        report = LogicSimulatorLibraryCreationReport()
        self.do_create_library(ip, config, report, scheduler)
        self.parse_library_creation_logs(ip, config, report)
        return report

    def delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration, scheduler: JobScheduler) -> LogicSimulatorLibraryDeletionReport:
        report = LogicSimulatorLibraryDeletionReport()
        self.do_delete_library(ip, config, report, scheduler)
        return report

    def compile(self, ip: Ip, config: LogicSimulatorCompilationConfiguration, scheduler: JobScheduler) -> LogicSimulatorCompilationReport:
        report = LogicSimulatorCompilationReport(name=f"Compilation for '{ip}' using '{self.full_name}'")
        report.ordered_dependencies = ip.get_dependencies_in_order()
        self.build_sv_flist(ip, config, report)
        self.build_vhdl_flist(ip, config, report)
        if (not report.has_sv_files_to_compile) and (not report.has_vhdl_files_to_compile):
            raise Exception(f"No files to compile for IP '{ip}'")
        report.work_directory = self.work_path / f"{ip.work_directory_name}"
        report.sv_log_path = self.compilation_results_path / f"{ip.result_file_name}.cmp.sv.{self.name}.log"
        report.vhdl_log_path = self.compilation_results_path / f"{ip.result_file_name}.cmp.vhdl.{self.name}.log"
        self.rmh.create_directory(report.work_directory)
        self.do_compile(ip, config, report, scheduler)
        self.parse_compilation_logs(ip, config, report)
        return report

    def elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, scheduler: JobScheduler) -> LogicSimulatorElaborationReport:
        report = LogicSimulatorElaborationReport()
        self.do_elaborate(ip, config, report, scheduler)
        self.parse_elaboration_logs(ip, config, report)
        return report

    def compile_and_elaborate(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration, scheduler: JobScheduler) -> LogicSimulatorCompilationAndElaborationReport:
        report = LogicSimulatorCompilationAndElaborationReport()
        self.do_compile_and_elaborate(ip, config, report, scheduler)
        self.parse_compilation_and_elaboration_logs(ip, config, report)
        return report

    def simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, scheduler: JobScheduler) -> LogicSimulatorSimulationReport:
        report = LogicSimulatorSimulationReport()
        self.do_simulate(ip, config, report, scheduler)
        self.parse_simulation_logs(ip, config, report)
        return report

    def encrypt(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, scheduler: JobScheduler) -> LogicSimulatorEncryptionReport:
        report = LogicSimulatorEncryptionReport()
        self.do_encrypt(ip, config, report, scheduler)
        self.parse_encryption_logs(ip, config, report)
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
        report.success = (len(report.errors) == 0) and (len(report.fatals) == 0)

    def parse_elaboration_logs(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, report: LogicSimulatorElaborationReport) -> None:
        report.name = f"Elaboration for '{ip}' using '{self.full_name}'"
        #for log_path in log_paths:
        #    report.errors   += self.rmh.search_file_for_patterns(log_path, self.elaboration_error_patterns)
        #    report.warnings += self.rmh.search_file_for_patterns(log_path, self.elaboration_warning_patterns)
        #    report.fatals   += self.rmh.search_file_for_patterns(log_path, self.elaboration_fatal_patterns)
        #report.num_errors = len(report.errors)
        #report.num_warnings = len(report.warnings)
        #report.num_fatals = len(report.fatals)
        #report.success = (len(report.errors) == 0) and (len(report.fatals) == 0)

    def parse_compilation_and_elaboration_logs(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration, report: LogicSimulatorCompilationAndElaborationReport) -> None:
        report.name = f"Compilation and Elaboration for '{ip}' using '{self.full_name}'"
        #for log_path in log_paths:
        #    report.errors   += self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_error_patterns)
        #    report.warnings += self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_warning_patterns)
        #    report.fatals   += self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_fatal_patterns)
        #report.num_errors = len(report.errors)
        #report.num_warnings = len(report.warnings)
        #report.num_fatals = len(report.fatals)
        #report.success = (len(report.errors) == 0) and (len(report.fatals) == 0)

    def parse_simulation_logs(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, report: LogicSimulatorSimulationReport) -> None:
        report.name = f"Simulation for '{ip}' using '{self.full_name}'"
        #for log_path in log_paths:
        #    report.errors   += self.rmh.search_file_for_patterns(log_path, self.simulation_error_patterns)
        #    report.warnings += self.rmh.search_file_for_patterns(log_path, self.simulation_warning_patterns)
        #    report.fatals   += self.rmh.search_file_for_patterns(log_path, self.simulation_fatal_patterns)
        #report.num_errors = len(report.errors)
        #report.num_warnings = len(report.warnings)
        #report.num_fatals = len(report.fatals)
        #report.success = (len(report.errors) == 0) and (len(report.fatals) == 0)

    def parse_encryption_logs(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, report: LogicSimulatorEncryptionReport) -> None:
        report.name = f"Encryption for '{ip}' using '{self.full_name}'"
        #for log_path in log_paths:
        #    report.errors   += self.rmh.search_file_for_patterns(log_path, self.encryption_error_patterns  )
        #    report.warnings += self.rmh.search_file_for_patterns(log_path, self.encryption_warning_patterns)
        #    report.fatals   += self.rmh.search_file_for_patterns(log_path, self.encryption_fatal_patterns  )
        #report.num_errors = len(report.errors)
        #report.num_warnings = len(report.warnings)
        #report.num_fatals = len(report.fatals)
        #report.success = (len(report.errors) == 0) and (len(report.fatals) == 0)

    def build_sv_flist(self, ip:Ip, config:LogicSimulatorCompilationConfiguration, report:LogicSimulatorCompilationReport):
        file_list = LogicSimulatorMasterFileList(name=ip.lib_name)
        for dep in report.ordered_dependencies:
            sub_file_list = LogicSimulatorFileList(name=dep.lib_name)
            for directory in dep.resolved_hdl_directories:
                sub_file_list.directories.append(directory)
            for file in dep.resolved_top_sv_files:
                sub_file_list.files.append(file)
                report.has_sv_files_to_compile = True
            # TODO Add defines from targets
            file_list.sub_file_lists.append(sub_file_list)
        file_list.defines_boolean += config.defines_boolean
        file_list.defines_values.update(config.defines_values)
        for directory in ip.resolved_hdl_directories:
            file_list.directories.append(directory)
        for file in ip.resolved_top_sv_files:
            file_list.files.append(file)
            report.has_sv_files_to_compile = True
        if report.has_sv_files_to_compile:
            # Load the Jinja2 templates from disk
            template = self.rmh.j2_env.get_template(f"flist.sv.{self.name}.j2")
            # Render the templates with the master file lists
            filelist_rendered = template.render(data=file_list)
            # Save the rendered templates to disk
            flist_path = self.work_temp_path / f"{ip.result_file_name}.sv.{self.name}.flist"
            with open(flist_path, "w") as flist:
                flist.write(filelist_rendered)
            report.sv_file_list_path = flist_path

    def build_vhdl_flist(self, ip:Ip, config:LogicSimulatorCompilationConfiguration, report:LogicSimulatorCompilationReport):
        file_list = LogicSimulatorMasterFileList(name=ip.lib_name)
        for dep in report.ordered_dependencies:
            sub_file_list = LogicSimulatorFileList(name=dep.lib_name)
            for directory in dep.resolved_hdl_directories:
                sub_file_list.directories.append(directory)
            for file in dep.resolved_top_vhdl_files:
                sub_file_list.files.append(file)
                report.has_vhdl_files_to_compile = True
            # TODO Add defines from targets
            file_list.sub_file_lists.append(sub_file_list)
        file_list.defines_boolean += config.defines_boolean
        file_list.defines_values.update(config.defines_values)
        for directory in ip.resolved_hdl_directories:
            file_list.directories.append(directory)
        for file in ip.resolved_top_vhdl_files:
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
    def do_create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, report: LogicSimulatorLibraryCreationReport, scheduler: JobScheduler):
        pass

    @abstractmethod
    def do_delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration, report: LogicSimulatorLibraryDeletionReport, scheduler: JobScheduler):
        pass

    @abstractmethod
    def do_compile(self, ip: Ip, config: LogicSimulatorCompilationConfiguration, report: LogicSimulatorCompilationReport, scheduler: JobScheduler):
        pass

    @abstractmethod
    def do_elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, report: LogicSimulatorElaborationReport, scheduler: JobScheduler):
        pass

    @abstractmethod
    def do_compile_and_elaborate(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration, report: LogicSimulatorCompilationAndElaborationReport, scheduler: JobScheduler):
        pass

    @abstractmethod
    def do_simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, report: LogicSimulatorSimulationReport, scheduler: JobScheduler):
        pass

    @abstractmethod
    def do_encrypt(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, report: LogicSimulatorEncryptionReport, scheduler: JobScheduler):
        pass


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
        return [r'^.*=E:.*$', r'^UVM_ERROR.*$']
    @property
    def simulation_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$', r'^UVM_WARNING.*$']
    @property
    def simulation_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$', r'^UVM_FATAL.*$']
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

    def do_create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, report: LogicSimulatorLibraryCreationReport, scheduler: JobScheduler):
        pass

    def do_delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration, report: LogicSimulatorLibraryDeletionReport, scheduler: JobScheduler):
        pass

    def do_compile(self, ip: Ip, config:LogicSimulatorCompilationConfiguration, report:LogicSimulatorCompilationReport, scheduler:JobScheduler):
        scheduler_cfg = JobSchedulerConfiguration(self.rmh)
        if report.has_sv_files_to_compile:
            args = self.rmh.configuration.logic_simulation.metrics_dsim_default_compilation_sv_arguments + [
                f"-lib {ip.lib_name}",
                f"-F {report.sv_file_list_path}",
                f"-l {report.sv_log_path}"
            ]
            job_cmp_sv = Job(self.rmh, report.work_directory, "dsim_sv_compilation", os.path.join(self.installation_path, "bin", "dvlcom"), args)
            results_cmp_sv = scheduler.dispatch_job(job_cmp_sv, scheduler_cfg)
            report.sv_compilation_success = (results_cmp_sv.return_code == 0)
        if report.has_vhdl_files_to_compile:
            args = self.rmh.configuration.logic_simulation.metrics_dsim_default_compilation_vhdl_arguments + [
                f"-lib {ip.lib_name}",
                f"-F {report.vhdl_file_list_path}",
                f"-l {report.vhdl_log_path}"
            ]
            job_cmp_vhdl = Job(self.rmh, report.work_directory, "dsim_vhdl_compilation", os.path.join(self.installation_path, "bin", "dvhcom"), args)
            results_cmp_vhdl = scheduler.dispatch_job(job_cmp_vhdl, scheduler_cfg)
            report.vhdl_compilation_success = (results_cmp_vhdl.return_code == 0)

    def do_elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, report: LogicSimulatorElaborationReport, scheduler: JobScheduler):
        pass

    def do_compile_and_elaborate(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration, report: LogicSimulatorCompilationAndElaborationReport, scheduler: JobScheduler):
        pass

    def do_simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, report: LogicSimulatorSimulationReport, scheduler: JobScheduler):
        pass

    def do_encrypt(self, ip: Ip, config: LogicSimulatorEncryptionConfiguration, report: LogicSimulatorEncryptionReport, scheduler: JobScheduler):
        pass
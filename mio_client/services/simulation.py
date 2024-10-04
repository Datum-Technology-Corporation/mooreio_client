# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path
from typing import List, Pattern

from mio_client.core.scheduler import JobScheduler
from mio_client.core.service import Service, ServiceType
from abc import ABC, abstractmethod, abstractproperty

from mio_client.models.ip import Ip
from mio_client.models.simulation_reports import LibraryCreationReport, CompilationReport, SimulationReport, \
    CompilationAndElaborationReport, ElaborationReport


class LogicSimulatorConfiguration(ABC):
    pass

class LogicSimulatorLibraryCreationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorLibraryDeletionConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorCompilationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorElaborationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorElaborationAndCompilationConfiguration(LogicSimulatorConfiguration):
    pass

class LogicSimulatorSimulationConfiguration(LogicSimulatorConfiguration):
    pass


class LogicSimulator(Service, ABC):
    def __init__(self, rmh: 'RootManager', vendor_name: str, name: str, full_name: str, installation_path: Path):
        super().__init__(rmh, name)
        self._installation_path = installation_path
        self._type = ServiceType.LOGIC_SIMULATION
        self._work_root_path = self.rmh.md / "logic_simulation"
        self._work_path = self.work_root_path / self.name
        self._work_temp_path = self.work_path / "temp"
        self._work_compilation_path = self.work_path / "compilation_output"
        self._work_elaboration_path = self.work_path / "elaboration_output"
        self._work_compilation_and_elaboration_path = self.work_path / "compilation_and_elaboration_output"
        self._simulation_root_path = self.rmh.wd / self.rmh.configuration.simulation.root_path
        self._simulation_results_path = self.simulation_root_path / self.rmh.configuration.simulation.results_directory_name
        self._regression_root_path = self.simulation_root_path / self.rmh.configuration.simulation.regression_directory_name
        self._simulation_logs_path = self.simulation_root_path / self.rmh.configuration.simulation.logs_directory
        self._library_results_path = self.simulation_logs_path / "library"
        self._compilation_results_path = self.simulation_logs_path / "compilation"
        self._elaboration_results_path = self.simulation_logs_path / "elaboration"
        self._compilation_and_elaboration_results_path = self.simulation_logs_path / "compilation_and_elaboration"

    @property
    def installation_path(self) -> Path:
        return self._installation_path

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
    def work_compilation_path(self) -> Path:
        return self._work_compilation_path

    @property
    def work_elaboration_path(self) -> Path:
        return self._work_elaboration_path

    @property
    def work_compilation_and_elaboration_path(self) -> Path:
        return self._work_compilation_and_elaboration_path

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
        self.rmh.create_directory(self.work_compilation_path)
        self.rmh.create_directory(self.work_elaboration_path)
        self.rmh.create_directory(self.work_compilation_and_elaboration_path)
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

    def create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, scheduler: JobScheduler) -> LibraryCreationReport:
        log_path = self.do_create_library(config, ip)
        return self.parse_library_creation_log(ip, config, log_path)

    def delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration):
        self.do_delete_library(ip, config)

    def compile(self, ip: Ip, config: LogicSimulatorCompilationConfiguration) -> CompilationReport:
        log_path = self.do_compile(ip, config)
        return self.parse_compilation_log(ip, config, log_path)

    def elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration) -> ElaborationReport:
        log_path = self.do_elaborate(ip, config)
        return self.parse_elaboration_log(ip, config, log_path)

    def compile_and_elaborate(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration) -> CompilationAndElaborationReport:
        log_path = self.do_compile_and_elaborate(ip, config)
        return self.parse_compilation_and_elaboration_log(ip, config, log_path)

    def simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration) -> SimulationReport:
        results_directory_path = self.do_simulate(ip, config)
        return self.parse_simulation_logs(ip, config, results_directory_path)

    def parse_library_creation_log(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration, log_path: Path) -> LibraryCreationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.library_creation_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.library_creation_warning_patterns)
        fatals = self.rmh.search_file_for_patterns(log_path, self.library_creation_fatal_patterns)
        report = LibraryCreationReport()
        report.name = f"Library creation for '{ip}' using '{self.full_name}'"
        report.success = (len(errors) == 0) and (len(fatals) == 0)
        report.errors = errors
        report.warnings = warnings
        report.fatals = fatals
        report.num_errors = len(errors)
        report.num_warnings = len(warnings)
        report.num_fatals = len(fatals)
        return report

    def parse_compilation_log(self, ip: Ip, config: LogicSimulatorCompilationConfiguration, log_path: Path) -> CompilationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.compilation_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.compilation_warning_patterns)
        fatals = self.rmh.search_file_for_patterns(log_path, self.compilation_fatal_patterns)
        report = CompilationReport()
        report.name = f"Compilation for '{ip}' using '{self.full_name}'"
        report.success = (len(errors) == 0) and (len(fatals) == 0)
        report.errors = errors
        report.warnings = warnings
        report.fatals = fatals
        report.num_errors = len(errors)
        report.num_warnings = len(warnings)
        report.num_fatals = len(fatals)
        return report

    def parse_elaboration_log(self, ip: Ip, config: LogicSimulatorElaborationConfiguration, log_path: Path) -> ElaborationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.elaboration_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.elaboration_warning_patterns)
        fatals = self.rmh.search_file_for_patterns(log_path, self.elaboration_fatal_patterns)
        report = ElaborationReport()
        report.name = f"Elaboration for '{ip}' using '{self.full_name}'"
        report.success = (len(errors) == 0) and (len(fatals) == 0)
        report.errors = errors
        report.warnings = warnings
        report.fatals = fatals
        report.num_errors = len(errors)
        report.num_warnings = len(warnings)
        report.num_fatals = len(fatals)
        return report

    def parse_compilation_and_elaboration_log(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration, log_path: Path) -> CompilationAndElaborationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_warning_patterns)
        fatals = self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_fatal_patterns)
        report = CompilationAndElaborationReport()
        report.name = f"Compilation and Elaboration for '{ip}' using '{self.full_name}'"
        report.success = (len(errors) == 0) and (len(fatals) == 0)
        report.errors = errors
        report.warnings = warnings
        report.fatals = fatals
        report.num_errors = len(errors)
        report.num_warnings = len(warnings)
        report.num_fatals = len(fatals)
        return report

    def parse_simulation_logs(self, ip: Ip, config: LogicSimulatorSimulationConfiguration, log_path: Path) -> SimulationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.simulation_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.simulation_warning_patterns)
        fatals = self.rmh.search_file_for_patterns(log_path, self.simulation_fatal_patterns)
        report = SimulationReport()
        report.name = f"Simulation for '{ip}' using '{self.full_name}'"
        report.success = (len(errors) == 0) and (len(fatals) == 0)
        report.errors = errors
        report.warnings = warnings
        report.fatals = fatals
        report.num_errors = len(errors)
        report.num_warnings = len(warnings)
        report.num_fatals = len(fatals)
        return report
    
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
    
    @abstractmethod
    def do_create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration) -> Path:
        pass

    @abstractmethod
    def do_delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration):
        pass

    @abstractmethod
    def do_compile(self, ip: Ip, config: LogicSimulatorCompilationConfiguration) -> Path:
        pass

    @abstractmethod
    def do_elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration) -> Path:
        pass

    @abstractmethod
    def do_compile_and_elaborate(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration) -> Path:
        pass

    @abstractmethod
    def do_simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration) -> Path:
        pass


class SimulatorMetricsDSim(LogicSimulator):
    def __init__(self, rmh: 'RootManager', installation_path: Path):
        super().__init__(rmh, "Metrics Design Automation", "dsim", "DSim", installation_path)

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
        return [r'^.*=E:.*$', r'^.*UVM_ERROR.*$']
    @property
    def simulation_warning_patterns(self) -> List[str]:
        return [r'^.*=W:.*$', r'^.*UVM_WARNING.*$']
    @property
    def simulation_fatal_patterns(self) -> List[str]:
        return [r'^.*=F:.*$', r'^.*UVM_FATAL.*$']
    
    def do_create_library(self, ip: Ip, config: LogicSimulatorLibraryCreationConfiguration) -> Path:
        pass

    def do_delete_library(self, ip: Ip, config: LogicSimulatorLibraryDeletionConfiguration):
        pass

    def do_compile(self, ip: Ip, config: LogicSimulatorCompilationConfiguration) -> Path:
        pass

    def do_elaborate(self, ip: Ip, config: LogicSimulatorElaborationConfiguration) -> Path:
        pass

    def do_compile_and_elaborate(self, ip: Ip, config: LogicSimulatorElaborationAndCompilationConfiguration) -> Path:
        pass

    def do_simulate(self, ip: Ip, config: LogicSimulatorSimulationConfiguration) -> Path:
        pass
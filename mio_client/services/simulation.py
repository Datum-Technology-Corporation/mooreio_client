# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path
from typing import List, Pattern

from mio_client.core.root import RootManager
from mio_client.core.service import Service, ServiceType
from abc import ABC, abstractmethod, abstractproperty

from mio_client.models.command import Command
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
    def __init__(self, rmh: RootManager, vendor_name: str, name: str, full_name: str):
        super().__init__(rmh, name)
        self._type = ServiceType.LOGIC_SIMULATION
        self._work_root_path = self.rmh.md / "logic_simulation"
        self._work_path = self.work_root_path / self.name
        self._work_temp_path = self.work_path / "temp"
        self._work_compilation_path = self.work_path / "compilation_output"
        self._work_elaboration_path = self.work_path / "elaboration_output"
        self._work_compilation_and_elaboration_path = self.work_path / "compilation_and_elaboration_output"
        self._simulation_root_path = self.rmh.wd / self.rmh.configuration.simulation.root_path
        self._simulation_results_path = self.simulation_root_path / self.rmh.configuration.simulation.results_directory
        self._regression_root_path = self.simulation_root_path / self.rmh.configuration.simulation.regression_directory
        self._simulation_logs_path = self.simulation_root_path / self.rmh.configuration.simulation.logs_directory
        self._library_results_path = self.simulation_logs_path / "library"
        self._compilation_results_path = self.simulation_logs_path / "compilation"
        self._elaboration_results_path = self.simulation_logs_path / "elaboration"
        self._compilation_and_elaboration_results_path = self.simulation_logs_path / "compilation_and_elaboration"

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

    def create_library(self, command: Command, config: LogicSimulatorLibraryCreationConfiguration, ip: Ip) -> LibraryCreationReport:
        log_path = self.do_create_library(command, config, ip)
        return self.parse_library_creation_log(command, config, ip, log_path)

    def delete_library(self, command: Command, config: LogicSimulatorLibraryDeletionConfiguration, ip: Ip):
        self.do_delete_library(command, config, ip)

    def compile(self, command: Command, config: LogicSimulatorCompilationConfiguration, ip: Ip) -> CompilationReport:
        log_path = self.do_compile(command, config, ip)
        return self.parse_compilation_log(command, config, ip, log_path)

    def elaborate(self, command: Command, config: LogicSimulatorElaborationConfiguration, ip: Ip) -> ElaborationReport:
        log_path = self.do_elaborate(command, config, ip)
        return self.parse_elaboration_log(command, config, ip, log_path)

    def compile_and_elaborate(self, command: Command, config: LogicSimulatorElaborationAndCompilationConfiguration, ip: Ip) -> CompilationAndElaborationReport:
        log_path = self.do_compile_and_elaborate(command, config, ip)
        return self.parse_compilation_and_elaboration_log(command, config, ip, log_path)

    def simulate(self, command: Command, config: LogicSimulatorSimulationConfiguration, ip: Ip) -> SimulationReport:
        results_directory_path = self.do_simulate(command, config, ip)
        return self.parse_simulation_logs(command, config, ip, results_directory_path)

    def parse_library_creation_log(self, command: Command, config: LogicSimulatorLibraryCreationConfiguration, ip: Ip, log_path: Path) -> LibraryCreationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.library_creation_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.library_creation_warning_patterns)
        report = LibraryCreationReport(command, config, ip, errors, warnings)
        return report

    def parse_compilation_log(self, command: Command, config: LogicSimulatorCompilationConfiguration, ip: Ip, log_path: Path) -> CompilationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.compilation_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.compilation_warning_patterns)
        report = CompilationReport(command, config, ip, errors, warnings)
        return report

    def parse_elaboration_log(self, command: Command, config: LogicSimulatorElaborationConfiguration, ip: Ip, log_path: Path) -> ElaborationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.elaboration_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.elaboration_warning_patterns)
        report = ElaborationReport(command, config, ip, errors, warnings)
        return report

    def parse_compilation_and_elaboration_log(self, command: Command, config: LogicSimulatorElaborationAndCompilationConfiguration, ip: Ip, log_path: Path) -> CompilationAndElaborationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.compilation_and_elaboration_warning_patterns)
        report = CompilationAndElaborationReport(command, config, ip, errors, warnings)
        return report

    def parse_simulation_logs(self, command: Command, config: LogicSimulatorSimulationConfiguration, ip: Ip, log_path: Path) -> SimulationReport:
        errors = self.rmh.search_file_for_patterns(log_path, self.simulation_error_patterns)
        warnings = self.rmh.search_file_for_patterns(log_path, self.simulation_warning_patterns)
        report = SimulationReport(command, config, ip, errors, warnings)
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
    def compilation_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def compilation_warning_patterns(self) -> List[str]:
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
    def compilation_and_elaboration_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def compilation_and_elaboration_warning_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def simulation_error_patterns(self) -> List[str]:
        pass
    
    @property
    @abstractmethod
    def simulation_warning_patterns(self) -> List[str]:
        pass
    
    @abstractmethod
    def do_create_library(self, command: Command, config: LogicSimulatorLibraryCreationConfiguration, ip: Ip) -> Path:
        pass

    @abstractmethod
    def do_delete_library(self, command: Command, config: LogicSimulatorLibraryDeletionConfiguration, ip: Ip):
        pass

    @abstractmethod
    def do_compile(self, command: Command, config: LogicSimulatorCompilationConfiguration, ip: Ip) -> Path:
        pass

    @abstractmethod
    def do_elaborate(self, command: Command, config: LogicSimulatorElaborationConfiguration, ip: Ip) -> Path:
        pass

    @abstractmethod
    def do_compile_and_elaborate(self, command: Command, config: LogicSimulatorElaborationAndCompilationConfiguration, ip: Ip) -> Path:
        pass

    @abstractmethod
    def do_simulate(self, command: Command, config: LogicSimulatorSimulationConfiguration, ip: Ip) -> Path:
        pass


class SimulatorMetricsDSim(LogicSimulator):
    def __init__(self, rmh: RootManager):
        super().__init__(rmh, "Metrics Design Automation", "dsim", "DSim")

    @property
    def library_creation_error_patterns(self) -> List[str]:
        return []

    @property
    def library_creation_warning_patterns(self) -> List[str]:
        return []

    @property
    def compilation_error_patterns(self) -> List[str]:
        return []

    @property
    def compilation_warning_patterns(self) -> List[str]:
        return []

    @property
    def elaboration_error_patterns(self) -> List[str]:
        return []

    @property
    def elaboration_warning_patterns(self) -> List[str]:
        return []

    @property
    def compilation_and_elaboration_error_patterns(self) -> List[str]:
        return []

    @property
    def compilation_and_elaboration_warning_patterns(self) -> List[str]:
        return []

    @property
    def simulation_error_patterns(self) -> List[str]:
        return []

    @property
    def simulation_warning_patterns(self) -> List[str]:
        return []
    
    def do_create_library(self, command: Command, config: LogicSimulatorLibraryCreationConfiguration, ip: Ip) -> Path:
        pass

    def do_delete_library(self, command: Command, config: LogicSimulatorLibraryDeletionConfiguration, ip: Ip):
        pass

    def do_compile(self, command: Command, config: LogicSimulatorCompilationConfiguration, ip: Ip) -> Path:
        pass

    def do_elaborate(self, command: Command, config: LogicSimulatorElaborationConfiguration, ip: Ip) -> Path:
        pass

    def do_compile_and_elaborate(self, command: Command, config: LogicSimulatorElaborationAndCompilationConfiguration,
                                 ip: Ip) -> Path:
        pass

    def do_simulate(self, command: Command, config: LogicSimulatorSimulationConfiguration, ip: Ip) -> Path:
        pass
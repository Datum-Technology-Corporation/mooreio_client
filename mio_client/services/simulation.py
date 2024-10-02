# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path

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
    def __init__(self, rmh: RootManager, name: str, full_name: str):
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

    @abstractmethod
    def create_library(self, command: Command, config: LogicSimulatorLibraryCreationConfiguration, ip: Ip) -> LibraryCreationReport:
        pass

    @abstractmethod
    def delete_library(self, command: Command, config: LogicSimulatorLibraryDeletionConfiguration, ip: Ip):
        pass

    @abstractmethod
    def compile_ip(self, command: Command, config: LogicSimulatorCompilationConfiguration, ip: Ip) -> CompilationReport:
        pass

    @abstractmethod
    def elaborate_ip(self, command: Command, config: LogicSimulatorElaborationConfiguration, ip: Ip) -> ElaborationReport:
        pass

    @abstractmethod
    def compile_and_elaborate_ip(self, command: Command, config: LogicSimulatorElaborationAndCompilationConfiguration, ip: Ip) -> CompilationAndElaborationReport:
        pass

    @abstractmethod
    def simulate_ip(self, command: Command, config: LogicSimulatorSimulationConfiguration, ip: Ip) -> SimulationReport:
        pass


class SimulatorMetricsDSim(LogicSimulator):
    def __init__(self, rmh: RootManager, name: str, full_name: str):
        super().__init__(rmh, name, full_name)

    def create_library(self, command: Command, config: LogicSimulatorLibraryCreationConfiguration, ip: Ip) -> LibraryCreationReport:
        pass

    def delete_library(self, command: Command, config: LogicSimulatorLibraryDeletionConfiguration, ip: Ip):
        pass

    def compile_ip(self, command: Command, config: LogicSimulatorCompilationConfiguration, ip: Ip) -> CompilationReport:
        pass

    def elaborate_ip(self, command: Command, config: LogicSimulatorElaborationConfiguration, ip: Ip) -> ElaborationReport:
        pass

    def compile_and_elaborate_ip(self, command: Command, config: LogicSimulatorElaborationAndCompilationConfiguration,
                                 ip: Ip) -> CompilationAndElaborationReport:
        pass

    def simulate_ip(self, command: Command, config: LogicSimulatorSimulationConfiguration, ip: Ip) -> SimulationReport:
        pass
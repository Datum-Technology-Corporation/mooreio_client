# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from abc import ABC
from typing import List
from mio_client.core.model import Model


class LogicSimulatorReport(Model, ABC):
    name: str
    success: bool
    num_errors: int
    num_warnings: int
    num_fatals: int
    errors: List[int]
    warnings: List[int]
    fatals: List[int]


class LibraryCreationReport(LogicSimulatorReport):
    pass


class LibraryDeletionReport(LogicSimulatorReport):
    pass


class CompilationReport(LogicSimulatorReport):
    pass


class ElaborationReport(LogicSimulatorReport):
    pass


class CompilationAndElaborationReport(LogicSimulatorReport):
    pass


class SimulationReport(LogicSimulatorReport):
    test_name: str
    seed: int


class RegressionReport(LogicSimulatorReport):
    pass

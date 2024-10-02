# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from abc import ABC
from mio_client.core.model import Model


class LogicSimulatorReport(Model, ABC):
    pass


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
    pass


class RegressionReport(LogicSimulatorReport):
    pass

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from abc import ABC, abstractmethod
from enum import Enum

import semantic_version

from mio_client.core.root import RootManager


class ServiceType(Enum):
    UNKNOWN = "Unknown"
    CUSTOM = "Custom"
    PACKAGE_MANAGEMENT = "Package Management"
    LOGIC_SIMULATION = "logic Simulation"
    LOGIC_EMULATION = "logic Emulation"
    LOGIC_SYNTHESIS = "logic Synthesis"
    SPICE_SIMULATION = "SPICE Simulation"
    FORMAL_VERIFICATION = "Formal Verification"
    PLACE_AND_ROUTE = "Place-and-Route"
    CODE_GENERATION = "Code Generation"
    PRODUCT_VERIFICATION = "Product Verification (PV)"
    LINTING = "Linting"
    STATIC_TIMING_ANALYSIS = "Static Timing Analysis (STA)"
    DESIGN_FOR_TEST = "Design for Test (DFT)"
    CLOCK_DOMAIN_CROSSING_ANALYSIS = "Clock Domain Crossing (CDC) Analysis"


class Service(ABC):
    def __init__(self, rmh: RootManager, name: str, full_name: str):
        self._rmh = rmh
        self._name = name
        self._full_name = full_name
        self._type = ServiceType.UNKNOWN
        self._version = semantic_version.Version()

    @property
    def rmh(self) -> RootManager:
        return self._rmh

    @property
    def name(self) -> str:
        return self._name

    @property
    def full_name(self) -> str:
        return self._full_name

    @property
    def type(self) -> ServiceType:
        return self._type

    @abstractmethod
    def create_directory_structure(self):
        pass

    @abstractmethod
    def create_files(self):
        pass


class ServiceDataBase:
    def __init__(self, rmh: RootManager):
        self._rmh = rmh
        self._services = []
    def add_service(self, service: Service):
        service.db = self
        self._services.append(service)
    def get_service(self, service_type: ServiceType, name: str) -> Service:
        for service in self._services:
            if (service.type == service_type) and (service.name == name):
                return service
        raise Exception(f"No Service of type '{service_type}' and '{name}' exists in the Service Database")



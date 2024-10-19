# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import base64
import os
import tarfile
from collections import defaultdict, deque
from datetime import datetime
from http import HTTPMethod
from io import BytesIO
from pathlib import Path
from typing import Optional, List, Union, Any

import jinja2
import yaml
from pydantic import constr, PositiveInt, ValidationError
from semantic_version import SimpleSpec

from .model import Model, VALID_NAME_REGEX, VALID_IP_OWNER_NAME_REGEX, VALID_FSOC_NAMESPACE_REGEX, \
    VALID_POSIX_PATH_REGEX, UNDEFINED_CONST
#from mio_client.core.root import RootManager

from enum import Enum

#from mio_client.core.root import RootManager
from .version import SemanticVersion, SemanticVersionSpec
from .configuration import Ip
from .service import ServiceType


MAX_DEPTH_DEPENDENCY_INSTALLATION = 50

class IpPkgType(Enum):
    DV_LIBRARY = "dv_lib"
    DV_AGENT = "dv_agent"
    DV_ENV = "dv_env"
    DV_TB = "dv_tb"
    LIBRARY = "lib"
    BLOCK = "block"
    SS = "ss"
    FPGA = "fpga"
    CHIP = "chip"
    SYSTEM = "system"
    CUSTOM = "custom"

class DutType(Enum):
    MIO_IP = "ip"
    FUSE_SOC = "fsoc"
    VIVADO = "vivado"

class ParameterType(Enum):
    INT = "int"
    BOOL = "bool"

class IpLocationType(Enum):
    PROJECT_USER = "local"
    PROJECT_INSTALLED = "installed"
    GLOBAL = "global"

class IpLicenseType(Enum):
    PUBLIC_OPEN_SOURCE = "public_open_source"
    COMMERCIAL = "commercial"
    PRIVATE = "private"


        

class IpPublishingConfirmation(Model):
    success: bool
    certificator: str
    timestamp: datetime
    license_type: IpLicenseType


class IpPublishingCertificate(Model):
    granted: bool
    certificator: str
    timestamp: datetime
    license_type: IpLicenseType
    version_id: int
    license_id: Optional[int] = -1
    license_key: Optional[str] = UNDEFINED_CONST
    customer_id: Optional[int] = -1

    def __init__(self, **data: Any):
        super().__init__(**data)
        self._tgz_file_path: Path

    @property
    def tgz_file_path(self) -> Path:
        return self._tgz_file_path
    @tgz_file_path.setter
    def tgz_file_path(self, value: Path):
        self._tgz_file_path = Path(value)


class IpFindResults(Model):
    found: bool
    ip_id: Optional[int] = -1
    timestamp: Optional[datetime] = None
    license_type: Optional[IpLicenseType] = IpLicenseType.PUBLIC_OPEN_SOURCE
    license_id: Optional[int] = -1
    version: Optional[SemanticVersion] = SemanticVersion()
    version_id: Optional[int] = -1


class IpGetResults(Model):
    success: bool
    payload: Optional[str] = ""


class IpDefinition:
    vendor_name_is_specified: bool = False
    vendor_name: str = ""
    ip_name: str = ""
    version_spec: SimpleSpec = SimpleSpec("*")
    online_id: int
    find_results: IpFindResults

    def __str__(self):
        if self.vendor_name_is_specified:
            return f"{self.vendor_name}/{self.ip_name}"
        else:
            return self.ip_name

    @property
    def installation_directory_name(self) -> str:
        if not self.find_results:
            raise Exception(f"This IP Definition '{self}' has not been checked against the Server")
        else:
            version_str = str(self.find_results.version).replace(".", "p")
            if self.vendor_name_is_specified:
                return f"{self.vendor_name}__{self.ip_name}__{version_str}"
            else:
                return f"{self.ip_name}__{version_str}"


class Structure(Model):
    scripts_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    docs_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    examples_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    hdl_src_path: constr(pattern=VALID_POSIX_PATH_REGEX)


class HdlSource(Model):
    directories: List[constr(pattern=VALID_POSIX_PATH_REGEX)]
    top_sv_files: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []
    top_vhdl_files: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []
    top: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    tests_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    tests_name_template: Optional[str] = UNDEFINED_CONST
    so_libs: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []


class DesignUnderTest(Model):
    type: DutType
    name: Union[constr(pattern=VALID_NAME_REGEX), constr(pattern=VALID_FSOC_NAMESPACE_REGEX)] = UNDEFINED_CONST
    version: Optional[SemanticVersionSpec] = SemanticVersionSpec()
    target: Optional[constr(pattern=VALID_NAME_REGEX)] = UNDEFINED_CONST


class Parameter(Model):
    type: ParameterType
    min: Optional[int] = 0
    max: Optional[int] = 0
    default: Union[int, bool]


class Target(Model):
    cmp: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[PositiveInt, bool]]] = {}
    elab: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[PositiveInt, bool]]] = {}
    sim: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[PositiveInt, bool]]] = {}



class About(Model):
    sync: bool
    sync_id: Optional[PositiveInt] = 0
    sync_revision: Optional[str] = UNDEFINED_CONST
    encrypted: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    mlicensed: Optional[bool] = False
    pkg_type: IpPkgType
    vendor: str
    name: constr(pattern=VALID_NAME_REGEX)
    full_name: str
    version: SemanticVersion

class Ip(Model):
    ip: About
    dependencies: Optional[dict[constr(pattern=VALID_IP_OWNER_NAME_REGEX), SemanticVersionSpec]] = {}
    structure: Structure
    hdl_src: HdlSource
    dut: Optional[DesignUnderTest] = None
    targets: Optional[dict[constr(pattern=VALID_NAME_REGEX), Target]] = {}

    def __init__(self, **data: Any):
        super().__init__(**data)
        self._uid: int
        self._rmh: 'RootManager' = None
        self._ip_database: 'IpDatabase' = None
        self._file_path: Path = None
        self._location_type: IpLocationType
        self._file_path_set: bool = False
        self._root_path: Path = None
        self._resolved_src_path: Path = None
        self._resolved_docs_path: Path = None
        self._resolved_scripts_path: Path = None
        self._resolved_examples_path: Path = None
        self._has_docs: bool = False
        self._has_scripts: bool = False
        self._has_examples: bool = False
        self._resolved_hdl_directories: List[Path] = []
        self._resolved_shared_objects: List[Path] = []
        self._resolved_top_sv_files: List[Path] = []
        self._resolved_top_vhdl_files: List[Path] = []
        self._resolved_encrypted_hdl_directories: dict[str, List[Path]] = {}
        self._resolved_encrypted_shared_objects: dict[str, List[Path]] = {}
        self._resolved_encrypted_top_sv_files: dict[str, List[Path]] = {}
        self._resolved_encrypted_top_vhdl_files: dict[str, List[Path]] = {}
        self._resolved_top: List[str] = []
        self._resolved_dependencies: dict[IpDefinition, Ip] = {}
        self._dependencies_to_find_online: List[IpDefinition] = []
        self._dependencies_resolved: bool = False
        self._uninstalled = False

    def __str__(self):
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor} {self.ip.name} v{self.ip.version}"
        else:
            return f"{self.ip.name} v{self.ip.version}"

    @property
    def ip_database(self) -> 'IpDatabase':
        return self._ip_database
    @ip_database.setter
    def ip_database(self, value: 'IpDatabase'):
        self._ip_database = value
    
    @property
    def archive_name(self):
        version_no_dots = str(self.ip.version).replace(".", "p")
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor}__{self.ip.name}__v{version_no_dots}"
        else:
            return f"{self.ip.name}__v{self.ip.version}"

    @property
    def installation_directory_name(self):
        version_no_dots = str(self.ip.version).replace(".", "p")
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor}__{self.ip.name}__v{version_no_dots}"
        else:
            return f"{self.ip.name}__v{self.ip.version}"

    @property
    def lib_name(self):
        version_no_dots = str(self.ip.version).replace(".", "p")
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor}__{self.ip.name}__v{version_no_dots}"
        else:
            return f"{self.ip.name}__v{self.ip.version}"

    @property
    def image_name(self):
        version_no_dots = str(self.ip.version).replace(".", "p")
        if self.ip.vendor != UNDEFINED_CONST:
            return f"img__{self.ip.vendor}__{self.ip.name}__v{version_no_dots}"
        else:
            return f"img__{self.ip.name}__v{self.ip.version}"

    @property
    def work_directory_name(self):
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor}__{self.ip.name}"
        else:
            return f"{self.ip.name}"

    @property
    def result_file_name(self):
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor}_{self.ip.name}"
        else:
            return f"{self.ip.name}"

    @property
    def as_ip_definition(self):
        version_str = str(self.ip.version)
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor}/{self.ip.name}@{version_str}"
        else:
            return f"{self.ip.name}@{self.ip.version}"

    @property
    def has_vhdl_content(self) -> bool:
        return_bool:bool = False
        if len(self.resolved_top_vhdl_files) > 0:
            return_bool = True
        return return_bool

    @staticmethod
    def parse_ip_definition(definition: str) -> IpDefinition:
        ip_definition = IpDefinition()
        slash_split = definition.split("/")
        if len(slash_split) == 1:
            ip_definition.vendor_name_is_specified = False
            ip_definition.ip_name = slash_split[0].strip().lower()
        elif len(slash_split) == 2:
            ip_definition.vendor_name_is_specified = True
            ip_definition.vendor_name = slash_split[0].strip().lower()
            ip_definition.ip_name = slash_split[1].strip().lower()
        else:
            raise Exception(f"Invalid IP definition: {definition}")
        return ip_definition

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
    def uid(self) -> int:
        return self._uid
    @uid.setter
    def uid(self, value: int):
        self._uid = value

    @property
    def has_owner(self) -> bool:
        return self.ip.vendor != UNDEFINED_CONST
    
    @property
    def rmh(self) -> 'RootManager':
        return self._rmh
    @rmh.setter
    def rmh(self, value: 'RootManager'):
        self._rmh = value
    
    @property
    def file_path(self) -> Path:
        return self._file_path
    @file_path.setter
    def file_path(self, value: str):
        self._file_path_set = True
        self._file_path = Path(value)
        self._root_path = self._file_path.parent

    @property
    def location_type(self) -> IpLocationType:
        return self._location_type
    @location_type.setter
    def location_type(self, value: IpLocationType):
        self._location_type = value

    @property
    def root_path(self) -> Path:
        return self._root_path
    
    @property
    def resolved_src_path(self) -> Path:
        return self._resolved_src_path
    
    @property
    def resolved_docs_path(self) -> Path:
        return self._resolved_docs_path
    
    @property
    def resolved_scripts_path(self) -> Path:
        return self._resolved_scripts_path
    
    @property
    def resolved_examples_path(self) -> Path:
        return self._resolved_examples_path

    @property
    def resolved_hdl_directories(self) -> List[Path]:
        return self._resolved_hdl_directories

    @property
    def resolved_shared_objects(self) -> List[Path]:
        return self._resolved_shared_objects

    @property
    def resolved_top_sv_files(self) -> List[Path]:
        return self._resolved_top_sv_files

    @property
    def resolved_top_vhdl_files(self) -> List[Path]:
        return self._resolved_top_vhdl_files

    @property
    def resolved_encrypted_hdl_directories(self) -> dict[str, List[Path]]:
        return self._resolved_encrypted_hdl_directories

    @property
    def resolved_encrypted_shared_objects(self) -> dict[str, List[Path]]:
        return self._resolved_encryped_shared_objects

    @property
    def resolved_encrypted_top_sv_files(self) -> dict[str, List[Path]]:
        return self._resolved_encrypted_top_sv_files

    @property
    def resolved_encrypted_top_vhdl_files(self) -> dict[str, List[Path]]:
        return self._resolved_encrypted_top_vhdl_files
    
    @property
    def has_docs(self) -> bool:
        return self._has_docs
    
    @property
    def has_scripts(self) -> bool:
        return self._has_scripts
    
    @property
    def has_examples(self) -> bool:
        return self._has_examples

    @property
    def resolved_dependencies(self) -> dict[IpDefinition, Ip]:
        return self._resolved_dependencies

    @property
    def dependencies_resolved(self) -> bool:
        return self._dependencies_resolved
    @dependencies_resolved.setter
    def dependencies_resolved(self, value: bool):
        self._dependencies_resolved = value

    @property
    def uninstalled(self) -> bool:
        return self._uninstalled

    def check(self):
        # Check hdl-src directories & files
        self._resolved_src_path = self.root_path / self.structure.hdl_src_path
        if self.ip.mlicensed and (self.location_type == IpLocationType.PROJECT_INSTALLED):
            if len(self.ip.encrypted) == 0:
                raise Exception(f"IP '{self}' is licensed but has no simulators specified in 'encrypted'")
            else:
                for simulator in self.ip.encrypted:
                    self.check_hdl_src(Path(f"{self._resolved_src_path}.{simulator}"))
        else:
            self.check_hdl_src(self._resolved_src_path)
        # Check non-src directories
        if self.structure.scripts_path != UNDEFINED_CONST:
            self._has_scripts = True
            self._resolved_scripts_path = self.root_path / self.structure.scripts_path
            if not self.rmh.directory_exists(self.resolved_scripts_path):
                raise Exception(f"IP '{self}' scripts path '{self.resolved_scripts_path}' does not exist")
        if self.structure.docs_path != UNDEFINED_CONST:
            self._has_docs = True
            self._resolved_docs_path = self.root_path / self.structure.docs_path
            if not self.rmh.directory_exists(self.resolved_docs_path):
                raise Exception(f"IP '{self}' docs path '{self.resolved_docs_path}' does not exist")
        if self.structure.examples_path != UNDEFINED_CONST:
            self._has_examples = True
            self._resolved_examples_path = self.root_path / self.structure.examples_path
            if not self.rmh.directory_exists(self.resolved_examples_path):
                raise Exception(f"IP '{self}' examples path '{self.resolved_examples_path}' does not exist")

    def check_hdl_src(self, path:Path,simulator:str=""):
        if not self.rmh.directory_exists(path):
            raise Exception(f"IP '{self}' src path '{path}' does not exist")
        if self.hdl_src.tests_path != UNDEFINED_CONST:
            directory_path = path / self.hdl_src.tests_path
            if not self.rmh.directory_exists(directory_path):
                raise Exception(f"IP '{self}' HDL Tests src path '{directory_path}' does not exist")
        for directory in self.hdl_src.directories:
            directory_path = path / directory
            if not self.rmh.directory_exists(directory_path):
                raise Exception(f"IP '{self}' HDL src path '{directory_path}' does not exist")
            else:
                if simulator == "":
                    self._resolved_hdl_directories.append(directory_path)
                else:
                    if simulator not in self._resolved_encrypted_hdl_directories:
                        self._resolved_encrypted_hdl_directories[simulator] = []
                    self._resolved_encrypted_hdl_directories[simulator].append(directory_path)
        if self.hdl_src.tests_path != UNDEFINED_CONST:
            tests_directory_path = path / self.hdl_src.tests_path
            if not self.rmh.directory_exists(tests_directory_path):
                raise Exception(f"IP '{self}' HDL Tests src path '{tests_directory_path}' does not exist")
            else:
                if simulator == "":
                    self._resolved_hdl_directories.append(tests_directory_path)
                else:
                    if simulator not in self._resolved_encrypted_hdl_directories:
                        self._resolved_encrypted_hdl_directories[simulator] = []
                    self._resolved_encrypted_hdl_directories[simulator].append(tests_directory_path)
        for file in self.hdl_src.top_sv_files:
            full_path = path / file
            if not self.rmh.file_exists(full_path):
                raise Exception(f"IP '{self}' src SystemVerilog file path '{full_path}' does not exist")
            else:
                if simulator == "":
                    self._resolved_top_sv_files.append(full_path)
                else:
                    if simulator not in self._resolved_encrypted_top_sv_files:
                        self._resolved_encrypted_top_sv_files[simulator] = []
                    self._resolved_encrypted_top_sv_files[simulator].append(full_path)
        for file in self.hdl_src.top_vhdl_files:
            full_path = path / file
            if not self.rmh.file_exists(full_path):
                raise Exception(f"IP '{self}' src VHDL file path '{full_path}' does not exist")
            else:
                if simulator == "":
                    self._resolved_top_vhdl_files.append(full_path)
                else:
                    if simulator not in self._resolved_encrypted_top_vhdl_files:
                        self._resolved_encrypted_top_vhdl_files[simulator] = []
                    self._resolved_encrypted_top_vhdl_files[simulator].append(full_path)
        for shared_object in self.hdl_src.so_libs:
            if simulator == "":
                full_path = path / f"{shared_object}.so"
            else:
                full_path = path / f"{shared_object}.{simulator}.so"
            if not self.rmh.file_exists(full_path):
                raise Exception(f"IP '{self}' src shared object file path '{full_path}' does not exist")
            else:
                if simulator == "":
                    self._resolved_shared_objects.append(full_path)
                else:
                    if simulator not in self._resolved_encrypted_shared_objects:
                        self._resolved_encrypted_shared_objects[simulator] = []
                    self._resolved_encrypted_shared_objects[simulator].append(full_path)

    def add_resolved_dependency(self, ip_definition:IpDefinition, ip:Ip):
        self._resolved_dependencies[ip_definition] = ip
        if len(self._resolved_dependencies) == len(self.dependencies):
            self.dependencies_resolved = True
        else:
            self.dependencies_resolved = False
    
    def add_dependency_to_find_on_remote(self, ip_definition: IpDefinition):
        self._dependencies_to_find_online.append(ip_definition)
    
    def get_dependencies_to_find_on_remote(self) -> List[IpDefinition]:
        return self._dependencies_to_find_online

    def create_encrypted_compressed_tarball(self, encryption_config:'LogicSimulatorEncryptionConfiguration', certificate:IpPublishingCertificate=None) -> Path:
        try:
            if self.resolved_src_path == self.root_path:
                raise Exception(f"Cannot encrypt IPs where the source root is also the IP root: {self}")
            tgz_file_path = self.rmh.md / f"temp/{self.archive_name}.tgz"
            with tarfile.open(tgz_file_path, "w:gz") as tar:
                for sim_spec in self.ip.encrypted:
                    try:
                        simulator = self.ip_database.rmh.service_database.find_service(ServiceType.LOGIC_SIMULATION, sim_spec)
                        if certificate:
                            if self.ip.mlicensed and (certificate.license_key==""):
                                raise Exception(f"Cannot package Moore.io Licensed IP without a valid key")
                            else:
                                encryption_config.add_license_key_checks = True
                                encryption_config.mlicense_key = certificate.license_key
                                encryption_config.mlicense_id  = certificate.license_id
                        scheduler = self.ip_database.rmh.scheduler_database.get_default_scheduler()
                        encryption_report = simulator.encrypt(self, encryption_config, scheduler)
                        if not encryption_report.success:
                            raise Exception(f"Failed to encrypt")
                        else:
                            tar.add(encryption_report.path_to_encrypted_files, arcname=f"{self.structure.hdl_src_path}.{simulator.name}")
                            self.ip_database.rmh.remove_directory(encryption_report.path_to_encrypted_files)
                    except Exception as e:
                        raise Exception(f"Could not encrypt IP {self} for simulator '{sim_spec}': {e}")
                tar.add(self.file_path, arcname=self.file_path.name)
                if self.has_docs:
                    tar.add(self.resolved_docs_path, arcname=self.resolved_docs_path.name)
                if self.has_examples:
                    tar.add(self.resolved_examples_path, arcname=self.resolved_examples_path.name)
                if self.has_scripts:
                    tar.add(self.resolved_scripts_path, arcname=self.resolved_scripts_path.name)
        except Exception as e:
            raise Exception(f"Failed to create encrypted compressed tarball for {self}: {e}")
        return tgz_file_path
    
    def create_unencrypted_compressed_tarball(self) -> Path:
        try:
            tgz_file_path = self.rmh.md / f"temp/{self.archive_name}.tgz"
            with tarfile.open(tgz_file_path, "w:gz") as tar:
                if self.resolved_src_path == self.root_path:
                    tar.add(self.root_path, arcname=".", recursive=True)
                else:
                    tar.add(self.file_path, arcname=self.file_path.name)
                    tar.add(self.resolved_src_path, arcname=self.resolved_src_path.name)
                    if self.has_docs:
                        tar.add(self.resolved_docs_path, arcname=self.resolved_docs_path.name)
                    if self.has_examples:
                        tar.add(self.resolved_examples_path, arcname=self.resolved_examples_path.name)
                    if self.has_scripts:
                        tar.add(self.resolved_scripts_path, arcname=self.resolved_scripts_path.name)
        except Exception as e:
            raise Exception(f"Failed to create unencrypted compressed tarball for {self}: {e}")
        return tgz_file_path
    
    def uninstall(self):
        if self.location_type == IpLocationType.PROJECT_INSTALLED:
            if not self._uninstalled:
                self.rmh.remove_directory(self.root_path)
                self._uninstalled = True

    def __eq__(self, other):
        if isinstance(other, Ip):
            return self.archive_name == other.archive_name
        return False

    def __hash__(self):
        return hash(self.archive_name)
    
    def get_dependencies(self, src_dest_map:dict[Ip,Ip]):
        for dep in self.resolved_dependencies:
            dependency = self.resolved_dependencies[dep]
            src_dest_map[self] = dependency
            dependency.get_dependencies(src_dest_map)
    
    def get_dependencies_in_order(self) -> List[Ip]:
        """
        Apply a topological sorting algorithm to determine the order of compilation (Khan's algorithm)
        :return: List of IPs in order of compilation
        """
        all_ip = self.ip_database.get_all_ip()
        dependencies = {}
        self.get_dependencies(dependencies)
        # Create a graph and a dictionary to keep track of in-degrees of nodes
        graph = defaultdict(list)
        in_degree = {package: 0 for package in all_ip}
        # Populate the graph and in-degrees based on dependencies
        for dep in dependencies:
            graph[dep].append(dependencies[dep])
            in_degree[dependencies[dep]] += 1
        # Find all nodes with in-degree 0
        queue = deque([ip for ip in all_ip if in_degree[ip] == 0])
        topo_order = []
        while queue:
            node = queue.popleft()
            topo_order.append(node)
            # Decrease the in-degree of adjacent nodes
            for neighbor in graph[node]:
                in_degree[neighbor] -= 1
                # If in-degree becomes 0, add it to the queue
                if in_degree[neighbor] == 0:
                    queue.append(neighbor)
        # If topological sort includes all nodes, return the order
        # TODO Remove IP that aren't related to this IP
        if len(topo_order) == len(all_ip):
            # Remove self from the topological order if it exists
            if self in topo_order:
                topo_order.remove(self)
            return topo_order
        else:
            # There is a cycle and topological sorting is not possible
            raise Exception(f"A cycle was detected in {self} dependencies")


class IpDataBase():
    def __init__(self, rmh: 'RootManager'):
        self._rmh = rmh
        self._ip_list: list[Ip] = []
        self._rmh: 'RootManager' = rmh
        self._need_to_find_dependencies_on_remote: bool = False
        self._ip_with_missing_dependencies: dict[int, Ip] = {}
        self._ip_definitions_to_be_installed: list[IpDefinition] = []

    def add_ip(self, ip: Ip):
        self._ip_list.append(ip)
        ip.ip_database = self
    
    @property
    def rmh(self) -> 'RootManager':
        return self._rmh

    @property
    def has_ip(self) -> bool:
        return len(self._ip_list) > 0

    @property
    def num_ips(self) -> int:
        return len(self._ip_list)

    @property
    def need_to_find_dependencies_on_remote(self) -> bool:
        return self._need_to_find_dependencies_on_remote

    @property
    def ip_definitions_to_be_installed(self) -> list[IpDefinition]:
        return self._ip_definitions_to_be_installed

    def get_all_ip(self) -> list[Ip]:
        return self._ip_list

    def find_ip_definition(self, definition:IpDefinition, raise_exception_if_not_found:bool=True) -> Ip:
        if definition.vendor_name_is_specified:
            return self.find_ip(definition.ip_name, definition.vendor_name, definition.version_spec, raise_exception_if_not_found)
        else:
            return self.find_ip(definition.ip_name, "*", definition.version_spec, raise_exception_if_not_found)

    def find_ip(self, name:str, owner:str="*", version_spec:SimpleSpec=SimpleSpec("*"), raise_exception_if_not_found:bool=True) -> Ip:
        for ip in self._ip_list:
            if ip.ip.name == name and (owner == "*" or ip.ip.vendor == owner) and version_spec.match(ip.ip.version):
                return ip
        if raise_exception_if_not_found:
            raise ValueError(f"IP with name '{name}', owner '{owner}', version '{version_spec}' not found.")

    def discover_ip(self, path: Path, ip_location_type: IpLocationType, error_on_malformed:bool=False, error_on_nothing_found:bool=False) -> list[Ip]:
        ip_list: list[Ip] = []
        ip_files: list[str] = []
        for root, dirs, files in os.walk(path):
            for file in files:
                if file == 'ip.yml':
                    ip_files.append(os.path.join(root, file))
        if len(ip_files) == 0:
            if error_on_nothing_found:
                raise Exception(f"No 'ip.yml' files found in the '{ip_location_type}' directory.")
        else:
            for file in ip_files:
                try:
                    ip_model = Ip.load(file)
                    if ip_model.ip.vendor == UNDEFINED_CONST:
                        if self.find_ip(ip_model.ip.name, "*", SimpleSpec(str(ip_model.ip.version)), raise_exception_if_not_found=False):
                            continue
                    else:
                        if self.find_ip(ip_model.ip.name, ip_model.ip.vendor, SimpleSpec(str(ip_model.ip.version)), raise_exception_if_not_found=False):
                            continue
                    ip_model.rmh = self.rmh
                    ip_model.file_path = file
                    ip_model.uid = self.num_ips
                    ip_model.location_type = ip_location_type
                    ip_model.check()
                except ValidationError as e:
                    errors = e.errors()
                    error_messages = "\n  ".join([f"{error['msg']}: {error['loc']}" for error in errors])
                    if error_on_malformed:
                        raise Exception(f"IP definition at '{file}' is malformed: {error_messages}")
                    else:
                        print(f"Skipping IP definition at '{file}': {error_messages}")
                else:
                    self.add_ip(ip_model)
                    ip_list.append(ip_model)
        return ip_list

    def resolve_local_dependencies(self, reset_list_of_dependencies_to_find_online:bool=True):
        if reset_list_of_dependencies_to_find_online:
            self._dependencies_to_find_online = []
            self._need_to_find_dependencies_on_remote = False
        for ip in self._ip_list:
            self.resolve_dependencies(ip, reset_list_of_dependencies_to_find_online=False)

    def resolve_dependencies(self, ip:Ip, recursive:bool=False, reset_list_of_dependencies_to_find_online:bool=True, depth:int=0):
        if depth > MAX_DEPTH_DEPENDENCY_INSTALLATION:
            raise Exception(f"Loop detected in IP dependencies after depth of {depth}")
        if reset_list_of_dependencies_to_find_online:
            self._dependencies_to_find_online = []
            self._need_to_find_dependencies_on_remote = False
        for ip_definition_str, ip_version_spec in ip.dependencies.items():
            if not ip.dependencies_resolved:
                ip_definition = Ip.parse_ip_definition(ip_definition_str)
                ip_definition.version_spec = ip_version_spec
                ip_dependency = self.find_ip_definition(ip_definition, raise_exception_if_not_found=False)
                if ip_dependency is None:
                    ip.add_dependency_to_find_on_remote(ip_definition)
                    self._need_to_find_dependencies_on_remote = True
                    self._ip_with_missing_dependencies[ip.uid] = ip
                    self._dependencies_to_find_online.append(ip_definition)
                else:
                    ip.add_resolved_dependency(ip_definition, ip_dependency)
                    if recursive:
                        self.resolve_dependencies(ip_dependency, recursive=True, reset_list_of_dependencies_to_find_online=False, depth=depth+1)
    
    def find_all_missing_dependencies_on_server(self):
        ordered_deps = {}
        for dep in self._dependencies_to_find_online:
            if dep not in ordered_deps:
                ordered_deps[dep] = []
            ordered_deps[dep].append(dep.version_spec)
        # TODO Check all specs for same IP definition for contradictions using ordered_deps
        unique_dependencies = {dep.ip_name + dep.vendor_name: dep for dep in self._dependencies_to_find_online}
        self._dependencies_to_find_online = list(unique_dependencies.values())
        ip_definitions_not_found = []
        for ip_definition in self._dependencies_to_find_online:
            ip_definition.find_results = self.ip_definition_is_available_on_server(ip_definition)
            if ip_definition.find_results.found:
                self._ip_definitions_to_be_installed.append(ip_definition)
            else:
                print(f"Could not find IP dependency '{ip_definition}' on the Server")
                ip_definitions_not_found.append(ip_definition)
        if len(ip_definitions_not_found) > 0:
            raise Exception(f"Could not resolve all dependencies for the following IP: {ip_definitions_not_found}")

    def ip_definition_is_available_on_server(self, ip_definition: IpDefinition) -> IpFindResults:
        if ip_definition.vendor_name_is_specified:
            vendor = ip_definition.vendor_name
        else:
            vendor = "*"
        request = {
            "name": ip_definition.ip_name,
            "vendor": vendor,
            "version_spec": str(ip_definition.version_spec)
        }
        try:
            response = self.rmh.web_api_call(HTTPMethod.POST, "find-ip", request)
            results = IpFindResults.model_validate(response.json())
        except Exception as e:
            raise Exception(f"Error while getting IP '{ip_definition}' information from server")
        else:
            return results

    def install_all_missing_dependencies_from_server(self):
        ip_definitions_that_failed_to_install: list[IpDefinition] = []
        for ip_definition in self._ip_definitions_to_be_installed:
            if not self.install_ip_from_server(ip_definition):
                ip_definitions_that_failed_to_install.append(ip_definition)
        number_of_failed_installations = len(ip_definitions_that_failed_to_install)
        if number_of_failed_installations > 0:
            raise Exception(f"Failed to install {number_of_failed_installations} IPs from remote")
    
    def install_ip_from_server(self, ip_definition: IpDefinition) -> bool:
        request = {
            "version_id" : ip_definition.find_results.version_id,
            "license_id" : ip_definition.find_results.license_id
        }
        try:
            response = self.rmh.web_api_call(HTTPMethod.POST, "get-ip", request)
            results = IpGetResults.model_validate(response.json())
        except Exception as e:
            raise e
        else:
            if results.success:
                try:
                    b64encoded_data = results.payload
                    data = base64.b64decode(b64encoded_data)
                    path_installation = self.rmh.locally_installed_ip_dir / ip_definition.installation_directory_name
                    self.rmh.create_directory(path_installation)
                    with tarfile.open(fileobj=BytesIO(data), mode='r:gz') as tar:
                        tar.extractall(path=path_installation)
                except Exception as e:
                    raise Exception(f"Failed to decompress tgz data for IP version '{ip_definition.find_results.version_id}' from server: {e}")
                else:
                    return True
            else:
                raise Exception(f"Failed to get IP version '{ip_definition.find_results.version_id}' from server")
    
    def publish_new_version_to_server(self, ip:Ip, encryption_config:'LogicSimulatorEncryptionConfiguration', customer:str) -> IpPublishingCertificate:
        certificate = self.get_publishing_certificate(ip, customer)
        if not certificate.granted:
            raise Exception(f"IP {ip} is not available for publishing")
        else:
            if certificate.license_type == IpLicenseType.COMMERCIAL:
                if not ip.ip.mlicensed:
                    raise Exception(f"Attempting to publish Open-Source/Private IP to a Commercial license.")
                else:
                    if (certificate.license_id == -1) or (certificate.license_key == UNDEFINED_CONST) or (certificate.customer_id == -1):
                        raise Exception(f"Invalid certificate received for Commercial IP")
                    tgz_path = ip.create_encrypted_compressed_tarball(encryption_config, certificate)
            else:
                tgz_path = ip.create_unencrypted_compressed_tarball()
            certificate.tgz_file_path = tgz_path
            try:
                with open(tgz_path,'rb') as f:
                    tgz_b64_encoded = str(base64.b64encode(f.read()))[2:-1]
            except Exception as e:
                raise Exception(f"Failed to encode IP {ip} compressed tarball: {e}")
            else:
                try:
                    if certificate.license_type == IpLicenseType.COMMERCIAL:
                        data = {
                            'version_id' : certificate.version_id,
                            'license_id' : certificate.license_id,
                            'license_key' : certificate.license_key,
                            'payload' : str(tgz_b64_encoded),
                        }
                        response = self.rmh.web_api_call(HTTPMethod.POST, 'publish-ip/commercial-payload', data)
                        confirmation = IpPublishingConfirmation.model_validate(response.json())
                        if not confirmation.success:
                            raise Exception(f"Failed to push IP commercial payload to server for '{ip}'")
                    else:
                        data = {
                            'id' : certificate.version_id,
                            'payload' : str(tgz_b64_encoded),
                        }
                        response = self.rmh.web_api_call(HTTPMethod.POST, 'publish-ip/payload', data)
                        confirmation = IpPublishingConfirmation.model_validate(response.json())
                        if not confirmation.success:
                            raise Exception(f"Failed to push IP public payload to server for '{ip}'")
                except Exception as e:
                    raise Exception(f"Failed to push IP payload to server for '{ip}': {e}")
        return certificate
    
    def get_publishing_certificate(self, ip: Ip, customer:str) -> IpPublishingCertificate:
        request = {
            'vendor': ip.ip.vendor,
            "ip_name": ip.ip.name,
            "ip_id": ip.ip.sync_id,
            "ip_version": str(ip.ip.version),
            "customer": customer
        }
        try:
            response = self.rmh.web_api_call(HTTPMethod.POST, "publish-ip/certificate", request)
            certificate = IpPublishingCertificate.model_validate(response.json())
        except Exception as e:
            raise Exception(f"Failed to obtain certificate from server for publishing IP {ip}: {e}")
        else:
            return certificate
    
    def uninstall(self, ip:Ip, recursive:bool=True):
        if not ip.uninstalled:
            if recursive:
                for dep in ip.resolved_dependencies:
                    ip = ip.resolved_dependencies[dep]
                    self.uninstall(ip, recursive=True)
            ip.uninstall()
            if ip.location_type == IpLocationType.PROJECT_INSTALLED:
                try: # HACK!
                    self._ip_list.remove(ip)
                except:
                    pass

    def uninstall_all(self):
        list_copy = self._ip_list.copy()
        for ip in list_copy:
            self.uninstall(ip, recursive=False)

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from http import HTTPMethod
from pathlib import Path
from typing import Optional, List, Union

import jinja2
import yaml
from pydantic import BaseModel, AnyUrl, constr, FilePath, PositiveInt
from pydantic import DirectoryPath
from pydantic_extra_types import semantic_version
from semantic_version import Spec, SimpleSpec, Version

from mio_client.core.model import Model, VALID_NAME_REGEX, VALID_IP_OWNER_NAME_REGEX, VALID_FSOC_NAMESPACE_REGEX, \
    VALID_POSIX_DIR_NAME_REGEX, VALID_POSIX_PATH_REGEX, UNDEFINED_CONST
#from mio_client.core.root import RootManager

from enum import Enum

#from mio_client.core.root import RootManager
from mio_client.core.version import SemanticVersion, SemanticVersionSpec
from mio_client.models.configuration import Ip


class IpType(Enum):
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


class IpDefinition:
    owner_name_is_specified: bool = False
    owner_name: str = ""
    ip_name: str = ""
    version_spec: SimpleSpec
    online_id: int
    
    def __str__(self):
        if self.owner_name_is_specified:
            return f"{self.owner_name}/{self.ip_name}"
        else:
            return self.ip_name


class Structure(Model):
    scripts_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    docs_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    examples_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    src_path: constr(pattern=VALID_POSIX_PATH_REGEX)


class HdlSource(Model):
    directories: List[constr(pattern=VALID_POSIX_PATH_REGEX)]
    top_sv_files: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []
    top_vhdl_files: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []
    top: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    tests_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    tests_name_template: Optional[jinja2.Template] = UNDEFINED_CONST
    so_libs: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []


class DesignUnderTest(Model):
    type: DutType
    name: Union[constr(pattern=VALID_NAME_REGEX), constr(pattern=VALID_FSOC_NAMESPACE_REGEX)] = UNDEFINED_CONST
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
    type: IpType
    owner: Optional[str] = UNDEFINED_CONST
    name: Optional[constr(pattern=VALID_NAME_REGEX)] = UNDEFINED_CONST
    full_name: Optional[str] = ""
    version: Optional[SemanticVersion]

class Ip(Model):
    _uid: int
    _rmh: 'RootManager' = None
    _file_path: Path = None
    _file_path_set: bool = False
    _root_path: Path = None
    _resolved_src_path: Path = None
    _resolved_top_sv_files: List[Path] = []
    _resolved_top_vhdl_files: List[Path] = []
    _resolved_top: List[str] = []
    _resolved_dependencies: list[Ip] = []
    _dependencies_to_find_online: List[IpDefinition] = []
    _dependencies_resolved: bool = False
    
    ip: About
    dependencies: Optional[dict[constr(pattern=VALID_IP_OWNER_NAME_REGEX), SemanticVersionSpec]] = {}
    structure: Structure
    hdl_src: HdlSource
    dut: Optional[DesignUnderTest] = None
    targets: Optional[dict[constr(pattern=VALID_NAME_REGEX), Target]] = {}

    @staticmethod
    def parse_ip_definition(definition: str) -> IpDefinition:
        ip_definition = IpDefinition()
        slash_split = definition.split("/")
        if len(slash_split) == 1:
            ip_definition.owner_name_is_specified = False
            ip_definition.ip_name = slash_split[0].strip().lower()
        elif len(slash_split) == 2:
            ip_definition.owner_name_is_specified = True
            ip_definition.owner_name = slash_split[0].strip().lower()
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
        return self.ip.owner != UNDEFINED_CONST
    
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
    def root_path(self) -> Path:
        return self._root_path
    
    @property
    def resolved_src_path(self) -> Path:
        return self._resolved_src_path

    @property
    def dependencies_resolved(self) -> bool:
        return self._dependencies_resolved
    @dependencies_resolved.setter
    def dependencies_resolved(self, value: bool):
        self._dependencies_resolved = value
    
    def check(self):
        self._resolved_src_path = self.root_path / self.structure.src_path
        self.rmh.directory_exists(self.resolved_src_path)
        if self.structure.scripts_path != UNDEFINED_CONST:
            self.rmh.directory_exists(self.root_path / self.structure.scripts_path)
        if self.structure.docs_path != UNDEFINED_CONST:
            self.rmh.directory_exists(self.root_path / self.structure.docs_path)
        if self.structure.examples_path != UNDEFINED_CONST:
            self.rmh.directory_exists(self.root_path / self.structure.examples_path)
        for directory in self.hdl_src.directories:
            self.rmh.directory_exists(self.root_path / directory)
        for file in self.hdl_src.top_sv_files:
            full_path = self.root_path / file
            self.rmh.file_exists(full_path)
            self._resolved_top_sv_files.append(full_path)
        for file in self.hdl_src.top_vhdl_files:
            full_path = self.root_path / file
            self.rmh.file_exists(full_path)
            self._resolved_top_vhdl_files.append(full_path)
        if self.hdl_src.tests_path != UNDEFINED_CONST:
            self.rmh.directory_exists(self.root_path / self.hdl_src.tests_path)

    def add_resolved_dependency(self, ip: Ip):
        self._resolved_dependencies.append(ip)
    
    def add_dependency_to_find_online(self, ip_definition: IpDefinition):
        self._dependencies_to_find_online.append(ip_definition)
    
    def get_dependencies_to_find_online(self) -> List[IpDefinition]:
        return self._dependencies_to_find_online


class IpDataBase():
    _ip_list: list[Ip] = []
    _rmh: 'RootManager' = None
    _need_to_find_dependencies_online: bool = False
    _ip_with_missing_dependencies: dict[int, Ip] = {}
    _ip_definitions_to_be_installed: list[IpDefinition] = []
    
    def __init__(self, rmh: 'RootManager'):
        self._rmh = rmh

    def add_ip(self, ip: Ip):
        self._ip_list.append(ip)
    
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
    def need_to_find_dependencies_online(self) -> bool:
        return self._need_to_find_dependencies_online

    def get_all_ip(self) -> list[Ip]:
        return self._ip_list

    def find_ip_definition(self, definition:IpDefinition, raise_exception_if_not_found:bool=True) -> Ip:
        if definition.owner_name_is_specified:
            return self.find_ip(definition.ip_name, definition.owner_name, definition.version_spec, raise_exception_if_not_found)
        else:
            return self.find_ip(definition.ip_name, "*", definition.version_spec, raise_exception_if_not_found)

    def find_ip(self, name:str, owner:str="*", version:SimpleSpec=SimpleSpec("*"), raise_exception_if_not_found:bool=True) -> Ip:
        for ip in self._ip_list:
            if ip.ip.name == name and (owner == "*" or ip.ip.owner == owner) and version.match(ip.ip.version):
                return ip
        if raise_exception_if_not_found:
            raise ValueError(f"IP with name '{name}', owner '{owner}', version '{version}' not found.")

    def resolve_local_dependencies(self):
        for ip in self._ip_list:
            for ip_definition_str, ip_version_spec in ip.dependencies.items():
                ip_definition = Ip.parse_ip_definition(ip_definition_str)
                ip_definition.version_spec = ip_version_spec
                ip_dependency = self.find_ip_definition(ip_definition, raise_exception_if_not_found=False)
                if ip_dependency is None:
                    ip.add_dependency_to_find_online(ip_definition)
                    self._need_to_find_dependencies_online = True
                    self._ip_with_missing_dependencies[ip.uid] = ip
                else:
                    ip.add_resolved_dependency(ip_dependency)
    
    def find_dependencies_online(self, phase: 'Phase'):
        ip_definitions_not_found = []
        for ip_uid in self._ip_with_missing_dependencies:
            ip = self._ip_with_missing_dependencies[ip_uid]
            for ip_definition in ip.get_dependencies_to_find_online():
                if ip_definition.owner_name_is_specified:
                    owner = ip_definition.owner_name
                else:
                    owner = "*"
                request = {
                    "name": ip_definition.ip_name,
                    "owner": owner,
                    "version_spec": ip_definition.version_spec
                }
                response = self.rmh.web_api_call(HTTPMethod.POST, "find_ip", request)
                try:
                    if response['exists'].lower() == 'true':
                        found_ip = True
                    else:
                        found_ip = False
                except:
                    found_ip = False
                if found_ip:
                    ip_definition.online_id = int(response['id'])
                    self._ip_definitions_to_be_installed.append(ip_definition)
                else:
                    print(f"Could not find IP '{ip.ip.full_name}' dependency '{ip_definition}' on the Moore.io Server")
                    ip_definitions_not_found.append(ip_definition)
        if len(ip_definitions_not_found) > 0:
            phase.error = Exception(f"Could not resolve all dependencies for the following IP: {ip_definitions_not_found}")
    
    def install_remote_dependencies(self, phase: 'Phase'):
        ip_definitions_that_failed_to_install: list[IpDefinition] = []
        new_ip_list: list[Ip] = []
        # Prompt the user to confirm if they want to install the dependencies
        install_confirmation = input(
            f"Do you want to install {len(self._ip_definitions_to_be_installed)} remote dependencies? (Y/n): ")
        if install_confirmation.lower() in ["y", "yes", ""]:
            for ip_definition in self._ip_definitions_to_be_installed:
                try:
                    response = self.rmh.web_api_call(HTTPMethod.POST, "get_ip", {"id": ip_definition.online_id})
                except Exception as e:
                    ip_definitions_that_failed_to_install.append(ip_definition)
                else:
                    new_ip = Ip.model_validate(response)
                    new_ip_list.append(new_ip)
            if len(ip_definitions_that_failed_to_install) > 0:
                phase.error = Exception(f"Failed to install the following IP: {e}")
            else:
                for ip in new_ip_list:
                    self.add_ip(ip)

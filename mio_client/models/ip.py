# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path
from typing import Optional, List, Union

import jinja2
import yaml
from pydantic import BaseModel, AnyUrl, constr, FilePath, PositiveInt
from pydantic import DirectoryPath
from pydantic_extra_types import semantic_version
from semantic_version import Spec, SimpleSpec

from mio_client.core.model import Model, VALID_NAME_REGEX, VALID_IP_OWNER_NAME_REGEX, VALID_FSOC_NAMESPACE_REGEX, \
    VALID_POSIX_DIR_NAME_REGEX, VALID_POSIX_PATH_REGEX, UNDEFINED_CONST
#from mio_client.core.root import RootManager

from enum import Enum

#from mio_client.core.root import RootManager
from mio_client.core.version import SemanticVersion, SemanticVersionSpec


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

class IpDefinition:
    owner_name_is_specified = False
    owner_name = ""
    ip_name = ""

class Ip(Model):
    _rmh: 'RootManager' = None
    _file_path: Path = None
    _file_path_set: bool = False
    _root_path: Path = None
    _resolved_src_path: Path = None
    _resolved_top_sv_files: List[Path] = []
    _resolved_top_vhdl_files: List[Path] = []
    _resolved_top: List[str] = []
    
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


class IpDataBase():
    def __init__(self, rmh: 'RootManager'):
        self._rmh = rmh
        self._ip_list = []

    def add_ip(self, ip: Ip):
        self._ip_list.append(ip)

    @property
    def has_ip(self) -> bool:
        return len(self._ip_list) > 0

    def get_all_ip(self) -> list[Ip]:
        return self._ip_list

    def find_ip(self, name: str, owner: str = "*", version: SimpleSpec = SimpleSpec("*")) -> Ip:
        for ip in self._ip_list:
            if ip.ip.name == name and (owner == "*" or ip.ip.owner == owner) and version.match(ip.version):
                return ip
        raise ValueError(f"IP with name '{name}', owner '{owner}', version '{version}' not found.")

    def validate_dependencies(self):
        pass

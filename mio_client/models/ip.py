# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path
from typing import Optional, List, Union

import jinja2
import yaml
from pydantic import BaseModel, AnyUrl, constr
from pydantic_extra_types import semantic_version
from semantic_version import Spec

from mio_client.core.model import Model, VALID_NAME_REGEX, VALID_IP_OWNER_NAME_REGEX, VALID_FSOC_NAMESPACE_REGEX
#from mio_client.core.root import RootManager

from enum import Enum

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
    scripts_path: Path
    docs_path: Path
    examples_path: Path
    src_path: Path


class HdlSource(Model):
    directories: List[Path]
    top_files: List[Path]
    top_modules: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    tests_path: Optional[Path] = Path()
    tests_name_template: Optional[jinja2.Template] = ""
    so_libs: Optional[List[Path]] = []


class DesignUnderTest(Model):
    type: DutType
    name: constr(pattern=VALID_NAME_REGEX)
    fsoc_namepace: Optional[constr(pattern=VALID_FSOC_NAMESPACE_REGEX)] = "_"
    target: Optional[constr(pattern=VALID_NAME_REGEX)] = "_"


class Parameter(Model):
    type: ParameterType
    min: Optional[int] = 0
    max: Optional[int] = 0
    default: Union[int, bool]


class Target(Model):
    cmp: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[int, bool]]] = {}

    elab: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[int, bool]]] = {}

    sim: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[int, bool]]] = {}



class About(Model):
    sync: bool
    sync_id: Optional[int] = 0
    type: Optional[IpType]
    owner: Optional[str] = "_"
    name: Optional[constr(pattern=VALID_NAME_REGEX)] = "_"
    full_name: Optional[str] = ""
    version: Optional[SemanticVersion]

class Ip(Model):
    ip: About
    dependencies: Optional[dict[constr(pattern=VALID_IP_OWNER_NAME_REGEX), SemanticVersionSpec]] = {}
    structure: Structure
    hdl_src: HdlSource
    dut: Optional[DesignUnderTest] = None
    targets: Optional[dict[constr(pattern=VALID_NAME_REGEX), Target]] = {}


class IpDataBase():
    def __init__(self, rmh: 'RootManager'):
        self._rmh = rmh
        self._ip_list = []

    def add_ip(self, ip: Ip):
        self._ip_list.append(ip)

    def find_ip(self, name: str, owner: str = "*", version: Spec = Spec("*")) -> Ip:
        for ip in self._ip_list:
            if ip.ip.name == name and (owner == "*" or ip.ip.owner == owner) and version.match(ip.version):
                return ip
        raise ValueError(f"IP with name '{name}', owner '{owner}', version '{version}' not found.")

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pathlib import Path
from typing import Optional, List

import jinja2
import semantic_version
import yaml
from pydantic import BaseModel, AnyUrl, constr
from semantic_version import Spec

from mio_client.core.model import Model, VALID_NAME_REGEX, VALID_IP_OWNER_NAME_REGEX, VALID_FSOC_NAMESPACE_REGEX
from mio_client.core.root import RootManager

from enum import Enum


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


class IpSection(Model):
    synced: bool
    sync_id: Optional[int]
    type: Optional[IpType]
    owner: Optional[str]
    name: Optional[constr(regex=VALID_NAME_REGEX)]
    full_name: Optional[str]
    block_diagram: Optional[Path]
    description: Optional[str]


class Structure(Model):
    scripts_path: Path
    docs_path: Path
    examples_path: Path
    src_path: Path


class HdlSource(Model):
    directories: List[Path]
    top_files: List[Path]
    top_modules: Optional[List[constr(regex=VALID_NAME_REGEX)]]
    tests_path: Optional[Path]
    tests_name_template: Optional[jinja2.Template]
    so_libs: Optional[List[Path]]


class DesignUnderTest(Model):
    type: DutType
    name: constr(regex=VALID_NAME_REGEX)
    fsoc_namepace: Optional[constr(regex=VALID_FSOC_NAMESPACE_REGEX)]
    target: Optional[constr(regex=VALID_NAME_REGEX)]


class Target(Model):
    cmp: Optional[dict[constr(regex=VALID_NAME_REGEX), int]]
    elab: Optional[dict[constr(regex=VALID_NAME_REGEX), int]]
    sim: Optional[dict[constr(regex=VALID_NAME_REGEX), int]]


class Ip(Model):
    ip: IpSection
    dependencies: Optional[dict[constr(regex=VALID_IP_OWNER_NAME_REGEX), Spec]]
    structure: Structure
    hdl_src: HdlSource
    dut: Optional[DesignUnderTest]
    targets: Optional[dict[constr(regex=VALID_NAME_REGEX), Target]]


class IpDataBase():
    def __init__(self, rmh: RootManager):
        self._rmh = rmh
        self._ip_list = []

    def add_ip(self, ip: Ip):
        self._ip_list.append(ip)

    def find_ip(self, name: str, owner: str = "*", version: Spec = Spec("*")) -> Ip:
        for ip in self._ip_list:
            if ip.ip.name == name and (owner == "*" or ip.ip.owner == owner) and version.match(ip.version):
                return ip
        raise ValueError(f"IP with name '{name}', owner '{owner}', version '{version}' not found.")

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from typing import List, Optional

import jinja2
import toml
from pydantic import BaseModel, constr
from mio_client.core.model import Model, VALID_NAME_REGEX, VALID_LOGIC_SIMULATION_TIMESCALE_REGEX
from pathlib import Path
from pydantic import DirectoryPath
import semantic_version

from mio_client.core.version import SemanticVersion

from enum import Enum


class UvmVersions(Enum):
    V_1_2 = "1.2"
    V_1_1d = "1.1d"
    V_1_1c = "1.1c"
    V_1_1b = "1.1b"
    V_1_1a = "1.1a"
    V_1_0 = "1.0"


class Project(Model):
    sync: bool
    sync_id: Optional[int] = 0
    name: Optional[constr(pattern=VALID_NAME_REGEX)] = "_"
    full_name: Optional[str] = "_"


class LogicSimulation(Model):
    root_path: Path
    regression_directory_name: Path
    results_directory_name: Path
    logs_directory: Path
    test_result_path_template: str
    uvm_version: UvmVersions
    timescale: constr(pattern=VALID_LOGIC_SIMULATION_TIMESCALE_REGEX)
    metrics_dsim_path: Optional[Path] = Path("")
    xilinx_vivado_path: Optional[Path] = Path("")
    synopsys_vcs_path: Optional[Path] = Path("")
    siemens_questa_path: Optional[Path] = Path("")
    cadence_xcelium_path: Optional[Path] = Path("")
    aldec_riviera_pro_path: Optional[Path] = Path("")
    default_simulator: Optional[str] = ""


class Synthesis(Model):
    root_path: Path


class Linting(Model):
    root_path: Path


class Ip(Model):
    global_paths: Optional[List[Path]] = []
    local_paths: [List[Path]]


class Docs(Model):
    root_path: Path


class Encryption(Model):
    metrics_dsim_key_path: Optional[Path] = Path("")
    xilinx_vivado_key_path: Optional[Path] = Path("")
    synopsys_vcs_key_path: Optional[Path] = Path("")
    siemens_questa_key_path: Optional[Path] = Path("")
    cadence_xcelium_key_path: Optional[Path] = Path("")
    aldec_riviera_pro_key_path: Optional[Path] = Path("")


class Configuration(Model):
    """
    Model for mio.toml configuration files.
    """
    project: Project
    logic_simulation: LogicSimulation
    synthesis: Synthesis
    lint: Linting
    ip: Ip
    docs: Docs
    encryption: Encryption

    def check(self):
        pass

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from typing import List, Optional

import jinja2
import toml
from pydantic import BaseModel, constr, FilePath, PositiveInt
from mio_client.core.model import Model, VALID_NAME_REGEX, VALID_LOGIC_SIMULATION_TIMESCALE_REGEX, \
    VALID_POSIX_PATH_REGEX, VALID_POSIX_DIR_NAME_REGEX
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
    sync_id: Optional[PositiveInt] = 0
    name: Optional[constr(pattern=VALID_NAME_REGEX)] = "_"
    full_name: Optional[str] = "_"


class LogicSimulation(Model):
    root_path: constr(pattern=VALID_POSIX_PATH_REGEX)
    regression_directory_name: constr(pattern=VALID_POSIX_DIR_NAME_REGEX)
    results_directory_name: constr(pattern=VALID_POSIX_DIR_NAME_REGEX)
    logs_directory: constr(pattern=VALID_POSIX_DIR_NAME_REGEX)
    test_result_path_template: str
    uvm_version: UvmVersions
    timescale: constr(pattern=VALID_LOGIC_SIMULATION_TIMESCALE_REGEX)
    metrics_dsim_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    xilinx_vivado_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    synopsys_vcs_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    siemens_questa_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    cadence_xcelium_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    aldec_riviera_pro_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    default_simulator: Optional[str] = ""


class Synthesis(Model):
    root_path: constr(pattern=VALID_POSIX_PATH_REGEX)


class Linting(Model):
    root_path: constr(pattern=VALID_POSIX_PATH_REGEX)


class Ip(Model):
    global_paths: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []
    local_paths: [List[constr(pattern=VALID_POSIX_PATH_REGEX)]]


class Docs(Model):
    root_path: constr(pattern=VALID_POSIX_PATH_REGEX)


class Encryption(Model):
    metrics_dsim_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    xilinx_vivado_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    synopsys_vcs_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    siemens_questa_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    cadence_xcelium_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"
    aldec_riviera_pro_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = "UNDEFINED"


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

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from typing import List, Optional
from pydantic import BaseModel, constr, FilePath, PositiveInt
from .model import Model, VALID_NAME_REGEX, VALID_LOGIC_SIMULATION_TIMESCALE_REGEX, \
    VALID_POSIX_PATH_REGEX, VALID_POSIX_DIR_NAME_REGEX, UNDEFINED_CONST
from enum import Enum



class UvmVersions(Enum):
    V_1_2 = "1.2"
    V_1_1d = "1.1d"
    V_1_1c = "1.1c"
    V_1_1b = "1.1b"
    V_1_1a = "1.1a"
    V_1_0 = "1.0"


class LogicSimulators(Enum):
    UNDEFINED = "__UNDEFINED__"
    DSIM = "dsim"
    VIVADO = "vivado"
    VCS = "vcs"
    XCELIUM = "xcelium"
    QUESTA = "questa"
    RIVIERA = "riviera"

class DSimCloudComputeSizes(Enum):
    S4 = "s4"
    S8 = "s8"


class Project(Model):
    sync: bool
    sync_id: Optional[PositiveInt] = 0
    name: Optional[constr(pattern=VALID_NAME_REGEX)] = UNDEFINED_CONST
    full_name: Optional[str] = UNDEFINED_CONST
    local_mode: bool


class Authentication(Model):
    offline: bool


class LogicSimulation(Model):
    root_path: constr(pattern=VALID_POSIX_PATH_REGEX)
    regression_directory_name: constr(pattern=VALID_POSIX_DIR_NAME_REGEX)
    results_directory_name: constr(pattern=VALID_POSIX_DIR_NAME_REGEX)
    logs_directory: constr(pattern=VALID_POSIX_DIR_NAME_REGEX)
    test_result_path_template: str
    uvm_version: UvmVersions
    timescale: constr(pattern=VALID_LOGIC_SIMULATION_TIMESCALE_REGEX)
    metrics_dsim_license_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    metrics_dsim_cloud_max_compute_size: Optional[DSimCloudComputeSizes] = DSimCloudComputeSizes.S4
    metrics_dsim_installation_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    xilinx_vivado_installation_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    synopsys_vcs_installation_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    siemens_questa_installation_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    cadence_xcelium_installation_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    aldec_riviera_pro_installation_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    metrics_dsim_default_compilation_sv_arguments: List[str] = []
    xilinx_vivado_default_compilation_sv_arguments: List[str] = []
    synopsys_vcs_default_compilation_sv_arguments: List[str] = []
    siemens_questa_default_compilation_sv_arguments: List[str] = []
    cadence_xcelium_default_compilation_sv_arguments: List[str] = []
    aldec_riviera_pro_default_compilation_sv_arguments: List[str] = []
    metrics_dsim_default_compilation_vhdl_arguments: List[str] = []
    xilinx_vivado_default_compilation_vhdl_arguments: List[str] = []
    synopsys_vcs_default_compilation_vhdl_arguments: List[str] = []
    siemens_questa_default_compilation_vhdl_arguments: List[str] = []
    cadence_xcelium_default_compilation_vhdl_arguments: List[str] = []
    aldec_riviera_pro_default_compilation_vhdl_arguments: List[str] = []
    metrics_dsim_default_elaboration_arguments: List[str] = []
    xilinx_vivado_default_elaboration_arguments: List[str] = []
    synopsys_vcs_default_elaboration_arguments: List[str] = []
    siemens_questa_default_elaboration_arguments: List[str] = []
    cadence_xcelium_default_elaboration_arguments: List[str] = []
    aldec_riviera_pro_default_elaboration_arguments: List[str] = []
    metrics_dsim_default_compilation_and_elaboration_arguments: List[str] = []
    xilinx_vivado_default_compilation_and_elaboration_arguments: List[str] = []
    synopsys_vcs_default_compilation_and_elaboration_arguments: List[str] = []
    siemens_questa_default_compilation_and_elaboration_arguments: List[str] = []
    cadence_xcelium_default_compilation_and_elaboration_arguments: List[str] = []
    aldec_riviera_pro_default_compilation_and_elaboration_arguments: List[str] = []
    metrics_dsim_default_simulation_arguments: List[str] = []
    xilinx_vivado_default_simulation_arguments: List[str] = []
    synopsys_vcs_default_simulation_arguments: List[str] = []
    siemens_questa_default_simulation_arguments: List[str] = []
    cadence_xcelium_default_simulation_arguments: List[str] = []
    aldec_riviera_pro_default_simulation_arguments: List[str] = []
    default_simulator: Optional[LogicSimulators] = LogicSimulators.UNDEFINED


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
    metrics_dsim_sv_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    metrics_dsim_vhdl_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    xilinx_vivado_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    synopsys_vcs_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    siemens_questa_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    cadence_xcelium_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    aldec_riviera_pro_key_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST


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
    authentication: Authentication

    def check(self):
        pass

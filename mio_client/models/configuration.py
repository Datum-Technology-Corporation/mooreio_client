# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import Jinja2
import toml
from pydantic import BaseModel, constr
from mio_client.core.model import FileModel, Model
from pathlib import Path
from pydantic import DirectoryPath
import semantic_version


class ProjectConfiguration(Model):
    is_synced: bool
    catalog_id: int
    name: constr(regex=r'^[\w_]+$', strip_whitespace=True)
    full_name: str


class SimulationConfiguration(Model):
    root_path: Path
    regression_directory: DirectoryPath
    results_directory: DirectoryPath
    logs_directory: DirectoryPath
    test_result_path_template: Jinja2.Template
    uvm_version: semantic_version.Version


class Configuration(FileModel):
    """
    Model for mio.toml configuration files.
    """
    project: ProjectConfiguration
    simulation: SimulationConfiguration

    @classmethod
    def load(cls, file_path):
        with open(file_path, 'r') as f:
            data = toml.load(f)
            return cls(**data)

    def to_toml(self):
        return toml.dumps(self.dump_model())

    def check(self):
        pass


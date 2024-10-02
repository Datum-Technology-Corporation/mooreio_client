# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import toml
from pydantic import BaseModel
from mio_client.core.model import FileModel


class ProjectConfiguration(BaseModel):
    is_synced: bool
    catalog_id: int
    name: str
    full_name: str


class Configuration(FileModel):
    """
    Model for mio.toml configuration files.
    """
    project: ProjectConfiguration

    @classmethod
    def load(cls, file_path):
        with open(file_path, 'r') as f:
            data = toml.load(f)
            return cls(**data)

    def to_toml(self):
        return toml.dumps(self.dump_model())

    def check(self):
        pass


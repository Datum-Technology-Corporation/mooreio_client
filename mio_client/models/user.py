# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import yaml
from pydantic import BaseModel, Field, ValidationError
from mio_client.core.model import FileModel


class User(FileModel):
    authenticated: bool
    username: str
    token: str

    @classmethod
    def load(cls, file_path):
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)
            return cls(**data)

    def to_yaml(self):
        return yaml.dump(self.model_dump())


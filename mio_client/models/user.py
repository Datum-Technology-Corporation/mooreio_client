# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from typing import Optional

import yaml
from pydantic import BaseModel, Field, ValidationError, constr
from mio_client.core.model import Model, VALID_NAME_REGEX


class User(Model):
    authenticated: bool
    username: constr(regex=VALID_NAME_REGEX)
    token: Optional[str]

    @classmethod
    def load(cls, file_path):
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)
            return cls(**data)

    def to_yaml(self):
        return yaml.dump(self.model_dump())


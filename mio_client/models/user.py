# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from typing import Optional

import yaml
from pydantic import BaseModel, Field, ValidationError, constr
from mio_client.core.model import Model, VALID_NAME_REGEX


class User(Model):
    def __init__(self, **data):
        super().__init__(**data)
        self._use_pre_set_username = False
        self._pre_set_username = ""
        self._use_pre_set_password = False
        self._pre_set_password = ""
    authenticated: bool
    username: Optional[constr(pattern=VALID_NAME_REGEX)] = "anonymous"
    access_token: Optional[str] = ""
    refresh_token: Optional[str] = ""

    @classmethod
    def load(cls, file_path):
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)
            return cls(**data)

    def to_yaml(self):
        return yaml.dump(self.model_dump())

    @property
    def pre_set_username(self):
        return self._pre_set_username
    @pre_set_username.setter
    def pre_set_username(self, value):
        self._use_pre_set_username = True
        self._pre_set_username = value

    @property
    def pre_set_password(self):
        return self._pre_set_password
    @pre_set_password.setter
    def pre_set_password(self, value):
        self._use_pre_set_password = True
        self._pre_set_password = value

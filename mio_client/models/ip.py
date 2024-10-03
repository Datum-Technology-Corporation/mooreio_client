# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import yaml
from pydantic import BaseModel
from mio_client.core.model import FileModel
from mio_client.core.root import RootManager


class Ip(FileModel):
    is_synced: bool
    catalog_id: int

    def __init__(self, rmh, path, is_local):
        super().__init__(rmh, path)
        self._isLocal = is_local

    @classmethod
    def load(cls, rmh, path):
        with open(path, 'r') as f:
            data = yaml.safe_load(f)
            return cls(**data)

    def save(self):
        pass

    def load_from_web(self):
        pass

    def load_from_yaml(self):
        pass

    def save_to_yaml(self):
        return yaml.dump(self.model_dump())


class IpDependency(BaseModel):
    pass


class IpDataBase():
    def __init__(self, rmh: RootManager):
        self._rmh = rmh
        self._ip_list = []

    def add_ip(self, ip: Ip):
        self._ip_list.append(ip)

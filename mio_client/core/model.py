# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from pydantic import BaseModel, Field, ValidationError


class Model(BaseModel):
    pass

class FileModel(BaseModel):
    """
    Base model class.
    """
    def __init__(self, rmh, path):
        super().__init__()
        self._rmh = rmh
        self._path = path

    @property
    def rmh(self):
        """
        Read-only property for the Root Manager Handle.
        :return: The root handle
        """
        return self._rmh

    @property
    def path(self):
        """
        Read-only property for the file path for this model.
        :return: The root handle
        """
        return self._path

    @classmethod
    def load(cls, rmh, path):
        """
        Loads model data from disk/web/etc.
        This method is a placeholder and must be implemented by subclasses.
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")
    
    
    def save(self):
        """
        Save model data to disk/web/etc.
        This method is a placeholder and must be implemented by subclasses.
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import base64
import os
import tarfile
from datetime import datetime
from http import HTTPMethod
from io import BytesIO
from pathlib import Path
from typing import Optional, List, Union

import jinja2
import yaml
from pydantic import BaseModel, AnyUrl, constr, FilePath, PositiveInt, ValidationError
from pydantic import DirectoryPath
from pydantic_extra_types import semantic_version
from semantic_version import Spec, SimpleSpec, Version

from mio_client.core.model import Model, VALID_NAME_REGEX, VALID_IP_OWNER_NAME_REGEX, VALID_FSOC_NAMESPACE_REGEX, \
    VALID_POSIX_DIR_NAME_REGEX, VALID_POSIX_PATH_REGEX, UNDEFINED_CONST
#from mio_client.core.root import RootManager

from enum import Enum

#from mio_client.core.root import RootManager
from mio_client.core.version import SemanticVersion, SemanticVersionSpec
from mio_client.models.configuration import Ip


class IpType(Enum):
    DV_LIBRARY = "dv_lib"
    DV_AGENT = "dv_agent"
    DV_ENV = "dv_env"
    DV_TB = "dv_tb"
    LIBRARY = "lib"
    BLOCK = "block"
    SS = "ss"
    FPGA = "fpga"
    CHIP = "chip"
    SYSTEM = "system"
    CUSTOM = "custom"

class DutType(Enum):
    MIO_IP = "ip"
    FUSE_SOC = "fsoc"
    VIVADO = "vivado"

class ParameterType(Enum):
    INT = "int"
    BOOL = "bool"

class IpLocationType(Enum):
    PROJECT_USER = "local"
    PROJECT_INSTALLED = "installed"
    GLOBAL = "global"

class IpLicenseType(Enum):
    PUBLIC_OPEN_SOURCE = "public_open_source"
    COMMERCIAL = "commercial"



class IpDefinition:
    owner_name_is_specified: bool = False
    owner_name: str = ""
    ip_name: str = ""
    version_spec: SimpleSpec
    online_id: int
    
    def __str__(self):
        if self.owner_name_is_specified:
            return f"{self.owner_name}/{self.ip_name}"
        else:
            return self.ip_name
        

class IpPublishingConfirmation(Model):
    success: bool
    certificator: str
    timestamp: datetime
    license_type: IpLicenseType


class IpPublishingCertificate(Model):
    granted: bool
    certificator: str
    timestamp: datetime
    license_type: IpLicenseType
    id: int
    license_key: Optional[str] = UNDEFINED_CONST
    client: Optional[str] = UNDEFINED_CONST
    _tgz_file_path: Path

    @property
    def tgz_file_path(self) -> Path:
        return self._tgz_file_path
    @tgz_file_path.setter
    def tgz_file_path(self, value: Path):
        self._tgz_file_path = Path(value)


class Structure(Model):
    scripts_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    docs_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    examples_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    src_path: constr(pattern=VALID_POSIX_PATH_REGEX)


class HdlSource(Model):
    directories: List[constr(pattern=VALID_POSIX_PATH_REGEX)]
    top_sv_files: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []
    top_vhdl_files: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []
    top: Optional[List[constr(pattern=VALID_NAME_REGEX)]] = []
    tests_path: Optional[constr(pattern=VALID_POSIX_PATH_REGEX)] = UNDEFINED_CONST
    tests_name_template: Optional[jinja2.Template] = UNDEFINED_CONST
    so_libs: Optional[List[constr(pattern=VALID_POSIX_PATH_REGEX)]] = []


class DesignUnderTest(Model):
    type: DutType
    name: Union[constr(pattern=VALID_NAME_REGEX), constr(pattern=VALID_FSOC_NAMESPACE_REGEX)] = UNDEFINED_CONST
    version: Optional[SemanticVersionSpec] = SemanticVersionSpec()
    target: Optional[constr(pattern=VALID_NAME_REGEX)] = UNDEFINED_CONST


class Parameter(Model):
    type: ParameterType
    min: Optional[int] = 0
    max: Optional[int] = 0
    default: Union[int, bool]


class Target(Model):
    cmp: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[PositiveInt, bool]]] = {}
    elab: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[PositiveInt, bool]]] = {}
    sim: Optional[dict[constr(pattern=VALID_NAME_REGEX), Union[PositiveInt, bool]]] = {}



class About(Model):
    sync: bool
    sync_id: Optional[PositiveInt] = 0
    sync_revision: Optional[str] = UNDEFINED_CONST
    encrypted: Optional[bool] = False
    mlicensed: Optional[bool] = False
    type: IpType
    vendor: str
    name: constr(pattern=VALID_NAME_REGEX)
    full_name: str
    version: SemanticVersion

class Ip(Model):
    _uid: int
    _rmh: 'RootManager' = None
    _file_path: Path = None
    _location_type: IpLocationType
    _file_path_set: bool = False
    _root_path: Path = None
    _resolved_src_path: Path = None
    _resolved_docs_path: Path = None
    _resolved_scripts_path: Path = None
    _resolved_examples_path: Path = None
    _has_docs: bool = False
    _has_scripts: bool = False
    _has_examples: bool = False
    _resolved_top_sv_files: List[Path] = []
    _resolved_top_vhdl_files: List[Path] = []
    _resolved_top: List[str] = []
    _resolved_dependencies: dict[IpDefinition, Ip] = {}
    _dependencies_to_find_online: List[IpDefinition] = []
    _dependencies_resolved: bool = False
    
    ip: About
    dependencies: Optional[dict[constr(pattern=VALID_IP_OWNER_NAME_REGEX), SemanticVersionSpec]] = {}
    structure: Structure
    hdl_src: HdlSource
    dut: Optional[DesignUnderTest] = None
    targets: Optional[dict[constr(pattern=VALID_NAME_REGEX), Target]] = {}

    def __str__(self):
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor} {self.ip.name} v{self.ip.version}"
        else:
            return f"{self.ip.name} v{self.ip.version}"

    @property
    def archive_name(self):
        if self.ip.vendor != UNDEFINED_CONST:
            return f"{self.ip.vendor}__{self.ip.name}__v{self.ip.version}"
        else:
            return f"{self.ip.name}__v{self.ip.version}"

    @staticmethod
    def parse_ip_definition(definition: str) -> IpDefinition:
        ip_definition = IpDefinition()
        slash_split = definition.split("/")
        if len(slash_split) == 1:
            ip_definition.owner_name_is_specified = False
            ip_definition.ip_name = slash_split[0].strip().lower()
        elif len(slash_split) == 2:
            ip_definition.owner_name_is_specified = True
            ip_definition.owner_name = slash_split[0].strip().lower()
            ip_definition.ip_name = slash_split[1].strip().lower()
        else:
            raise Exception(f"Invalid IP definition: {definition}")
        return ip_definition

    @classmethod
    def load(cls, file_path):
        with open(file_path, 'r') as f:
            data = yaml.safe_load(f)
            if data is None:
                data = {}
            instance = cls(**data)
            instance.file_path = file_path
            return instance

    @property
    def uid(self) -> int:
        return self._uid
    @uid.setter
    def uid(self, value: int):
        self._uid = value

    @property
    def has_owner(self) -> bool:
        return self.ip.vendor != UNDEFINED_CONST
    
    @property
    def rmh(self) -> 'RootManager':
        return self._rmh
    @rmh.setter
    def rmh(self, value: 'RootManager'):
        self._rmh = value
    
    @property
    def file_path(self) -> Path:
        return self._file_path
    @file_path.setter
    def file_path(self, value: str):
        self._file_path_set = True
        self._file_path = Path(value)
        self._root_path = self._file_path.parent

    @property
    def location_type(self) -> IpLocationType:
        return self._location_type
    @location_type.setter
    def location_type(self, value: IpLocationType):
        self._location_type = value

    @property
    def root_path(self) -> Path:
        return self._root_path
    
    @property
    def resolved_src_path(self) -> Path:
        return self._resolved_src_path
    
    @property
    def resolved_docs_path(self) -> Path:
        return self._resolved_docs_path
    
    @property
    def resolved_scripts_path(self) -> Path:
        return self._resolved_scripts_path
    
    @property
    def resolved_examples_path(self) -> Path:
        return self._resolved_examples_path
    
    @property
    def has_docs(self) -> bool:
        return self._has_docs
    
    @property
    def has_scripts(self) -> bool:
        return self._has_scripts
    
    @property
    def has_examples(self) -> bool:
        return self._has_examples

    @property
    def dependencies_resolved(self) -> bool:
        return self._dependencies_resolved
    @dependencies_resolved.setter
    def dependencies_resolved(self, value: bool):
        self._dependencies_resolved = value
    
    def check(self):
        self._resolved_src_path = self.root_path / self.structure.src_path
        self.rmh.directory_exists(self.resolved_src_path)
        if self.structure.scripts_path != UNDEFINED_CONST:
            self._has_scripts = True
            self._resolved_scripts_path = self.root_path / self.structure.scripts_path
            self.rmh.directory_exists(self._resolved_scripts_path)
        if self.structure.docs_path != UNDEFINED_CONST:
            self._has_docs = True
            self._resolved_docs_path = self.root_path / self.structure.docs_path
            self.rmh.directory_exists(self.resolved_docs_path)
        if self.structure.examples_path != UNDEFINED_CONST:
            self._has_examples = True
            self._resolved_examples_path = self.root_path / self.structure.examples_path
            self.rmh.directory_exists(self.resolved_examples_path)
        for directory in self.hdl_src.directories:
            self.rmh.directory_exists(self.root_path / directory)
        for file in self.hdl_src.top_sv_files:
            full_path = self.root_path / file
            self.rmh.file_exists(full_path)
            self._resolved_top_sv_files.append(full_path)
        for file in self.hdl_src.top_vhdl_files:
            full_path = self.root_path / file
            self.rmh.file_exists(full_path)
            self._resolved_top_vhdl_files.append(full_path)
        if self.hdl_src.tests_path != UNDEFINED_CONST:
            self.rmh.directory_exists(self.root_path / self.hdl_src.tests_path)

    def add_resolved_dependency(self, ip_definition:IpDefinition, ip:Ip):
        self._resolved_dependencies[ip_definition] = ip
        if len(self._resolved_dependencies) == len(self.dependencies):
            self.dependencies_resolved = True
        else:
            self.dependencies_resolved = False
    
    def add_dependency_to_find_on_remote(self, ip_definition: IpDefinition):
        self._dependencies_to_find_online.append(ip_definition)
    
    def get_dependencies_to_find_on_remote(self) -> List[IpDefinition]:
        return self._dependencies_to_find_online
    
    def create_unencrypted_compressed_tarball(self) -> Path:
        try:
            tgz_file_path = self.rmh.md / f"temp/{self.archive_name}.tgz"
            with tarfile.open(tgz_file_path, "w:gz") as tar:
                tar.add(self.file_path, arcname=self.file_path.name)
                tar.add(self.resolved_src_path, arcname=self.resolved_src_path.name)
                if self.has_docs:
                    tar.add(self.resolved_docs_path, arcname=self.resolved_docs_path.name)
                if self.has_examples:
                    tar.add(self.resolved_examples_path, arcname=self.resolved_examples_path.name)
                if self.has_scripts:
                    tar.add(self.resolved_scripts_path, arcname=self.resolved_scripts_path.name)
        except Exception as e:
            raise Exception(f"Failed to create unencrypted compressed tarball for {self}: {e}")
        return tgz_file_path


class IpDataBase():
    _ip_list: list[Ip] = []
    _rmh: 'RootManager' = None
    _need_to_find_dependencies_on_remote: bool = False
    _ip_with_missing_dependencies: dict[int, Ip] = {}
    _ip_definitions_to_be_installed: list[IpDefinition] = []
    
    def __init__(self, rmh: 'RootManager'):
        self._rmh = rmh

    def add_ip(self, ip: Ip):
        self._ip_list.append(ip)
    
    @property
    def rmh(self) -> 'RootManager':
        return self._rmh

    @property
    def has_ip(self) -> bool:
        return len(self._ip_list) > 0

    @property
    def num_ips(self) -> int:
        return len(self._ip_list)

    @property
    def need_to_find_dependencies_on_remote(self) -> bool:
        return self._need_to_find_dependencies_on_remote

    @property
    def ip_definitions_to_be_installed(self) -> list[IpDefinition]:
        return self._ip_definitions_to_be_installed

    def get_all_ip(self) -> list[Ip]:
        return self._ip_list

    def find_ip_definition(self, definition:IpDefinition, raise_exception_if_not_found:bool=True) -> Ip:
        if definition.owner_name_is_specified:
            return self.find_ip(definition.ip_name, definition.owner_name, definition.version_spec, raise_exception_if_not_found)
        else:
            return self.find_ip(definition.ip_name, "*", definition.version_spec, raise_exception_if_not_found)

    def find_ip(self, name:str, owner:str="*", version:SimpleSpec=SimpleSpec("*"), raise_exception_if_not_found:bool=True) -> Ip:
        for ip in self._ip_list:
            if ip.ip.name == name and (owner == "*" or ip.ip.vendor == owner) and version.match(ip.ip.version):
                return ip
        if raise_exception_if_not_found:
            raise ValueError(f"IP with name '{name}', owner '{owner}', version '{version}' not found.")

    def discover_ip(self, path: Path, ip_location_type: IpLocationType, error_on_malformed:bool=False, error_on_nothing_found:bool=False) -> list[Ip]:
        ip_list: list[Ip] = []
        ip_files: list[str] = []
        for root, dirs, files in os.walk(path):
            for file in files:
                if file == 'ip.yml':
                    ip_files.append(os.path.join(root, file))
        if len(ip_files) == 0:
            if error_on_nothing_found:
                raise Exception(f"No 'ip.yml' files found in the '{ip_location_type}' directory.")
        else:
            for file in ip_files:
                try:
                    ip_model = Ip.load(file)
                    if ip_model.ip.vendor == UNDEFINED_CONST:
                        if self.find_ip(ip_model.ip.name, "*", SimpleSpec(str(ip_model.ip.version)), raise_exception_if_not_found=False):
                            continue
                    else:
                        if self.find_ip(ip_model.ip.name, ip_model.ip.vendor, SimpleSpec(str(ip_model.ip.version)), raise_exception_if_not_found=False):
                            continue
                    ip_model.rmh = self.rmh
                    ip_model.file_path = file
                    ip_model.uid = self.num_ips
                    ip_model.location_type = ip_location_type
                    ip_model.check()
                except ValidationError as e:
                    errors = e.errors()
                    error_messages = "\n  ".join([f"{error['msg']}: {error['loc']}" for error in errors])
                    if error_on_malformed:
                        raise Exception(f"IP definition at '{file}' is malformed: {error_messages}")
                    else:
                        print(f"Skipping IP definition at '{file}': {error_messages}")
                else:
                    self.add_ip(ip_model)
                    ip_list.append(ip_model)
        return ip_list

    def resolve_local_dependencies(self):
        self._dependencies_to_find_online = []
        for ip in self._ip_list:
            for ip_definition_str, ip_version_spec in ip.dependencies.items():
                if not ip.dependencies_resolved:
                    ip_definition = Ip.parse_ip_definition(ip_definition_str)
                    ip_definition.version_spec = ip_version_spec
                    ip_dependency = self.find_ip_definition(ip_definition, raise_exception_if_not_found=False)
                    if ip_dependency is None:
                        ip.add_dependency_to_find_on_remote(ip_definition)
                        self._need_to_find_dependencies_on_remote = True
                        self._ip_with_missing_dependencies[ip.uid] = ip
                    else:
                        ip.add_resolved_dependency(ip_definition, ip_dependency)
    
    def find_missing_dependencies_on_remote(self):
        ip_definitions_not_found = []
        for ip_uid in self._ip_with_missing_dependencies:
            ip = self._ip_with_missing_dependencies[ip_uid]
            for ip_definition in ip.get_dependencies_to_find_on_remote():
                if self.ip_definition_is_available_on_remote(ip_definition):
                    self._ip_definitions_to_be_installed.append(ip_definition)
                else:
                    print(f"Could not find IP '{ip.ip.full_name}' dependency '{ip_definition}' on the Moore.io Server")
                    ip_definitions_not_found.append(ip_definition)
        if len(ip_definitions_not_found) > 0:
            raise Exception(f"Could not resolve all dependencies for the following IP: {ip_definitions_not_found}")

    def ip_definition_is_available_on_remote(self, ip_definition: IpDefinition) -> bool:
        if ip_definition.owner_name_is_specified:
            owner = ip_definition.owner_name
        else:
            owner = "*"
        request = {
            "name": ip_definition.ip_name,
            "owner": owner,
            "version_spec": ip_definition.version_spec
        }
        response = self.rmh.web_api_call(HTTPMethod.POST, "find_ip", request)
        try:
            if response['exists'] == True:
                found_ip = True
            else:
                found_ip = False
        except:
            found_ip = False
        if found_ip:
            ip_definition.online_id = int(response['id'])
        return found_ip

    def install_all_missing_ip_from_remote(self):
        ip_definitions_that_failed_to_install: list[IpDefinition] = []
        for ip_definition in self._ip_definitions_to_be_installed:
            if not self.install_ip_from_remote(ip_definition):
                ip_definitions_that_failed_to_install.append(ip_definition)
        number_of_failed_installations = len(ip_definitions_that_failed_to_install)
        if number_of_failed_installations > 0:
            raise Exception(f"Failed to install {number_of_failed_installations} IPs from remote: {e}")
    
    def install_ip_from_remote(self, ip_definition: IpDefinition):
        try:
            response = self.rmh.web_api_call(HTTPMethod.POST, "get_ip", {"id": ip_definition.online_id})
            b64encoded_data = response['payload']
            data = base64.b64decode(b64encoded_data)
            path_installation = self.rmh.locally_installed_ip_dir / response['fully_qualified_name']
            self.rmh.create_directory(path_installation)
            with tarfile.open(fileobj=BytesIO(data), mode='r:gz') as tar:
                tar.extractall(path=path_installation)
        except Exception as e:
            return False
        else:
            return True
    
    def publish_new_version_to_remote(self, ip:Ip, client:str="public") -> IpPublishingCertificate:
        certificate = self.get_publishing_certificate(ip, client)
        if not certificate.granted:
            raise Exception(f"IP {ip} is not available for publishing")
        else:
            # TODO Implement encrypted IP publishing
            # if certification.license_type == IpLicenseType.COMMERCIAL:
            tgz_path = ip.create_unencrypted_compressed_tarball()
            certificate.tgz_file_path = tgz_path
            try:
                with open(tgz_path,'rb') as f:
                    tgz_b64_encoded = base64.b64encode(f.read())
            except Exception as e:
                raise Exception(f"Failed to encode IP {ip} compressed tarball: {e}")
            else:
                data = {
                    'id' : ip.ip.sync_id,
                    'payload' : str(tgz_b64_encoded),
                }
                try:
                    response = self.rmh.web_api_call(HTTPMethod.POST, 'publish_ip/payload', data)
                    confirmation = IpPublishingConfirmation.model_validate(response)
                    if not confirmation.success:
                        raise Exception(f"Failed to push IP payload to remote for '{ip}'")
                except Exception as e:
                    raise Exception(f"Failed to push IP payload to remote for '{ip}': {e}")
        return certificate
    
    def get_publishing_certificate(self, ip: Ip, client:str= "public") -> IpPublishingCertificate:
        request = {
            'vendor': ip.ip.vendor,
            "ip_name": ip.ip.name,
            "ip_id": ip.ip.sync_id,
            "ip_version": ip.ip.version,
            "client": client
        }
        try:
            response = self.rmh.web_api_call(HTTPMethod.POST, "publish_ip/certificate", request)
            certificate = IpPublishingCertificate.model_validate(response)
        except Exception as e:
            raise Exception(f"Failed to obtain certificate from remote for publishing IP {ip}: {e}")
        else:
            return certificate

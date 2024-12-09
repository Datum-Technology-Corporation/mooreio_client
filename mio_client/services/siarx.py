# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import base64
import os.path
import tarfile
from abc import ABC
from enum import Enum, auto
from http import HTTPMethod
from io import BytesIO
from pathlib import Path
from typing import Optional, List, Dict

from semantic_version import Version

from mio_client.core.scheduler import JobScheduler, Job, JobSchedulerConfiguration
from mio_client.core.service import Service, ServiceType
from mio_client.core.ip import Ip
from mio_client.core.model import Model


#######################################################################################################################
# API Entry Point
#######################################################################################################################
def get_services():
    return [SiArxService]


#######################################################################################################################
# Support Classes
#######################################################################################################################
class SiArxMode(Enum):
    NEW_PROJECT = "Initialize new Project"
    UPDATE_PROJECT = "Update existing Project"

class SiArxConfiguration(Model):
    input_path: Path = Path()
    mode: SiArxMode
    force_update: bool
    project_id: str

class SiArxReport(Model):
    success: Optional[bool] = False
    infos: Optional[List[str]] = []
    warnings: Optional[List[str]] = []
    errors: Optional[List[str]] = []
    output_path: Optional[Path] = Path()

    def infos_report(self) -> List[str]:
        return {}

    def warnings_report(self) -> List[str]:
        return {}

    def error_report(self) -> List[str]:
        return {}

class SiArxResponseFile(Model):
    name: str
    path: str
    replace_user_file: bool

class SiArxResponsePackage(Model):
    name: str
    infos: Optional[List[str]] = []
    warnings: Optional[List[str]] = []
    errors: Optional[List[str]] = []
    payload: Optional[str] = ""
    path: Optional[Path] = Path()
    files: Optional[List[SiArxResponseFile]] = []

class SiArxResponseIp(Model):
    sync_id: str
    name: str
    infos: Optional[List[str]] = []
    warnings: Optional[List[str]] = []
    errors: Optional[List[str]] = []
    packages: Optional[List[SiArxResponsePackage]] = []

    def info_report(self) -> List[str]:
        all_infos: List[str] = []
        for package in self.packages:
            all_infos += package.infos
        return all_infos

    def warning_report(self) -> List[str]:
        all_warnings: List[str] = []
        for package in self.packages:
            all_warnings += package.warnings
        return all_warnings

    def error_report(self) -> List[str]:
        all_errors: List[str] = []
        for package in self.packages:
            all_errors += package.errors
        return all_errors

class SiArxResponse(Model):
    success: bool
    job_id: Optional[str] = ""
    project_id: Optional[str] = ""
    infos: Optional[List[str]] = []
    warnings: Optional[List[str]] = []
    errors: Optional[List[str]] = []
    ips: Optional[List[SiArxResponseIp]] = []
    project_files_payload: Optional[str] = ""
    files: Optional[List[SiArxResponseFile]] = []

    def info_report(self) -> List[str]:
        all_infos: List[str] = []
        for ip in self.ips:
            all_infos += ip.info_report()
        return all_infos

    def warning_report(self) -> List[str]:
        all_warnings: List[str] = []
        for ip in self.ips:
            all_warnings += ip.warning_report()
        return all_warnings

    def error_report(self) -> List[str]:
        all_errors: List[str] = []
        for ip in self.ips:
            all_errors += ip.error_report()
        return all_errors


#######################################################################################################################
# Service
#######################################################################################################################
class SiArxService(Service):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, 'datum', 'siarx', 'SiArx')
        self._type = ServiceType.CODE_GENERATION

    def is_available(self) -> bool:
        return True

    def create_directory_structure(self):
        pass

    def create_files(self):
        pass

    def get_version(self) -> Version:
        return Version('1.0.0')

    def gen_project(self, configuration: SiArxConfiguration) -> SiArxReport:
        report = SiArxReport()
        report.output_path = configuration.input_path
        response: SiArxResponse
        try:
            data = {
                'project_id': configuration.project_id,
            }
            raw_response = self.rmh.web_api_call(HTTPMethod.POST, 'siarx/gen', data)
            response = SiArxResponse.model_validate(raw_response.json())
        except Exception as e:
            report.success = False
            report.errors.append(f"SiArx failed to generate response for Project '{configuration.project_id}': {e}")
            return report
        else:
            report.infos = response.info_report()
            report.warnings = response.warning_report()
            report.errors = response.error_report()
            report.success = response.success
            if response.success:
                try:
                    tgz_data = base64.b64decode(response.project_files_payload)
                    with tarfile.open(fileobj=BytesIO(tgz_data), mode='r:gz') as tar:
                        tar.extractall(path=configuration.input_path)
                except Exception as e:
                    report.success = False
                    report.errors.append(f"Failed to unpack Project files at path '{configuration.input_path}': {e}")
                else:
                    for ip in response.ips:
                        for package in ip.packages:
                            self.rmh.info(f"Processing IP {ip.name}/{package.name} ...")
                            extraction_path: Path = configuration.input_path / package.path
                            try:
                                tgz_data = base64.b64decode(package.payload)
                                with tarfile.open(fileobj=BytesIO(tgz_data), mode='r:gz') as tar:
                                    tar.extractall(path=extraction_path)
                            except Exception as e:
                                report.success = False
                                report.errors.append(f"Failed to unpack IP {ip.name}/{package.name} at path '{extraction_path}': {e}")
            return report





# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
import re
import sys
from abc import ABC, abstractmethod
from configparser import Error
from http import HTTPMethod
from pathlib import Path
from re import Match
from typing import List, Pattern

import requests
import toml
import yaml
from pydantic import ValidationError, BaseModel
import os
import getpass

from mio_client.core.phase import Phase
from mio_client.core.scheduler import LocalProcessScheduler, JobSchedulerDatabase
from mio_client.core.service import ServiceDataBase
from mio_client.models.configuration import Configuration
from mio_client.models.ip import IpDataBase, Ip
from mio_client.models.user import User
from mio_client.services.simulation import SimulatorMetricsDSim
from mio_client.models.command import Command


class PhaseEndProcessException(Exception):
    def __init__(self, message: str = ""):
        self.message = message
    def __str__(self):
        return self.message
    @property
    def message(self) -> str:
        return self._message
    @message.setter
    def message(self, message: str):
        self._message = message


#######################################################################################################################
# Abstract Class (Default (full) implementation later in this file)
#######################################################################################################################
class RootManager(ABC):
    """
    Abstract component which performs all vital tasks and executes phases.
    """
    def __init__(self, name: str, wd: Path, url_base: str, url_authentication: str):
        """
        Initialize an instance of the root.

        :param name: The name of the instance.
        :param wd: The working directory for the instance.
        :param url_base: URL of the Moore.io Server
        :param url_authentication: URL of the Moore.io Server Authentication API
        """
        self._name = name
        self._wd = wd
        self._md = self.wd / ".mio"
        self._url_base = url_base
        self._url_authentication = url_authentication
        self._url_api = f"{self._url_base}/api/"
        self._print_trace = False
        self._command = None
        self._install_path = None
        self._user_data_file_path = os.path.expanduser("~/.mio/user.yml")
        self._user = None
        self._project_root_path = None
        self._default_configuration_path = None
        self._user_configuration_path = None
        self._project_configuration_path = None
        self._default_configuration = {}
        self._user_configuration = {}
        self._project_configuration = {}
        self._cli_configuration = {}
        self._configuration = None
        self._scheduler_database = None
        self._service_database = None
        self._ip_database = None
        self._current_phase = None

    def __str__(self):
        """
        Returns a string representation of the object.

        :return: The name of the object as a string.
        """
        return self.name
    
    
    @property
    def name(self) -> str:
        """
        :return: The name of the Root. Read-only.
        :rtype: str
        """
        return self._name

    @property
    def wd(self):
        """
        :return: Working directory.
        """
        return self._wd

    @property
    def md(self):
        """
        :return: Moore.io work (hidden) directory.
        """
        return self._md

    @property
    def url_base(self):
        """
        :return: Moore.io Web Server URL.
        """
        return self._url_base

    @property
    def url_authentication(self):
        """
        :return: Moore.io Web Server Authentication URL.
        """
        return self._url_authentication

    @property
    def url_api(self):
        """
        :return: Moore.io Web Server API URL.
        """
        return self._url_api

    @property
    def print_trace(self) -> bool:
        """
        :return: Whether or not to print debug information
        """
        return self._print_trace
    @print_trace.setter
    def print_trace(self, value: bool):
        self._print_trace = value

    @property
    def command(self) -> Command:
        """
        :return: The command being executed.
        """
        return self._command

    @property
    def user(self) -> User:
        """
        :return: The User model.
        """
        return self._user

    @property
    def project_root_path(self) -> Path:
        """
        :return: The Project root path.
        """
        return self._project_root_path

    @property
    def default_configuration_path(self) -> Path:
        """
        :return: Path to default configuration file.
        """
        return self._default_configuration_path

    @property
    def user_configuration_path(self) -> Path:
        """
        :return: Path to User configuration file.
        """
        return self._user_configuration_path

    @property
    def project_configuration_path(self) -> Path:
        """
        :return: Path to Project configuration file.
        """
        return self._project_configuration_path

    @property
    def configuration(self) -> Configuration:
        """
        :return: The configuration space.
        """
        return self._configuration

    @property
    def scheduler_database(self) -> JobSchedulerDatabase:
        """
        :return: The task scheduler database.
        """
        return self._scheduler_database

    @property
    def service_database(self) -> ServiceDataBase:
        """
        :return: The Service database.
        """
        return self._service_database

    @property
    def ip_database(self) -> IpDataBase:
        """
        :return: The IP database.
        """
        return self._ip_database

    @property
    def current_phase(self) -> 'Phase':
        """
        :return: The current phase.
        """
        return self._current_phase
    
    def run(self, command: Command) -> int:
        """
        The `run` method is responsible for executing a series of phases to complete a command.

        :param command: The command to be executed.
        :return: None

        The `run` method starts by setting the provided command as the current command.
        Then it goes through the following steps in order:
        - phase_init
        - phase_load_default_configuration
        - phase_load_user_data
        - phase_authenticate
        - phase_save_user_data
        - phase_locate_project_file
        - phase_create_common_files_and_directories
        - phase_load_user_configuration
        - phase_load_project_configuration
        - phase_validate_configuration_space
        - phase_scheduler_discovery
        - phase_service_discovery
        - phase_ip_discovery
        - phase_main
        - phase_check
        - phase_report
        - phase_cleanup
        - phase_shutdown
        - phase_final
        """
        try:
            self.set_command(command)
            self.do_phase_init()
            self.do_phase_load_default_configuration()
            self.do_phase_load_user_data()
            self.do_phase_authenticate()
            self.do_phase_save_user_data()
            self.do_phase_locate_project_file()
            self.do_phase_create_common_files_and_directories()
            self.do_phase_load_project_configuration()
            self.do_phase_load_user_configuration()
            self.do_phase_validate_configuration_space()
            self.do_phase_scheduler_discovery()
            self.do_phase_service_discovery()
            self.do_phase_ip_discovery()
            self.do_phase_main()
            self.do_phase_check()
            self.do_phase_report()
            self.do_phase_cleanup()
            self.do_phase_shutdown()
            self.do_phase_final()
        except PhaseEndProcessException as e:
            if e.message != "":
                print(e.message)
            return 0
        except Exception as e:
            print(e, file=sys.stderr)
            return 1
        else:
            return 0
    
    def set_command(self, command):
        """
        Sets the command for the root.
        :param command: the command to be set as the root command
        :return: None
        """
        #if not issubclass(type(command), Command):
        #    raise TypeError("command must extend from class 'Command'")
        self._command = command()
        command.rmh = self
    
    def create_phase(self, name):
        """
        Creates a new phase with the given name.
        :param name: A string representing the name of the phase.
        :return: A `Phase` object representing the newly created phase.
        """
        self._current_phase = Phase(self, name)
        return self._current_phase
    
    def check_phase_finished(self, phase):
        """
        Check if a phase has finished properly.
        :param phase: The phase to be checked.
        :return: None.
        """
        if not phase.has_finished():
            if phase.error:
                raise RuntimeError(f"Phase '{phase} has encountered an error: {phase.error}")
            else:
                raise RuntimeError(f"Phase '{phase}' has not finished properly")
        if phase.end_process:
            raise PhaseEndProcessException(phase.end_process_message)
    
    def file_exists(self, path):
        """
        Check if a file exists at the specified path.
        :param path: Path to the file.
        :return: True if the file exists, False otherwise.
        :raises ValueError: if the path is None or empty.
        """
        if not path:
            raise ValueError("Path must not be None or empty")
        return os.path.isfile(path)
    
    def create_file(self, path):
        """
        Create a file at the specified path.
        :param path: The path where the file should be created.
        :return: None
        """
        try:
            directory = os.path.dirname(path)
            if directory and not os.path.exists(directory):
                os.makedirs(directory)
            with open(path, 'w') as file_handle:
                pass
        except OSError as e:
            print(f"An error occurred while creating file '{path}': {e}")

    def move_file(self, src, dst):
        """
        Move a file from src to dst.
        :param src: Path to the source file.
        :param dst: Path to the destination.
        """
        try:
            if not os.path.exists(src):
                raise FileNotFoundError(f"Source file '{src}' does not exist")
            os.rename(src, dst)
        except OSError as e:
            print(f"An error occurred while moving file from '{src}' to '{dst}': {e}")

    def copy_file(self, src, dst):
        """
        Copy a file from src to dst.
        :param src: Path to the source file.
        :param dst: Path to the destination.
        """
        try:
            if not os.path.exists(src):
                raise FileNotFoundError(f"Source file '{src}' does not exist")
            directory = os.path.dirname(dst)
            if directory and not os.path.exists(directory):
                os.makedirs(directory)
            import shutil
            shutil.copy2(src, dst)
        except OSError as e:
            print(f"An error occurred while copying file from '{src}' to '{dst}': {e}")

    def remove_file(self, path):
        """
        Remove a file at the specified path.
        :param path: Path to the file.
        """
        try:
            if not os.path.exists(path):
                raise FileNotFoundError(f"File '{path}' does not exist")
            os.remove(path)
        except OSError as e:
            print(f"An error occurred while removing file '{path}': {e}")

    def create_directory(self, path):
        """
        Create a directory at the specified path.
        :param path: Path to the directory.
        """
        try:
            if not os.path.exists(path):
                os.makedirs(path)
        except OSError as e:
            print(f"An error occurred while creating directory '{path}': {e}")

    def move_directory(self, src, dst):
        """
        Move a directory from src to dst.
        :param src: Path to the source directory.
        :param dst: Path to the destination.
        """
        try:
            if not os.path.exists(src):
                raise FileNotFoundError(f"Source directory '{src}' does not exist")
            os.rename(src, dst)
        except OSError as e:
            print(f"An error occurred while moving directory from '{src}' to '{dst}': {e}")

    def copy_directory(self, src, dst):
        """
        Copy a directory from src to dst.
        :param src: Path to the source directory.
        :param dst: Path to the destination.
        """
        try:
            if not os.path.exists(src):
                raise FileNotFoundError(f"Source directory '{src}' does not exist")
            directory = os.path.dirname(dst)
            if directory and not os.path.exists(directory):
                os.makedirs(directory)
            import shutil
            shutil.copytree(src, dst)
        except OSError as e:
            print(f"An error occurred while copying directory from '{src}' to '{dst}': {e}")

    def remove_directory(self, path):
        """
        Remove a directory at the specified path.
        :param path: Path to the directory.
        """
        try:
            if not os.path.exists(path):
                raise FileNotFoundError(f"Directory '{path}' does not exist")
            import shutil
            shutil.rmtree(path)
        except OSError as e:
            print(f"An error occurred while removing directory '{path}': {e}")

    def search_file_for_patterns(self, file_path: Path, patterns: List[str]) -> List[str]:
        """
        Searches a file at file_path for regular expressions in patterns.
        :param file_path: Path to file being searched
        :param patterns: List of patterns to be found
        :return: List of found strings
        """
        try:
            with open(file_path, 'r') as file_searched:
                file_content = file_searched.read()
            regex_patterns = []
            for pattern in patterns:
                regex_patterns.append(re.compile(pattern))
            return [match.group() for pattern in regex_patterns for match in pattern.finditer(file_content)]
        except OSError as e:
            print(f"An error occurred while searching file '{file_path}': {e}")
            return []

    def merge_dictionaries(self,d1: dict, d2: dict) -> dict:
        """
           Merge two dictionaries, d2 will overwrite d1 where keys overlap
        """
        for key, value in d2.items():
            if key in d1 and isinstance(d1[key], dict) and isinstance(value, dict):
                d1[key] = self.merge_dictionaries(d1[key], value)
            else:
                d1[key] = value
        return d1

    @abstractmethod
    def web_api_call(self, method: HTTPMethod, path: str, data: dict) -> dict:
        pass

    def do_phase_init(self):
        """
        Perform any steps necessary before real work begins.
        :return: None
        """
        current_phase = self.create_phase('init')
        current_phase.next()
        self.phase_init(current_phase)
        self.command.do_phase_init(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_load_default_configuration(self):
        """
        Load default configuration file from the package.
        :return: None
        """
        current_phase = self.create_phase('pre_load_default_configuration')
        current_phase.next()
        self.command.do_phase_pre_load_default_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('load_default_configuration')
        current_phase.next()
        self.phase_load_default_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_load_default_configuration')
        current_phase.next()
        self.command.do_phase_post_load_default_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_load_user_data(self):
        """
        Load user data from disk.
        :return: None
        """
        current_phase = self.create_phase('pre_load_user_data')
        current_phase.next()
        self.command.do_phase_pre_load_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('load_user_data')
        current_phase.next()
        self.phase_load_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_load_user_data')
        current_phase.next()
        self.command.do_phase_post_load_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_authenticate(self):
        """
        Authenticate the user with mio_web if necessary.
        :return: None
        """
        current_phase = self.create_phase('pre_authenticate')
        current_phase.next()
        self.command.do_phase_pre_authenticate(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('authenticate')
        current_phase.next()
        if self._command.needs_authentication():
            self.phase_authenticate(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_authenticate')
        current_phase.next()
        self.command.do_phase_post_authenticate(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_save_user_data(self):
        """
        Write user data to disk.
        :return: None
        """
        current_phase = self.create_phase('pre_save_user_data')
        current_phase.next()
        self.command.do_phase_pre_save_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('save_user_data')
        current_phase.next()
        self.phase_save_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_save_user_data')
        current_phase.next()
        self.command.do_phase_post_save_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_locate_project_file(self):
        """
        Locate the project file (`mio.toml`).
        :return: None
        """
        current_phase = self.create_phase('pre_locate_project_file')
        current_phase.next()
        self.command.do_phase_pre_locate_project_file(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('locate_project_file')
        current_phase.next()
        self.phase_locate_project_file(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_locate_project_file')
        current_phase.next()
        self.command.do_phase_post_locate_project_file(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_create_common_files_and_directories(self):
        """
        Create files and directories needed for proper Moore.io Client and command operation.
        :return: None
        """
        current_phase = self.create_phase('pre_create_common_files_and_directories')
        current_phase.next()
        self.command.do_phase_pre_create_common_files_and_directories(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('create_common_files_and_directories')
        current_phase.next()
        self.phase_create_common_files_and_directories(current_phase)
        self.command.do_phase_create_common_files_and_directories(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_create_common_files_and_directories')
        current_phase.next()
        self.command.do_phase_post_create_common_files_and_directories(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_load_project_configuration(self):
        """
        Load project configuration space from disk.
        :return: None
        """
        current_phase = self.create_phase('pre_load_project_configuration')
        current_phase.next()
        self.command.do_phase_pre_load_project_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('load_project_configuration')
        current_phase.next()
        self.phase_load_project_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_load_project_configuration')
        current_phase.next()
        self.command.do_phase_post_load_project_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_load_user_configuration(self):
        """
        Load user configuration space from disk.
        :return: None
        """
        current_phase = self.create_phase('pre_load_user_configuration')
        current_phase.next()
        self.command.do_phase_pre_load_user_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('load_user_configuration')
        current_phase.next()
        self.phase_load_user_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_load_user_configuration')
        current_phase.next()
        self.command.do_phase_post_load_user_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_validate_configuration_space(self):
        """
        Merge & validate the configuration space.
        :return: None
        """
        current_phase = self.create_phase('pre_validate_configuration_space')
        current_phase.next()
        self.command.do_phase_pre_validate_configuration_space(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('validate_configuration_space')
        current_phase.next()
        self.phase_validate_configuration_space(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_validate_configuration_space')
        current_phase.next()
        self.command.do_phase_post_validate_configuration_space(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_scheduler_discovery(self):
        """
        Creates and registers task schedulers as described in configuration space.
        :return: None.
        """
        current_phase = self.create_phase('pre_scheduler_discovery')
        current_phase.next()
        self.command.do_phase_pre_scheduler_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('scheduler_discovery')
        current_phase.next()
        self.phase_scheduler_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_scheduler_discovery')
        current_phase.next()
        self.command.do_phase_post_scheduler_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_service_discovery(self):
        """
        Creates and registers services as described in configuration space.
        :return: None.
        """
        current_phase = self.create_phase('pre_service_discovery')
        current_phase.next()
        self.command.do_phase_pre_service_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('service_discovery')
        current_phase.next()
        self.phase_service_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_service_discovery')
        current_phase.next()
        self.command.do_phase_post_service_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_ip_discovery(self):
        """
        Finds and loads IP models in both local and global locations.
        :return: None
        """
        current_phase = self.create_phase('pre_ip_discovery')
        current_phase.next()
        self.command.do_phase_pre_ip_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('ip_discovery')
        current_phase.next()
        self.phase_ip_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_ip_discovery')
        current_phase.next()
        self.command.do_phase_post_ip_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_main(self):
        """
        Execute the main task(s) of the command.
        :return: None
        """
        current_phase = self.create_phase('pre_main')
        current_phase.next()
        self.command.do_phase_pre_main(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('main')
        current_phase.next()
        self.command.do_phase_main(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_main')
        current_phase.next()
        self.command.do_phase_post_main(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_check(self):
        """
        Check task(s) outputs for errors/warnings.
        :return: None
        """
        current_phase = self.create_phase('pre_check')
        current_phase.next()
        self.command.do_phase_pre_check(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('check')
        current_phase.next()
        self.phase_check(current_phase)
        self.command.do_phase_check(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_check')
        current_phase.next()
        self.command.do_phase_post_check(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_report(self):
        """
        Create report(s) on task(s) executed.
        :return: None
        """
        current_phase = self.create_phase('pre_report')
        current_phase.next()
        self.command.do_phase_pre_report(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('report')
        current_phase.next()
        self.phase_report(current_phase)
        self.command.do_phase_report(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_report')
        current_phase.next()
        self.command.do_phase_post_report(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_cleanup(self):
        """
        Delete any temporary files, close handles and connections.
        :return: None
        """
        current_phase = self.create_phase('pre_cleanup')
        current_phase.next()
        self.command.do_phase_pre_cleanup(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('cleanup')
        current_phase.next()
        self.phase_cleanup(current_phase)
        self.command.do_phase_cleanup(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_cleanup')
        current_phase.next()
        self.command.do_phase_post_cleanup(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_shutdown(self):
        """
        Perform any step(s) necessary before Moore.io Client ends its operation.
        :return: None
        """
        current_phase = self.create_phase('pre_shutdown')
        current_phase.next()
        self.command.do_phase_pre_shutdown(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('shutdown')
        current_phase.next()
        self.phase_shutdown(current_phase)
        self.command.do_phase_shutdown(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_shutdown')
        current_phase.next()
        self.command.do_phase_post_shutdown(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def do_phase_final(self):
        """
        Last call.
        :return: None
        """
        current_phase = self.create_phase('pre_final')
        current_phase.next()
        self.command.do_phase_pre_final(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('final')
        current_phase.next()
        self.phase_final(current_phase)
        self.command.do_phase_final(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_final')
        current_phase.next()
        self.command.do_phase_post_final(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    @abstractmethod
    def phase_init(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_load_default_configuration(self, phase):
        pass

    @abstractmethod
    def phase_load_user_data(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_authenticate(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_save_user_data(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_locate_project_file(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_create_common_files_and_directories(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_load_user_configuration(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_load_project_configuration(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_validate_configuration_space(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_scheduler_discovery(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_service_discovery(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_ip_discovery(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_check(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_report(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_cleanup(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_shutdown(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass

    @abstractmethod
    def phase_final(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        pass




#######################################################################################################################
# Full implementation
#######################################################################################################################
class DefaultRootManager(RootManager):
    """
    Stock implementation of RootManager's pure virtual methods.
    """
    def phase_init(self, phase):
        file_path = os.path.realpath(__file__)
        directory_path = os.path.dirname(file_path)
        install_path = Path(Path(directory_path) / '..').resolve()
        self._install_path = install_path
    
    def phase_load_default_configuration(self, phase):
        self._default_configuration_path = self._install_path / 'data' / 'defaults.toml'
        try:
            with open(self.default_configuration_path, 'r') as f:
                self._default_configuration = toml.load(f)
        except ValidationError as e:
            phase.error = Exception(f"Failed to load default configuration file at '{self.default_configuration_path}': {e}")
    
    def phase_load_user_data(self, phase):
        if self.file_exists(self._user_data_file_path):
            try:
                self._user = User.load(self._user_data_file_path)
            except ValidationError as e:
                phase.error = Exception(f"Failed to load User Data at '{self._user_data_file_path}': {e}")
        else:
            self._user = User.new()

    def phase_authenticate(self, phase):
        if not self.user.authenticated:
            if self.user.use_pre_set_username:
                self.user.username = self.user.pre_set_username
            else:
                if self.user.username == "__ANONYMOUS__":
                    self.user.username = input("Enter your username: ")
            password = ""
            try:
                if self.user.use_pre_set_password:
                    password = self.user.pre_set_password
                else:
                    password = getpass.getpass("Enter your password: ")
            except Exception as e:
                phase.error = Exception(f"An error occurred during authentication: {e}")
            else:
                credentials = {
                    'username': self.user.username,
                    'password': password,
                }
                try:
                    response = requests.post(f"{self.url_authentication}/login/", json=credentials)
                    response.raise_for_status()  # Raise an error for bad status codes
                    data = response.json()
                    self.user.access_token = data['access']
                    self.user.refresh_token = data['refresh']
                except requests.RequestException as e:
                    phase.error = Exception(f"An error occurred during authentication: {e}")
                else:
                    self.user.authenticated = True

    def web_api_call(self, method: HTTPMethod, path: str, data: dict) -> dict:
        response = {}
        headers = {
            'Authorization'  : f"Bearer {self.user.access_token}",
            'Content-Type'   : 'application/json',
        }
        try:
            if method == HTTPMethod.POST:
                response = requests.post(f"{self.url_api}/{path}", headers=headers, json=data)
                response.raise_for_status()  # Raise an error for bad status codes
            else:
                raise Exception(f"Method {method} is not supported")
        except requests.RequestException as e:
            raise Exception(f"Error during Web API call: {method} to '{path}': {e}")
        return response

    def deauthenticate(self):
        headers = {
            'Authorization'  : f"Bearer {self.user.access_token}",
            'Content-Type'   : 'application/json',
        }
        data = {
            'refresh_token' : self.user.refresh_token,
        }
        try:
            response = requests.post(f"{self.url_authentication}/logout/", headers=headers, json=data)
            response.raise_for_status()  # Raise an error for bad status codes
        except requests.RequestException as e:
            raise Exception(f"Error during logout: {e}")


    def phase_save_user_data(self, phase):
        try:
            self.create_file(self._user_data_file_path)
            data = self._user.dict()
            with open(self._user_data_file_path, 'w') as file:
                yaml.dump(data, file)
        except Exception as e:
            phase.error = Exception(f"Failed to save User Data at '{self._user_data_file_path}': {e}")

    def phase_locate_project_file(self, phase):
        current_path = self._wd
        try:
            while current_path != os.path.dirname(current_path):  # Stop if we're at the root directory
                candidate_path = os.path.join(current_path, 'mio.toml')
                if self.file_exists(candidate_path):
                    self._project_configuration_path = candidate_path
                    return
                # Move up one directory
                current_path = os.path.dirname(current_path)
        except Exception as e:
            phase.error = Exception(f"Could not locate Project 'mio.toml': {e}")

    def phase_create_common_files_and_directories(self, phase):
        self.create_directory(self.md)

    def phase_load_project_configuration(self, phase):
        try:
            with open(self.project_configuration_path, 'r') as f:
                self._project_configuration = toml.load(f)
        except ValidationError as e:
            phase.error = Exception(f"Failed to load Project configuration file at '{self.project_configuration_path}': {e}")

    def phase_load_user_configuration(self, phase):
        self._user_configuration_path = os.path.expanduser("~/.mio/mio.toml")
        if self.file_exists(self._user_configuration_path):
            try:
                with open(self.user_configuration_path, 'r') as f:
                    self._user_configuration = toml.load(f)
            except ValidationError as e:
                phase.error = Exception(f"Failed to load User configuration at '{self._user_configuration_path}': {e}")
        else:
            self.create_file(self._user_configuration_path)
            self._user_configuration = Configuration()

    def phase_validate_configuration_space(self, phase):
        merged_configuration = self.merge_dictionaries(self._default_configuration, self._user_configuration)
        merged_configuration = self.merge_dictionaries(merged_configuration, self._project_configuration)
        try:
            self._configuration = Configuration(merged_configuration)
        except ValidationError as e:
            phase.error = Exception(f"Failed to validate Configuration Space: {e}")
        self.configuration.check()

    def phase_scheduler_discovery(self, phase):
        self._scheduler_database = JobSchedulerDatabase(self)
        self._scheduler_database.add_task_scheduler(LocalProcessScheduler(self))
        # TODO Implement proper discovery once another TaskScheduler implementation other than LocalProcessScheduler is implemented

    def phase_service_discovery(self, phase):
        self._service_database = ServiceDataBase(self)
        if self.configuration.simulation.metrics_dsim_path != "":
            dsim_simulator = SimulatorMetricsDSim(self, self.configuration.simulation.metrics_dsim_path)
            self.service_database.add_service(dsim_simulator)
        # TODO Add other logic simulators

    def phase_ip_discovery(self, phase):
        """
        Discover and load all 'ip.yml' files in the directory specified by self.project_root_path.
        :param phase: handle to phase object
        :return: None
        """
        self._ip_database = IpDataBase(self)
        ip_files = []
        for root, dirs, files in os.walk(self.project_root_path):
            for file in files:
                if file == 'ip.yml':
                    ip_files.append(os.path.join(root, file))
        if not ip_files:
            phase.error = Exception("No 'ip.yml' files found in the project directory.")
        else:
            for file in ip_files:
                try:
                    ip_model = Ip(self, file)
                except Exception as e:
                    print(f"Skipping IP definition at '{file}': {e}")
                else:
                    self.ip_database.add_ip(ip_model)

    def phase_check(self, phase):
        pass

    def phase_report(self, phase):
        pass

    def phase_cleanup(self, phase):
        pass

    def phase_shutdown(self, phase):
        pass

    def phase_final(self, phase):
        pass


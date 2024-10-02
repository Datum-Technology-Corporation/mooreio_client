# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
import re
from configparser import Error
from pathlib import Path
from re import Match
from typing import List, Pattern

import requests
from pydantic import ValidationError, BaseModel
import service
import os
import getpass
from mio_client.models.configuration import Configuration
from mio_client.models.user import User
from phase import Phase
from mio_client.models.command import Command


class RootManager:
    """
    Abstract component which performs all vital tasks and executes phases.
    """
    def __init__(self, name, wd):
        """
        Initialize an instance of the root.

        :param name: The name of the instance.
        :param wd: The working directory for the instance.
        """
        self._name = name
        self._wd = wd
        self._md = wd / ".mio"
        self._command = None
        self._install_path = None
        self._user_data_file_path = None
        self._user = None
        self._default_configuration_path = None
        self._user_configuration_path = None
        self._project_configuration_path = None
        self._default_configuration = None
        self._user_configuration = None
        self._project_configuration = None
        self._cli_configuration = None
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
    def command(self) -> Command:
        """
        :return: The command being executed.
        """
        return self._command

    @property
    def user(self):
        """
        :return: The User model.
        """
        return self._user

    @property
    def configuration(self):
        """
        :return: The configuration space.
        """
        return self._configuration

    @property
    def scheduler_database(self):
        """
        :return: The task scheduler database.
        """
        return self._scheduler_database

    @property
    def service_database(self):
        """
        :return: The Service database.
        """
        return self._service_database

    @property
    def ip_database(self):
        """
        :return: The IP database.
        """
        return self._ip_database

    @property
    def current_phase(self):
        """
        :return: The current phase.
        """
        return self._current_phase
    
    
    def run(self, command):
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
        - phase_validate_project_file
        - phase_load_user_configuration
        - phase_load_project_configuration
        - phase_validate_configuration_space
        - phase_scheduler_discovery
        - phase_service_discovery
        - phase_ip_discovery
        - phase_create_common_files_and_directories
        - phase_main
        - phase_check
        - phase_report
        - phase_cleanup
        - phase_shutdown
        - phase_final

        Note that this method does not return any value.
        """
        self.set_command(command)
        self.do_phase_init()
        self.do_phase_load_default_configuration()
        self.do_phase_load_user_data()
        self.do_phase_authenticate()
        self.do_phase_save_user_data()
        self.do_phase_locate_project_file()
        self.do_phase_load_project_configuration()
        self.do_phase_load_user_configuration()
        self.do_phase_validate_configuration_space()
        self.do_phase_scheduler_discovery()
        self.do_phase_service_discovery()
        self.do_phase_ip_discovery()
        self.do_phase_create_common_files_and_directories()
        self.do_phase_main()
        self.do_phase_check()
        self.do_phase_report()
        self.do_phase_cleanup()
        self.do_phase_shutdown()
        self.do_phase_final()
    
    
    def set_command(self, command):
        """
        Sets the command for the root.
        :param command: the command to be set as the root command
        :return: None
        :raises TypeError: if the command is not an instance of Command
        """
        if not isinstance(command, Command):
            raise TypeError("root must be an instance of Root")
        self._command = command
        command.root = self
    
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
            raise RuntimeError(f"Phase '{phase}' has not finished properly")
    
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

    def phase_init(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")
    
    def phase_load_default_configuration(self, phase):
        raise NotImplementedError("Must be implemented by subclass")

    def phase_load_user_data(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_authenticate(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_save_user_data(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_locate_project_file(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_validate_project_file(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_load_user_configuration(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_load_project_configuration(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_merge_configuration_space(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_validate_configuration_space(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_scheduler_discovery(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_service_discovery(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_ip_discovery(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_create_common_files_and_directories(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_check(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_report(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_cleanup(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_shutdown(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def phase_final(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")


class DefaultRootManager(RootManager):
    """
    Stock implementation of Root's pure virtual methods.
    """
    def phase_init(self, phase):
        self._install_path = os.path.dirname(os.path.realpath(__file__)) / '..'
    
    def phase_load_default_configuration(self, phase):
        self._default_configuration_path = self._install_path / 'data' / 'defaults.toml'
        try:
            self._default_configuration = Configuration.load(self._default_configuration_path)
        except ValidationError as e:
            phase.error(e)
            raise Exception(f"Failed to load default configuration at '{self._default_configuration_path}': {e}")
    
    def phase_load_user_data(self, phase):
        self._user_data_file_path = os.path.expanduser("~/.mio/user.yml")
        if self.file_exists(self._user_data_file_path):
            try:
                self._user = User.load(self._user_data_file_path)
            except ValidationError as e:
                phase.error(e)
                raise Exception(f"Failed to load User Data at '{self._user_data_file_path}': {e}")
        else:
            self._user = User(self._user_data_file_path)

    def phase_authenticate(self, phase):
        if not self._user.authenticated:
            authenticate_url = 'https://mooreio.com/api/authenticate/'
            if self._user.username == "":
                self._user.username = input("Enter your username: ")
            try:
                password = getpass.getpass("Enter your password: ")
            except Exception as e:
                phase.error(e)
                raise Error(f"An error occurred during authentication: {e}")
            credentials = {
                'username': self._user.username,
                'password': password,
            }
            try:
                response = requests.post(authenticate_url, json=credentials)
                response.raise_for_status()  # Raise an error for bad status codes
                data = response.json()
                self._user.token = data.get('token')  # Assuming API returns the token in 'token' field
                self._user.authenticated = True  # Assuming you have a way to mark the user as authenticated
            except requests.RequestException as e:
                phase.error(e)
                raise Exception(f"An error occurred during authentication: {e}")
    
    def phase_save_user_data(self, phase):
        try:
            self.create_file(self._user_data_file_path)
            self._user.to_yaml()
        except Exception as e:
            phase.error(e)
            raise Error(f"Failed to save User Data at '{self._user_data_file_path}': {e}")

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
            phase.error(e)
            raise Exception(f"Could not locate Project 'mio.toml': {e}")

    def phase_load_project_configuration(self, phase):
        try:
            self._project_configuration = Configuration.load(self._project_configuration_path)
        except ValidationError as e:
            phase.error(e)
            raise Exception(f"Failed to load Project configuration at '{self._project_configuration_path}': {e}")

    def phase_load_user_configuration(self, phase):
        self._user_configuration_path = os.path.expanduser("~/.mio/mio.toml")
        if self.file_exists(self._user_configuration_path):
            try:
                self._user_configuration = Configuration.load(self._user_configuration_path)
            except ValidationError as e:
                phase.error(e)
                raise Exception(f"Failed to load User configuration at '{self._user_configuration_path}': {e}")
        else:
            self.create_file(self._user_configuration_path)
            self._user_configuration = Configuration(self._user_configuration_path)

    def phase_validate_configuration_space(self, phase):
        default_configuration_dict = self._default_configuration.model_dump()
        user_configuration_dict = self._user_configuration.model_dump()
        project_configuration_dict = self._project_configuration.model_dump()
        default_plus_user_configuration_dict = {**default_configuration_dict, **user_configuration_dict}
        default_plus_user_plus_project_configuration_dict = {**default_plus_user_configuration_dict, **project_configuration_dict}
        self._configuration = Configuration(default_plus_user_plus_project_configuration_dict)
        self._configuration.check()

    def phase_scheduler_discovery(self, phase):
        pass

    def phase_service_discovery(self, phase):
        pass

    def phase_ip_discovery(self, phase):
        pass

    def phase_create_common_files_and_directories(self, phase):
        pass

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


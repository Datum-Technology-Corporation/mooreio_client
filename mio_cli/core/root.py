# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################


import os
import service
from phase import Phase
from mio_client.models.command import Command


class Root:
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
        self._command = None
        self._config = None

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
    def command(self) -> Command:
        """
        :return: The command being executed.
        """
        return self._command

    @property
    def config(self):
        """
        :return: The configuration space.
        """
        return self._config
    
    
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
        - phase_service_discovery
        - phase_scan_for_ip
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
        self.phase_init()
        self.phase_load_default_configuration()
        self.phase_load_user_data()
        self.phase_authenticate()
        self.phase_save_user_data()
        self.phase_locate_project_file()
        self.phase_validate_project_file()
        self.phase_load_user_configuration()
        self.phase_load_project_configuration()
        self.phase_validate_configuration_space()
        self.phase_service_discovery()
        self.phase_scan_for_ip()
        self.phase_create_common_files_and_directories()
        self.phase_main()
        self.phase_check()
        self.phase_report()
        self.phase_cleanup()
        self.phase_shutdown()
        self.phase_final()
    
    
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
        return Phase(self, name)
    
    def check_phase_finished(self, phase):
        """
        Check if a phase has finished properly.
        :param phase: The phase to be checked.
        :return: None.
        """
        if not phase.has_finished():
            raise RuntimeError(f"Phase '{phase}' has not finished properly")
    
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
    
    
    def phase_init(self):
        """
        Perform any steps necessary before real work begins.
        :return: None
        """
        current_phase = self.create_phase('init')
        current_phase.next()
        self.init(current_phase)
        self.command.do_phase_init(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_load_default_configuration(self):
        """
        Load default configuration file from the package.
        :return: None
        """
        current_phase = self.create_phase('pre_load_default_configuration')
        current_phase.next()
        self.command.do_phase_pre_load_default_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.load_default_configuration(current_phase)
        current_phase = self.create_phase('post_load_default_configuration')
        current_phase.next()
        self.command.do_phase_post_load_default_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_load_user_data(self):
        """
        Load user data from disk.
        :return: None
        """
        current_phase = self.create_phase('pre_user_data')
        current_phase.next()
        self.command.do_phase_pre_load_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.load_user_data(current_phase)
        current_phase = self.create_phase('post_user_data')
        current_phase.next()
        self.command.do_phase_post_load_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_authenticate(self):
        """
        Authenticate the user with mio_web if necessary.
        :return: None
        """
        current_phase = self.create_phase('pre_authenticate')
        current_phase.next()
        self.command.do_phase_pre_authenticate(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        if self._command.needs_authentication():
            self.authenticate(current_phase)
        current_phase = self.create_phase('post_authenticate')
        current_phase.next()
        self.command.do_phase_post_authenticate(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_save_user_data(self):
        """
        Write user data to disk.
        :return: None
        """
        current_phase = self.create_phase('pre_save_user_data')
        current_phase.next()
        self.command.do_phase_pre_save_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.save_user_data(current_phase)
        current_phase = self.create_phase('post_save_user_data')
        current_phase.next()
        self.command.do_phase_post_save_user_data(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_locate_project_file(self):
        """
        Locate the project file (`mio.toml`).
        :return: None
        """
        current_phase = self.create_phase('pre_locate_project_file')
        current_phase.next()
        self.command.do_phase_pre_locate_project_file(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.locate_project_file(current_phase)
        current_phase = self.create_phase('post_locate_project_file')
        current_phase.next()
        self.command.do_phase_post_locate_project_file(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_validate_project_file(self):
        """
        Check that the project file is valid, but do not load its data yet.

        :return: None
        """
        current_phase = self.create_phase('pre_validate_project_file')
        current_phase.next()
        self.command.do_phase_pre_validate_project_file(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.validate_project_file(current_phase)
        current_phase = self.create_phase('post_validate_project_file')
        current_phase.next()
        self.command.do_phase_post_validate_project_file(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_load_user_configuration(self):
        """
        Load user configuration space from disk.
        :return: None
        """
        current_phase = self.create_phase('pre_load_user_configuration')
        current_phase.next()
        self.command.do_phase_pre_load_user_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.load_user_configuration(current_phase)
        current_phase = self.create_phase('post_load_user_configuration')
        current_phase.next()
        self.command.do_phase_post_load_user_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_load_project_configuration(self):
        """
        Load project configuration space from disk.
        :return: None
        """
        current_phase = self.create_phase('pre_load_project_configuration')
        current_phase.next()
        self.command.do_phase_pre_load_project_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.load_project_configuration(current_phase)
        current_phase = self.create_phase('post_load_project_configuration')
        current_phase.next()
        self.command.do_phase_post_load_project_configuration(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_validate_configuration_space(self):
        """
        Merge & validate the configuration space.
        :return: None
        """
        current_phase = self.create_phase('pre_validate_configuration_space')
        current_phase.next()
        self.command.do_phase_pre_validate_configuration_space(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.merge_configuration_space(current_phase)
        self.validate_configuration_space(current_phase)
        current_phase = self.create_phase('post_validate_configuration_space')
        current_phase.next()
        self.command.do_phase_post_validate_configuration_space(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_service_discovery(self):
        """
        Creates and registers services as described in configuration space.
        :return: None.
        """
        current_phase = self.create_phase('pre_service_discovery')
        current_phase.next()
        self.command.do_phase_pre_service_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.service_discovery(current_phase)
        current_phase = self.create_phase('post_service_discovery')
        current_phase.next()
        self.command.do_phase_post_service_discovery(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_scan_for_ip(self):
        """
        Finds and loads IP models in both local and external locations.
        :return: None
        """
        current_phase = self.create_phase('pre_scan_for_ip')
        current_phase.next()
        self.command.do_phase_pre_scan_for_ip(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        self.scan_for_ip(current_phase)
        current_phase = self.create_phase('post_scan_for_ip')
        current_phase.next()
        self.command.do_phase_post_scan_for_ip(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_create_common_files_and_directories(self):
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
        self.create_common_files_and_directories(current_phase)
        self.command.do_phase_create_common_files_and_directories(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_create_common_files_and_directories')
        current_phase.next()
        self.command.do_phase_post_create_common_files_and_directories(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_main(self):
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

    def phase_check(self):
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
        self.check(current_phase)
        self.command.do_phase_check(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_check')
        current_phase.next()
        self.command.do_phase_post_check(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_report(self):
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
        self.report(current_phase)
        self.command.do_phase_report(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_report')
        current_phase.next()
        self.command.do_phase_post_report(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_cleanup(self):
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
        self.cleanup(current_phase)
        self.command.do_phase_cleanup(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_cleanup')
        current_phase.next()
        self.command.do_phase_post_cleanup(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_shutdown(self):
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
        self.shutdown(current_phase)
        self.command.do_phase_shutdown(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_shutdown')
        current_phase.next()
        self.command.do_phase_post_shutdown(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def phase_final(self):
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
        self.final(current_phase)
        self.command.do_phase_final(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)
        current_phase = self.create_phase('post_final')
        current_phase.next()
        self.command.do_phase_post_final(current_phase)
        current_phase.next()
        self.check_phase_finished(current_phase)

    def init(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")
    
    def load_default_configuration(self, phase):
        raise NotImplementedError("Must be implemented by subclass")

    def load_user_data(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def authenticate(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def save_user_data(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def locate_project_file(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def validate_project_file(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def load_user_configuration(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def load_project_configuration(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def merge_configuration_space(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def validate_configuration_space(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def service_discovery(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def scan_for_ip(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def create_common_files_and_directories(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def check(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def report(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def cleanup(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def shutdown(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")

    def final(self, phase):
        """
        This method is a placeholder and must be implemented by subclasses.
        :param phase: handle to phase object
        :return: None
        """
        raise NotImplementedError("Must be implemented by subclass")




class DefaultRoot(Root):
    """
    Stock implementation of Root's pure virtual methods.
    """

    def init(self, phase):
        pass
    
    def load_default_configuration(self, phase):
        pass
    
    def load_user_data(self, phase):
        pass

    def authenticate(self, phase):
        pass

    def save_user_data(self, phase):
        pass

    def locate_project_file(self, phase):
        pass

    def validate_project_file(self, phase):
        pass

    def load_user_configuration(self, phase):
        pass

    def load_project_configuration(self, phase):
        pass

    def merge_configuration_space(self, phase):
        pass

    def validate_configuration_space(self, phase):
        pass

    def service_discovery(self, phase):
        pass

    def scan_for_ip(self, phase):
        pass

    def create_common_files_and_directories(self, phase):
        pass

    def check(self, phase):
        pass

    def report(self, phase):
        pass

    def cleanup(self, phase):
        pass

    def shutdown(self, phase):
        pass

    def final(self, phase):
        pass


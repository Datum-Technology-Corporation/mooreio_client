# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import importlib
import inspect
import os
import sys
from abc import ABC, abstractmethod
from pathlib import Path
from typing import List
from datetime import datetime
from semantic_version import Version


class Job:
    def __init__(self, rmh: 'RootManager', wd: Path, name: str, binary: Path, arguments: List[str]):
        self._rmh = rmh
        self._wd = wd
        self._name = name
        self._binary = binary
        self._arguments = arguments
        self._env_vars = {}
        self._pre_path:str = ""
        self._post_path:str = ""
        self._print_to_screen:bool = False
        self._hostname = None
        self._is_part_of_set = False
        self._parent_set = None
    
    @property
    def wd(self) -> Path:
        return self._wd
    
    @property
    def name(self) -> str:
        return self._name

    @property
    def binary(self) -> Path:
        return self._binary

    @property
    def env_vars(self) -> dict:
        return self._env_vars
    @env_vars.setter
    def env_vars(self, value: dict):
        self._env_vars = value

    @property
    def pre_path(self) -> str:
        return self._pre_path
    @pre_path.setter
    def pre_path(self, value: str):
        self._pre_path = value

    @property
    def post_path(self) -> str:
        return self._post_path
    @post_path.setter
    def post_path(self, value: str):
        self._post_path = value

    @property
    def print_to_screen(self) -> bool:
        return self._print_to_screen
    @print_to_screen.setter
    def print_to_screen(self, value: bool):
        self._print_to_screen = value

    @property
    def arguments(self) -> List[str]:
        return self._arguments
        
    @property
    def hostname(self):
        return self._hostname
    @hostname.setter
    def hostname(self, value):
        self._hostname = value

    @property
    def is_part_of_set(self) -> bool:
        return self._is_part_of_set

    @property
    def parent_set(self):
        return self._parent_set
    @parent_set.setter
    def parent_set(self, value):
        if value is not None:
            self._is_part_of_set = True
        self._parent_set = value
    

class JobSet:
    def __init__(self, rmh: 'RootManager', command: 'Command', name: str):
        self._rmh = rmh
        self._command = command
        self._name = name
        self._tasks = []

    @property
    def rmh(self) -> 'RootManager':
        return self._rmh

    @property
    def command(self) -> 'Command':
        return self._command

    @property
    def name(self) -> str:
        return self._name

    def add_task(self, task: Job):
        task.parent_set = self
        self._tasks.append(task)


class JobSchedulerConfiguration:
    def __init__(self, rmh: 'RootManager'):
        self._output_to_terminal:bool = True
        self._max_number_of_parallel_processes:int = 1

    @property
    def output_to_terminal(self) -> bool:
        return self._output_to_terminal
    @output_to_terminal.setter
    def output_to_terminal(self, value: bool):
        self._output_to_terminal = value

    @property
    def max_number_of_parallel_processes(self) -> int:
        return self._max_number_of_parallel_processes
    @max_number_of_parallel_processes.setter
    def max_number_of_parallel_processes(self, value: int):
        self._max_number_of_parallel_processes = value


class JobResults:
    _return_code: int = 0
    _stdout: str = ""
    _stderr: str = ""
    _timestamp_start: datetime = None
    _timestamp_end: datetime = None

    @property
    def return_code(self) -> int:
        return self._return_code

    @return_code.setter
    def return_code(self, value: int):
        self._return_code = value

    @property
    def stdout(self) -> str:
        return self._stdout

    @stdout.setter
    def stdout(self, value: str):
        self._stdout = value

    @property
    def stderr(self) -> str:
        return self._stderr

    @stderr.setter
    def stderr(self, value: str):
        self._stderr = value

    @property
    def timestamp_start(self) -> datetime:
        return self._timestamp_start

    @timestamp_start.setter
    def timestamp_start(self, value: datetime):
        self._timestamp_start = value

    @property
    def timestamp_end(self) -> datetime:
        return self._timestamp_end

    @timestamp_end.setter
    def timestamp_end(self, value: datetime):
        self._timestamp_end = value


class JobScheduler(ABC):
    _is_scheduler:bool = True
    def __init__(self, rmh: 'RootManager', name: str=""):
        self._rmh = rmh
        self._name = name
        self._version = None
        self._db = None

    @property
    def name(self) -> str:
        return self._name

    @property
    def version(self) -> Version:
        return self._version

    @property
    def db(self) -> 'JobSchedulerDatabase':
        return self._db

    @db.setter
    def db(self, value: 'JobSchedulerDatabase'):
        self._db = value

    @abstractmethod
    def is_available(self) -> bool:
        pass

    @abstractmethod
    def init(self):
        pass

    @abstractmethod
    def dispatch_job(self, job: Job, configuration: JobSchedulerConfiguration) -> JobResults:
        pass

    @abstractmethod
    def dispatch_job_set(self, job_set: JobSet, configuration: JobSchedulerConfiguration):
        pass


class JobSchedulerDatabase:
    def __init__(self, rmh: 'RootManager'):
        self._rmh = rmh
        self._task_schedulers: list[JobScheduler] = []

    def discover_schedulers(self):
        scheduler_directory = os.path.join(os.path.dirname(__file__), '..', 'schedulers')
        for filename in os.listdir(scheduler_directory):
            if filename.endswith('.py') and not filename.startswith('__'):
                module_name = f'schedulers.{filename[:-3]}'
                try:
                    module = importlib.import_module(module_name)
                    new_schedulers = module.get_schedulers()
                    for scheduler in new_schedulers:
                        try:
                            scheduler_instance = scheduler(self._rmh)
                            self.add_scheduler(scheduler_instance)
                        except Exception as e:
                            print(f"Scheduler '{scheduler}' has errors and is not being loaded: {e}", file=sys.stderr)
                except Exception as e:
                    print(f"Scheduler module '{module_name}' has errors and is not being loaded: {e}", file=sys.stderr)
                    continue

    def add_scheduler(self, task_scheduler: 'JobScheduler'):
        task_scheduler.db = self
        if task_scheduler.is_available():
            self._task_schedulers.append(task_scheduler)
            task_scheduler.init()

    def find_scheduler(self, name: str) -> 'JobScheduler':
        for task_scheduler in self._task_schedulers:
            if task_scheduler.name == name:
                return task_scheduler
        raise Exception(f"No Job Scheduler '{name}' exists in the Job Scheduler Database")
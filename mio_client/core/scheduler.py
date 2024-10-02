# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from abc import ABC, abstractmethod
from pathlib import Path
from typing import List
from xmlrpc.client import DateTime
from datetime import datetime
import semantic_version
from semantic_version import Version
from subprocess import run
from mio_client.core.root import RootManager
from mio_client.models.command import Command


class Task:
    def __init__(self, rmh: RootManager, command: Command, wd: Path, name: str, binary: Path, arguments: List[str]):
        self._rmh = rmh
        self._command = command
        self._wd = wd
        self._name = name
        self._binary = binary
        self._arguments = arguments
        self._return_code = None
        self._timestamp_start = None
        self._timestamp_end = None
        self._hostname = None
    
    @property
    def command(self) -> Command:
        return self._command
    
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
    def arguments(self) -> List[str]:
        return self._arguments

    @property
    def return_code(self) -> int:
        return self._return_code
    @return_code.setter
    def return_code(self, value: int):
        self._return_code = value

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
        
    @property
    def hostname(self):
        return self._hostname
    @hostname.setter
    def hostname(self, value):
        self._hostname = value
    


class TaskSet:
    def __init__(self, rmh: RootManager):
        self._rmh = rmh


class TaskSchedulerConfiguration:
    def __init__(self, rmh: RootManager):
        self._output_to_terminal = False
    @property
    def output_to_terminal(self) -> bool:
        return self._output_to_terminal
    @output_to_terminal.setter
    def output_to_terminal(self, value: bool):
        self._output_to_terminal = value


class TaskSchedulerDatabase:
    pass


class TaskScheduler(ABC):
    def __init__(self, rmh: RootManager, name: str, binary: Path):
        self._rmh = rmh
        self._name = name
        self._binary = binary
        self._version = None
        self._db = None
    
    @property
    def name(self) -> str:
        return self._name
    
    @property
    def binary(self) -> Path:
        return self._binary
    
    @property
    def version(self) -> Version:
        return self._version
    
    @property
    def db(self) -> TaskSchedulerDatabase:
        return self._db
    @db.setter
    def db(self, value: TaskSchedulerDatabase):
        self._db = value
    
    @abstractmethod
    def init(self):
        pass
    
    @abstractmethod
    def dispatch_task(self, task: Task, configuration: TaskSchedulerConfiguration):
        pass
    
    @abstractmethod
    def dispatch_task_set(self, task_set: TaskSet, configuration: TaskSchedulerConfiguration):
        pass




class LocalProcessScheduler(TaskScheduler):
    def init(self):
        pass

    def dispatch_task(self, task: Task, configuration: TaskSchedulerConfiguration):
        task.timestamp_start = datetime.now()
        command_str = [task.binary] + task.arguments
        result = run(args=command_str, cwd=task.wd, shell=True)
        task.timestamp_end = datetime.now()
        task.return_code = result.returncode

    def dispatch_task_set(self, task_set: TaskSet, configuration: TaskSchedulerConfiguration):
        pass


class LsfScheduler(TaskScheduler):
    def init(self):
        pass

    def dispatch_task(self, task: Task, configuration: TaskSchedulerConfiguration):
        pass

    def dispatch_task_set(self, task_set: TaskSet, configuration: TaskSchedulerConfiguration):
        pass


class GridEngineScheduler(TaskScheduler):
    def init(self):
        pass

    def dispatch_task(self, task: Task, configuration: TaskSchedulerConfiguration):
        pass

    def dispatch_task_set(self, task_set: TaskSet, configuration: TaskSchedulerConfiguration):
        pass


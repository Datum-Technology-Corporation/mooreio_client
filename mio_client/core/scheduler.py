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



class Job:
    def __init__(self, rmh: 'RootManager', command: 'Command', wd: Path, name: str, binary: Path, arguments: List[str]):
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
        self._is_part_of_set = False
        self._parent_set = None
    
    @property
    def command(self) -> 'Command':
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
        self._output_to_terminal = False
        self._max_number_of_parallel_processes = 1

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


class JobSchedulerDatabase:
    def __init__(self, rmh: 'RootManager'):
        self._rmh = rmh
        self._task_schedulers = []

    def add_task_scheduler(self, task_scheduler: 'JobScheduler'):
        task_scheduler.db = self
        self._task_schedulers.append(task_scheduler)
        task_scheduler.init()

    def get_task_scheduler(self, name: str) -> 'JobScheduler':
        for task_scheduler in self._task_schedulers:
            if task_scheduler.name == name:
                return task_scheduler
        raise Exception(f"No Task Scheduler '{name}' exists in the Task Scheduler Database")


class JobScheduler(ABC):
    def __init__(self, rmh: 'RootManager', name: str):
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
    def db(self) -> JobSchedulerDatabase:
        return self._db
    @db.setter
    def db(self, value: JobSchedulerDatabase):
        self._db = value
    
    @abstractmethod
    def init(self):
        pass
    
    @abstractmethod
    def dispatch_task(self, task: Job, configuration: JobSchedulerConfiguration):
        pass
    
    @abstractmethod
    def dispatch_task_set(self, task_set: JobSet, configuration: JobSchedulerConfiguration):
        pass


class LocalProcessSchedulerConfiguration(JobSchedulerConfiguration):
    pass


class LocalProcessScheduler(JobScheduler):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, "Local process")

    def init(self):
        pass

    def dispatch_task(self, task: Job, configuration: LocalProcessSchedulerConfiguration):
        task.timestamp_start = datetime.now()
        command_str = [task.binary] + task.arguments
        result = run(args=command_str, cwd=task.wd, shell=True)
        task.timestamp_end = datetime.now()
        task.return_code = result.returncode

    def dispatch_task_set(self, task_set: JobSet, configuration: LocalProcessSchedulerConfiguration):
        pass
        # TODO IMPLEMENT



# TODO IMPLEMENT!
class LsfSchedulerConfiguration(JobSchedulerConfiguration):
    pass


# TODO IMPLEMENT!
class LsfScheduler(JobScheduler):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, "LSF")

    def init(self):
        pass

    def dispatch_task(self, task: Job, configuration: LsfSchedulerConfiguration):
        pass

    def dispatch_task_set(self, task_set: JobSet, configuration: LsfSchedulerConfiguration):
        pass


# TODO IMPLEMENT!
class GridEngineSchedulerConfiguration(JobSchedulerConfiguration):
    pass


# TODO IMPLEMENT!
class GridEngineScheduler(JobScheduler):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, "GRID Engine")

    def init(self):
        pass

    def dispatch_task(self, task: Job, configuration: GridEngineSchedulerConfiguration):
        pass

    def dispatch_task_set(self, task_set: JobSet, configuration: GridEngineSchedulerConfiguration):
        pass


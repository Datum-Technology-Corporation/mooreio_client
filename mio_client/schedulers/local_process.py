# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from datetime import datetime
from subprocess import run

from root_manager import RootManager
from scheduler import JobSchedulerConfiguration, JobScheduler, JobResults, Job, JobSet


def get_schedulers():
    return [LocalProcessScheduler]



class LocalProcessSchedulerConfiguration(JobSchedulerConfiguration):
    pass


class LocalProcessScheduler(JobScheduler):
    def __init__(self, rmh: RootManager):
        super().__init__(rmh, "local_process")

    def is_available(self) -> bool:
        return True

    def init(self):
        pass

    def dispatch_job(self, task: Job, configuration: LocalProcessSchedulerConfiguration) -> JobResults:
        results = JobResults()
        results.timestamp_start = datetime.now()
        command_list = [task.binary] + task.arguments
        command_str = "  ".join(command_list)
        result = run(args=command_str, cwd=task.wd, shell=True)
        results.timestamp_end = datetime.now()
        results.return_code = result.returncode
        return results

    def dispatch_job_set(self, task_set: JobSet, configuration: LocalProcessSchedulerConfiguration):
        pass
        # TODO IMPLEMENT


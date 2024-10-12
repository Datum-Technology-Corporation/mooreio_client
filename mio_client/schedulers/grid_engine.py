# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from root_manager import RootManager
from scheduler import JobSchedulerConfiguration, JobScheduler, Job, JobResults, JobSet


def get_schedulers():
    return []


# TODO IMPLEMENT!
class GridEngineSchedulerConfiguration(JobSchedulerConfiguration):
    pass


# TODO IMPLEMENT!
class GridEngineScheduler(JobScheduler):
    def __init__(self, rmh: RootManager):
        super().__init__(rmh, "grid_engine")

    def is_available(self) -> bool:
        return False

    def init(self):
        pass

    def dispatch_job(self, job: Job, configuration: GridEngineSchedulerConfiguration) -> JobResults:
        pass

    def dispatch_job_set(self, job_set: JobSet, configuration: GridEngineSchedulerConfiguration):
        pass


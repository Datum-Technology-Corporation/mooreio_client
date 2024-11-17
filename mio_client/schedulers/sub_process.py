# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import os
import subprocess
from datetime import datetime
from mio_client.core.scheduler import JobSchedulerConfiguration, JobScheduler, JobResults, Job, JobSet


def get_schedulers():
    return [SubProcessScheduler]


class SubProcessSchedulerConfiguration(JobSchedulerConfiguration):
    pass


class SubProcessScheduler(JobScheduler):
    def __init__(self, rmh: 'RootManager'):
        super().__init__(rmh, "sub_process")

    def is_available(self) -> bool:
        return True

    def init(self):
        pass

    def do_dispatch_job(self, job: Job, configuration: SubProcessSchedulerConfiguration) -> JobResults:
        results = JobResults()
        results.timestamp_start = datetime.now()
        command_list: list[str] = [str(job.binary)] + job.arguments
        command_str = "  ".join(command_list)
        path = os.environ['PATH']
        path = f"{job.pre_path}:{path}:{job.post_path}"
        final_env_vars = {**job.env_vars, **os.environ}
        final_env_vars['PATH'] = path
        if not configuration.dry_run:
            if configuration.output_to_terminal:
                result = subprocess.Popen(args=command_str, cwd=job.wd, shell=True, env=final_env_vars, text=True)
            else:
                result = subprocess.Popen(args=command_str, cwd=job.wd, shell=True, env=final_env_vars,
                                          stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            result.wait()
            results.stdout = str(result.stdout.read())
            results.stderr = str(result.stderr.read())
            results.return_code = result.returncode
        results.timestamp_end = datetime.now()
        return results

    def do_dispatch_job_set(self, job_set: JobSet, configuration: SubProcessSchedulerConfiguration):
        pass
        # TODO IMPLEMENT


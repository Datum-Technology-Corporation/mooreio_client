# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################


from mio_client.models.command import Command


def get_commands():
    return [Simulate]


class Simulate(Command):
    @staticmethod
    def add_to_subparser(subparsers):
        pass

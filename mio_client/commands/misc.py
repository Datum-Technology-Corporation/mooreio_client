# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from mio_client.core.phase import Phase
from mio_client.models.command import Command


ALL_COMMANDS = [
    "help"
]

HELP_TEXT = """Moore.io Help Command
   Prints out documentation on a specific command.  This is meant for quick lookups and is only a subset of the
   documentation found in the User Manual (https://mio-client.readthedocs.io/).
   
Usage:
   mio help CMD
   
Examples:
   mio help sim  # Prints out a summary on the Logic Simulation command and its options"""


def get_commands():
    return [Help]


class Help(Command):
    @staticmethod
    def name() -> str:
        return "Help"

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_help = subparsers.add_parser('help', description="Provides documentation on specific command")
        parser_help.add_argument("cmd", help='Command whose documentation to print', choices=ALL_COMMANDS)

    def print_text_and_exit(self, phase: Phase, text: str):
        print(text)
        phase.end_process = True

    def phase_init(self, phase):
        if self.parsed_cli_arguments.cmd == "help":
            self.print_text_and_exit(phase, HELP_TEXT)


# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from mio_client.commands import web, user, ip
from mio_client.core.phase import Phase
from mio_client.models.command import Command


ALL_COMMANDS = [
    "help", "login", "logout", "list", "publish", "install", "uninstall"
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
        return "help"

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_help = subparsers.add_parser('help', description="Provides documentation on specific command", add_help=False)
        parser_help.add_argument("cmd", help='Command whose documentation to print', choices=ALL_COMMANDS)

    def print_text_and_exit(self, phase: Phase, text: str):
        print(text)
        phase.end_process = True

    def phase_init(self, phase):
        if self.parsed_cli_arguments.cmd == "help":
            self.print_text_and_exit(phase, HELP_TEXT)
        if self.parsed_cli_arguments.cmd == "login":
            self.print_text_and_exit(phase, user.LOGIN_HELP_TEXT)
        if self.parsed_cli_arguments.cmd == "logout":
            self.print_text_and_exit(phase, user.LOGOUT_HELP_TEXT)
        if self.parsed_cli_arguments.cmd == "list":
            self.print_text_and_exit(phase, ip.LIST_HELP_TEXT)
        if self.parsed_cli_arguments.cmd == "publish":
            self.print_text_and_exit(phase, ip.PUBLISH_HELP_TEXT)
        if self.parsed_cli_arguments.cmd == "install":
            self.print_text_and_exit(phase, ip.INSTALL_HELP_TEXT)
        if self.parsed_cli_arguments.cmd == "uninstall":
            self.print_text_and_exit(phase, ip.UNINSTALL_HELP_TEXT)

    def needs_authentication(self) -> bool:
        return False


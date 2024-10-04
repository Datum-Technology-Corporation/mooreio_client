# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from mio_client.models.command import Command


LOGIN_HELP_TEXT = """Moore.io User Login Command
   Authenticates session with the Moore.io Server (https://mooreio.com).
   
Usage:
   mio login [OPTIONS]
   
Options:
   -u USERNAME, --username USERNAME  # Specifies Moore.io username (must be combined with -p)
   -p PASSWORD, --password PASSWORD  # Specifies Moore.io password (must be combined with -u)
   
Examples:
   mio login                          # Asks credentials only if expired (or never entered)
   mio login -u jenkins -p )Kq3)fkqm  # Specify credentials inline"""


def get_commands():
    return [Login]


class Login(Command):
    @staticmethod
    def name() -> str:
        return "login"

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_login = subparsers.add_parser('login', add_help=False)
        parser_login.add_argument('-u', "--username", help='Moore.io IP Marketplace username', required=False)
        parser_login.add_argument('-p', "--password", help='Moore.io IP Marketplace password', required=False)

    def authenticate(self):
        return True

    def phase_post_load_user_data(self, phase):
        if self.parsed_cli_arguments.username and not self.parsed_cli_arguments.password:
            phase.error(Exception("Specified a username but not a password."))
        elif not self.parsed_cli_arguments.username and self.parsed_cli_arguments.password:
            phase.error(Exception("Specified a password but not a username."))
        elif self.parsed_cli_arguments.username and self.parsed_cli_arguments.password:
            self.rmh.user.authenticated = False
            self.rmh.user.token = ""
            self.rmh.user.pre_set_username = self.parsed_cli_arguments.username.trim().lower()
            self.rmh.user.pre_set_password = self.parsed_cli_arguments.password.trim().lower()

    def phase_post_save_user_data(self, phase):
        phase.end_process = True



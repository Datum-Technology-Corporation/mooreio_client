# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from http import HTTPMethod

from mio_client.models.command import Command
from mio_client.models.ip import Ip, IpDefinition

PUBLISH_HELP_TEXT = """Moore.io IP Publish Command
   Packages and publishes an IP to the Moore.io IP Marketplace (https://mooreio.com).
   Currently only available to administrator accounts.
   
Usage:
   mio publish IP [OPTIONS]
   
Options:
   -u USERNAME, --username USERNAME  # Specifies Moore.io username (must be combined with -p)
   -p PASSWORD, --password PASSWORD  # Specifies Moore.io password (must be combined with -u)
   -o ORG     , --org      ORG       # Specifies Moore.io IP Marketplace Organization client name.  Commercial IPs only.
   
Examples:
   mio publish uvma_my_ip                               # Publish IP 'uvma_my_ip'.
   mio publish uvma_my_ip -u acme_jenkins -p )Kq3)fkqm  # Specify credentials for Jenkins job.
   mio publish uvma_my_ip -o chip_inc                   # Publish IP 'uvma_my_ip' for client 'chip_inc'."""


def get_commands():
    return [Publish]


class Publish(Command):
    def __init__(self):
        super().__init__()
        self._ip_definition = None
        self._ip = None

    @property
    def ip_definition(self) -> IpDefinition:
        return self._ip_definition

    @property
    def ip(self) -> Ip:
        return self._ip

    @staticmethod
    def name() -> str:
        return "publish"

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_publish = subparsers.add_parser('publish', help=PUBLISH_HELP_TEXT, add_help=False)
        parser_publish.add_argument('ip'              , help='Target IP'                                       )
        parser_publish.add_argument('-u', "--username", help='Moore.io IP Marketplace username', required=False)
        parser_publish.add_argument('-p', "--password", help='Moore.io IP Marketplace password', required=False)
        parser_publish.add_argument('-o', "--org"     , help='Moore.io IP Marketplace Organization client name.  Commercial IPs only.', required=False)

    def phase_init(self, phase):
        if not self.parsed_cli_arguments.ip:
            phase.error = Exception(f"No IP specified")
        else:
            self._ip_definition = Ip.parse_ip_definition(self.parsed_cli_arguments.ip)

    def phase_post_ip_discovery(self, phase):
        try:
            if self.ip_definition.owner_name_is_specified:
                self._ip = self.rmh.ip_database.find_ip(self.ip_definition.ip_name, self.ip_definition.owner_name)
            else:
                self._ip = self.rmh.ip_database.find_ip(self.ip_definition.ip_name)
        except Exception as e:
            phase.error = e

    def phase_main(self, phase):
        data = {}
        response = {}
        try:
            response = self.rmh.web_api_call(HTTPMethod.POST, 'publish_ip', data)
        except Exception as e:
            error = Exception(f"Failed to publish IP '{self.parsed_cli_arguments.ip}': {e}")
            phase.error = e

from http import HTTPMethod

from mio_client.models.command import Command
from mio_client.models.ip import Ip, IpDefinition


LIST_HELP_TEXT = """Moore.io IP List Command
   Lists IPs available on the local setup.

Usage:
   mio list

Examples:
   mio list"""

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
    return [List, Publish]


class List(Command):
    @staticmethod
    def name() -> str:
        return "list"

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_list = subparsers.add_parser('list', help=LIST_HELP_TEXT, add_help=False)

    def needs_authentication(self) -> bool:
        return False

    def phase_post_ip_discovery(self, phase):
        all_ip_unsorted = self.rmh.ip_database.get_all_ip()
        print(f"Found {len(all_ip_unsorted)} IP(s):")
        sorted_ip = sorted(all_ip_unsorted, key=lambda current_ip: (current_ip.has_owner, current_ip.ip.owner if current_ip.has_owner else '', current_ip.ip.name))
        for ip in sorted_ip:
            if ip.has_owner:
                ip_qualified_name = f"{ip.ip.owner}/{ip.ip.name}"
            else:
                ip_qualified_name = f"<no owner>/{ip.ip.name}"
            ip_text = f"  {ip_qualified_name} v{ip.ip.version} - {ip.ip.type}: {ip.ip.full_name}"
            print(ip_text)
        phase.end_process = True


class Publish(Command):
    _ip_definition: IpDefinition
    _ip: Ip
    
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
        parser_publish.add_argument('ip', help='Target IP')
        parser_publish.add_argument('-u', "--username", help='Moore.io IP Marketplace username', required=False)
        parser_publish.add_argument('-p', "--password", help='Moore.io IP Marketplace password', required=False)
        parser_publish.add_argument('-o', "--org",
                                    help='Moore.io IP Marketplace Organization client name.  Commercial IPs only.',
                                    required=False)

    def needs_authentication(self) -> bool:
        return True

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

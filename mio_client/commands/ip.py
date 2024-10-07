import warnings
from base64 import b64encode
from enum import Enum
from http import HTTPMethod
from pathlib import Path

from mio_client.models.command import Command, IpCommand
from mio_client.models.ip import Ip, IpDefinition, IpLocationType, IpPublishingCertificate


LIST_HELP_TEXT = """Moore.io IP List Command
   Lists IPs available to the current project.

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
   -o ORG, --org ORG  # Specifies Client (Moore.io Organization) name.  Commercial IPs only.

Examples:
   mio publish uvma_my_ip          # Publish Public IP 'uvma_my_ip'.
   mio publish uvma_my_ip -o acme  # Publish Commercial IP 'uvma_my_ip' for client 'acme'."""


INSTALL_HELP_TEXT = """Moore.io IP Install Command
   Downloads IP(s) from Moore.io Server.  Can be used in 3 ways:
     1) Without specifying an IP: install all missing dependencies for all IPs in the current Project
     2) Specifying the name a local IP: install all missing dependencies for a specific IP in the current project
     3) Specifying the name of an IP on the Moore.io Server: install remote IP and all its dependencies into the current Project
   
Usage:
   mio install [IP] [OPTIONS]

Options:
   -v SPEC, --version SPEC  # Specifies IP version (only for remote IPs)
   
Examples:
   mio install                     # Install all dependencies for all IPs in the current Project
   mio install my_ip               # Install all dependencies for a specific IP in the current Project
   mio install acme/abc            # Install latest version of IP from Moore.io Server and its dependencies into current Project
   mio install acme/abc -v "1.2.3" # Install specific version of IP from Moore.io Server and its dependencies into current Project"""


UNINSTALL_HELP_TEXT = """Moore.io IP Uninstall Command
   Removes IP(s) installed in current Project.  Can be used in 3 ways:
     1) Without specifying an IP: delete all installed dependencies for all IPs in the current Project
     2) Specifying the name a local IP: delete all installed dependencies for a specific local IP in the current project
     3) Specifying the name of an installed IP: delete installed IP and all its installed dependencies from the current Project
   
Usage:
   mio uninstall [IP]

Examples:
   mio uninstall           # Delete all installed IPs in current project
   mio uninstall my_ip     # Delete all installed dependencies for a specific local IP in the current project
   mio uninstall acme/abc  # Delete specific installed IP and all its installed dependencies from current project"""


class InstallMode(Enum):
    ALL = 1
    LOCAL = 2
    REMOTE = 3


def get_commands():
    return [List, Publish]#[, , Install]


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
            ip_text = f"  {ip_qualified_name} v{ip.ip.version} - {ip.ip.type.value}: {ip.ip.full_name}"
            print(ip_text)
        phase.end_process = True


class Publish(Command):
    _ip_definition: 'IpDefinition'
    _ip: 'Ip'
    _publishing_certificate: IpPublishingCertificate

    @property
    def ip_definition(self) -> 'IpDefinition':
        return self._ip_definition

    @property
    def ip(self) -> 'Ip':
        return self._ip

    @property
    def publishing_certificate(self) -> IpPublishingCertificate:
        return self._publishing_certificate

    @staticmethod
    def name() -> str:
        return "publish"

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_publish = subparsers.add_parser('publish', help=PUBLISH_HELP_TEXT, add_help=False)
        parser_publish.add_argument('ip', help='Target IP')
        parser_publish.add_argument(
            '-o', "--org",
            help='Client (Moore.io Organization) name.  Commercial IPs only.',
            required=False
        )

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
        else:
            if self.ip.location_type != IpLocationType.PROJECT_USER:
                phase.error = Exception(f"Can only publish IP local to the project")

    def phase_main(self, phase):
        try:
            # TODO Remove path unless in debug mode by making the IP model do all the compression/encryption in memory
            self._publishing_certificate = self.rmh.ip_database.publish_new_version_to_remote(self.ip)
        except Exception as e:
            phase.error = Exception(f"Failed to publish IP '{self.ip}': {e}")

    def phase_report(self, phase):
        print(f"Published IP '{self.ip}' successfully.")

    def phase_cleanup(self, phase):
        try:
            # Turn into configuration parameter to store these somewhere for safekeeping
            #self.rmh.remove_file(self.self._publishing_certificate._tgz_path)
            pass
        except Exception as e:
            warnings.warn(f"Failed to delete compressed tarball for IP '{self.ip}': {e}")


class Install(Command):
    _ip_definition: 'IpDefinition'
    _ip: 'Ip'
    _mode: InstallMode

    @staticmethod
    def name() -> str:
        return "install"

    @property
    def ip_definition(self) -> 'IpDefinition':
        return self._ip_definition

    @property
    def ip(self) -> 'Ip':
        return self._ip

    @property
    def mode(self) -> InstallMode:
        return self._mode

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_install = subparsers.add_parser('install', help=INSTALL_HELP_TEXT, add_help=False)
        parser_install.add_argument('ip', help='Target IP', nargs='?', default="*")
        parser_install.add_argument(
            '-v', "--version",
            help='IP version spec (remote IPs only)',
            required=False
        )

    def needs_authentication(self) -> bool:
        return True

    def phase_init(self, phase):
        if self.parsed_cli_arguments.ip == "*":
            self._mode = InstallMode.ALL
        else:
            self._ip_definition = Ip.parse_ip_definition(self.parsed_cli_arguments.ip)

    def phase_post_ip_discovery(self, phase):
        if self.mode != InstallMode.ALL:
            if self.parsed_cli_arguments.version:
                version = self.parsed_cli_arguments.version
            else:
                version = "*"
            if self.ip_definition.owner_name_is_specified:
                self._ip = self.rmh.ip_database.find_ip(self.ip_definition.ip_name, self.ip_definition.owner_name, version, raise_exception_if_not_found=False)
            else:
                self._ip = self.rmh.ip_database.find_ip(self.ip_definition.ip_name, "*", version, raise_exception_if_not_found=False)
            if self.ip:
                self._mode = InstallMode.LOCAL
            else:
                self._mode = InstallMode.REMOTE

    def phase_main(self, phase):
        pass

    def phase_report(self, phase):
        if self.mode == InstallMode.ALL:
            print(f"Installed all IPs successfully.")
        else:
            print(f"Installed IP '{self.ip}' successfully.")

    def phase_cleanup(self, phase):
        pass


class Uninstall(Command):
    _ip_definition: 'IpDefinition'
    _ip: 'Ip'
    _mode: InstallMode

    @staticmethod
    def name() -> str:
        return "uninstall"

    @property
    def ip_definition(self) -> 'IpDefinition':
        return self._ip_definition

    @property
    def ip(self) -> 'Ip':
        return self._ip

    @property
    def mode(self) -> InstallMode:
        return self._mode

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_uninstall = subparsers.add_parser('uninstall', help=UNINSTALL_HELP_TEXT, add_help=False)
        parser_uninstall.add_argument('ip', help='Target IP', nargs='?', default="*")

    def needs_authentication(self) -> bool:
        return False

    def phase_init(self, phase):
        if self.parsed_cli_arguments.ip == "*":
            self._mode = InstallMode.ALL
        else:
            self._ip_definition = Ip.parse_ip_definition(self.parsed_cli_arguments.ip)

    def phase_post_ip_discovery(self, phase):
        if self.mode != InstallMode.ALL:
            try:
                if self.ip_definition.owner_name_is_specified:
                    self._ip = self.rmh.ip_database.find_ip(self.ip_definition.ip_name, self.ip_definition.owner_name)
                else:
                    self._ip = self.rmh.ip_database.find_ip(self.ip_definition.ip_name)
            except Exception as e:
                phase.error = e

    def phase_main(self, phase):
        pass

    def phase_report(self, phase):
        if self.mode == InstallMode.ALL:
            print(f"Uninstalled all IPs successfully.")
        else:
            print(f"Uninstalled IP '{self.ip}' successfully.")

    def phase_cleanup(self, phase):
        pass


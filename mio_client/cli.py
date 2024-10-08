# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import argparse
import pathlib
import sys

from mio_client.commands import eda, ip, misc, project, team, user, web
from mio_client.core.root import DefaultRootManager

#######################################################################################################################
# User Manual Top
#######################################################################################################################
VERSION = "2.0.0"

HELP_TEXT = f"""
                                          Moore.io (`mio`) Client - v{VERSION}
                                     User Manual: https://mio-client.readthedocs.io/
             https://mooreio.com - Copyright 2020-2024 Datum Technology Corporation - https://datumtc.ca
Usage:
  mio [--version] [--help]
  mio [--wd WD] [--dbg] CMD [OPTIONS]

Options:
  -v, --version
    Prints the mio version and exits.

  -h, --help
    Prints the overall synopsis and a list of the most commonly used commands and exits.

  -C WD, --wd WD
    Run as if mio was started in WD (Working Directory) instead of the Present Working Directory `pwd`.

  --dbg
    Enables debugging outputs from mio.

Full Command List (`mio help CMD` for help on a specific command):
   Help and Shell/Editor Integration
      doctor         Runs a set of checks to ensure mio installation has what it needs to operate properly
      help           Prints documentation for mio commands

   Project and Code Management
      init           Starts project creation dialog
      gen            Generates source code using UVMx

   IP and Credentials Management
      install        Installs all IP dependencies from IP Marketplace
      login          Starts session with IP Marketplace
      package        Creates a compressed (and potentially encrypted) archive of an IP
      publish        Publishes IP to IP Marketplace (must have mio admin account)

   EDA Automation
      !              Repeats last command
      regr           Runs regression against an IP
      sim            Performs necessary steps to simulate an IP with any simulator

   Manage Results and other EDA Tool Outputs
      clean          Manages outputs from tools (other than job results)
      cov            Manages coverage data from EDA tools
      dox            Generates HDL source code documentation via Doxygen
      results        Manages results from EDA tools"""


#######################################################################################################################
# Entry point
#######################################################################################################################
URL_BASE = 'https://mooreio.com'
URL_AUTHENTICATION = f'{URL_BASE}/auth/token'
def main(args=None) -> int:
    """
    Main entry point. Performs the following steps in order:
    - Create CLI argument parser
    - Find all commands and register them
    - Parse CLI arguments
    - Find the command which matches the parsed arguments
    - Create the Root instance
    - Run the command via the Root instance

    :return: Exit code
    """

    parser = create_top_level_parser()
    subparsers = parser.add_subparsers(dest='command', help='Sub-command help')
    commands = register_all_commands(subparsers)
    args = parser.parse_args(args)

    if args.version:
        print_version_text()
        return 0
    if (not args.command) or args.help:
        print_help_text()
        return 0

    command = next((cmd for cmd in commands if cmd.name().lower() == args.command), None)
    if not command:
        print(f"Unknown command '{args.command}' specified.", file=sys.stderr)
        return 1

    wd = None
    if args.wd is None:
        wd = pathlib.Path.cwd()
    else:
        try:
            wd = pathlib.Path(args.wd).resolve()
        except Exception as e:
            print(f"Invalid path '{wd}' provided as working directory: {e}", file=sys.stderr)
            return 1

    mio_root = DefaultRootManager("Moore.io Client Root Manager", wd, URL_BASE, URL_AUTHENTICATION)
    command.parsed_cli_arguments = args
    return mio_root.run(command)


#######################################################################################################################
# Helper functions
#######################################################################################################################
def create_top_level_parser():
    """
    Creates a top-level CLI argument parser.

    :return: argparse.ArgumentParser object representing the top-level parser
    """
    parser = argparse.ArgumentParser(prog="mio", description="", add_help=False)
    parser.add_argument("-h"   , "--help"   , help="Shows this help message and exits.", action="store_true", default=False, required=False)
    parser.add_argument("-v"   , "--version", help="Prints version and exit."          , action="store_true", default=False, required=False)
    parser.add_argument("--dbg",              help="Enable tracing output."            , action="store_true", default=False, required=False)
    parser.add_argument("-C"   , "--wd"     , help="Run as if mio was started in <path> instead of the current working directory.", type=pathlib.Path, required=False)
    return parser


def register_all_commands(subparsers):
    """
    Register all commands to the subparsers.

    :param subparsers: An instance of argparse.ArgumentParser that contains the subparsers.
    :return: A list of registered commands.
    """
    commands = []
    register_commands(commands, eda.get_commands())
    register_commands(commands, ip.get_commands())
    register_commands(commands, misc.get_commands())
    register_commands(commands, project.get_commands())
    register_commands(commands, team.get_commands())
    register_commands(commands, user.get_commands())
    register_commands(commands, web.get_commands())
    for command in commands:
        command.add_to_subparsers(subparsers)
    return commands


def register_commands(existing_commands, new_commands):
    """
    Registers new commands into an existing list of commands.

    :param existing_commands: A list of existing commands.
    :param new_commands: A list of new commands to be registered.
    :return: None

    Raises:
        ValueError: If a command name in `new_commands` is already registered in `existing_commands`.

    """
    new_command_names = {command.name for command in new_commands}
    existing_command_names = {command.name for command in existing_commands}
    for command in new_commands:
        if command.name not in existing_command_names:
            existing_commands.append(command)
        else:
            raise ValueError(f"Command '{command}' is already registered.")


def print_help_text():
    print(HELP_TEXT)


def print_version_text():
    print(f"Moore.io Client v{VERSION}")


if __name__ == "__main__":
    sys.exit(main())

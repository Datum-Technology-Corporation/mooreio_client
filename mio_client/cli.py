# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
import argparse
import pathlib
import sys
import os

from mio_client.commands import sim, ip, misc, project, team, user, web, gen
from mio_client.core.root_manager import RootManager

#######################################################################################################################
# User Manual Top
#######################################################################################################################
VERSION = "2.0.4"

HELP_TEXT = f"""
                                        Moore.io (`mio`) Client - v{VERSION}
                                    User Manual: http://mooreio-client.rtfd.io/
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
    Enables tracing outputs from mio.

Full Command List (`mio help CMD` for help on a specific command):
   Help and Shell/Editor Integration
      help           Prints documentation for mio commands
      
   Project and Code Management
      init           Creates essential files necessary for new Projects/IPs

   IP and Credentials Management
      install        Installs all IP dependencies from IP Marketplace
      login          Starts session with IP Marketplace
      package        Creates a compressed (and encrypted) archive of an IP
      publish        Publishes IP to Server (must have mio admin account)

   EDA Automation
      clean          Delete IP EDA artifacts and/or Moore.io Project directory contents (.mio)
      sim            Performs necessary steps to simulate an IP with any simulator
      regr           Runs regression against an IP
      dox            Generates source reference documentation with Doxygen"""


#######################################################################################################################
# Main
#######################################################################################################################
URL_BASE = 'https://mooreio.com'
URL_AUTHENTICATION = f'{URL_BASE}/auth/token'
TEST_MODE = False
USER_HOME_PATH = pathlib.Path(os.path.expanduser("~/.mio"))
root_manager: RootManager
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
    global root_manager

    try:
        parser = create_top_level_parser()
        subparsers = parser.add_subparsers(dest='command', help='Sub-command help')
        commands = register_all_commands(subparsers)
        args = parser.parse_args(args)
    except Exception as e:
        print(f"Error during parsing of CLI arguments: {e}", file=sys.stderr)
        return 1

    if args.version:
        print_version_text()
        return 0
    if (not args.command) or args.help:
        print_help_text()
        return 0

    command = next(
        (
            cmd for cmd in commands
            if cmd.name().lower() == args.command
        ),
        None
    )
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

    root_manager = RootManager("Moore.io Client Root Manager", wd, URL_BASE, URL_AUTHENTICATION, TEST_MODE, USER_HOME_PATH)
    command.parsed_cli_arguments = args

    if args.dbg:
        root_manager.print_trace = True

    return root_manager.run(command)


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
    register_commands(commands, sim.get_commands())
    register_commands(commands, ip.get_commands())
    register_commands(commands, misc.get_commands())
    register_commands(commands, project.get_commands())
    register_commands(commands, team.get_commands())
    register_commands(commands, user.get_commands())
    register_commands(commands, web.get_commands())
    register_commands(commands, gen.get_commands())
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


#######################################################################################################################
# Entry point
#######################################################################################################################
if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

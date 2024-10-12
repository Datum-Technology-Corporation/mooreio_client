# Copyright 2020-2024 Datum Technology Corporation
# All rights reserved.
#######################################################################################################################
from core.ip import Ip, IpDefinition, IpPkgType
from command import Command
from phase import Phase
from scheduler import JobScheduler
from service import ServiceType
from simulation import LogicSimulator, LogicSimulatorCompilationConfiguration, LogicSimulatorElaborationConfiguration, \
    LogicSimulatorCompilationAndElaborationConfiguration, LogicSimulatorSimulationConfiguration, UvmVerbosity
from simulation import LogicSimulatorCompilationReport, LogicSimulatorElaborationReport, LogicSimulatorCompilationAndElaborationReport, LogicSimulatorSimulationReport


SIM_HELP_TEXT = """Moore.io Logic Simulation Command
   Performs necessary steps to run simulation of an IP.  Only supports Digital Logic Simulation for the time being.
   
   An optional target may be specified for the IP. Ex: my_ip#target.
   
   While the controls for individual steps (DUT setup, compilation, elaboration and simulation) are exposed, it is
   recommended to let `mio sim` manage this process as much as possible.  In the event of corrupt simulator artifacts,
   see `mio clean`.  Combining any of the step-control arguments (-D, -C, -E, -S) with missing steps is illegal
   (ex: `-DS`).
   
   Two types of arguments (--args) can be passed: compilation (+define+NAME[=VALUE]) and simulation (+NAME[=VALUE]).
   
   For running multiple tests in parallel, see `mio regr`.
   
Usage:
   mio sim IP [OPTIONS] [--args ARG ...]
   
Options:
   -t TEST     , --test      TEST       Specify the UVM test to be run.
   -s SEED     , --seed      SEED       Positive Integer. Specify randomization seed  If none is provided, a random one will be picked.
   -v VERBOSITY, --verbosity VERBOSITY  Specifies UVM logging verbosity: none, low, medium, high, debug. [default: medium]
   -+ ARGS     , --args      ARGS       Specifies compilation-time (+define+ARG[=VAL]) or simulation-time (+ARG[=VAL]) arguments
   -e ERRORS   , --errors    ERRORS     Specifies the number of errors at which compilation/elaboration/simulation is terminated.  [default: 10]
   -a APP      , --app       APP        Specifies simulator application to use: viv, mdc, vcs, xcl, qst, riv. [default: viv]
   -w          , --waves                Enable wave capture to disk.
   -c          , --cov                  Enable code & functional coverage capture.
   -g          , --gui                  Invokes simulator in graphical or 'GUI' mode.
   
   -S   Simulate  target IP.
   -E   Elaborate target IP.
   -C   Compile   target IP.
   -D   Prepare Device-Under-Test (DUT) for logic simulation. Ex: invoke FuseSoC to prepare core(s) for compilation.
   
Examples:
   mio sim my_ip -t smoke -s 1 -w -c             # Compile, elaborate and simulate test 'my_ip_smoke_test_c'
                                                 # for IP 'my_ip' with seed '1' and waves & coverage capture enabled.
   mio sim my_ip -t smoke -s 1 --args +NPKTS=10  # Compile, elaborate and simulate test 'my_ip_smoke_test_c'
                                                 # for IP 'my_ip' with seed '1' and a simulation argument.
   mio sim my_ip -S -t smoke -s 42 -v high -g    # Only simulates test 'my_ip_smoke_test_c' for IP 'my_ip'
                                                 # with seed '42' and UVM_HIGH verbosity using the simulator in GUI mode.
   mio sim my_ip -C                              # Only compile 'my_ip'.
   mio sim my_ip -E                              # Only elaborate 'my_ip'.
   mio sim my_ip -CE                             # Compile and elaborate 'my_ip'."""


VERBOSITY_LEVELS = ["none","low","medium","high","debug"]
LOGIC_SIMULATORS = ["dsim"]


def get_commands():
    return [Simulate]


class Simulate(Command):
    @staticmethod
    def name() -> str:
        return "sim"

    @staticmethod
    def add_to_subparsers(subparsers):
        parser_sim = subparsers.add_parser('sim', help=SIM_HELP_TEXT, add_help=False)
        parser_sim.add_argument('ip'               , help='Target IP'                                                                                                                               )
        parser_sim.add_argument('-t', "--test"     , help='Delete compiled IP dependencies.'                                                                                        , required=False)
        parser_sim.add_argument('-s', "--seed"     , help='Specify the seed for constrained-random testing.  If none is provided, a random one will be picked.', type=int           , required=False)
        parser_sim.add_argument('-v', "--verbosity", help='Specify the UVM verbosity level for logging: none, low, medium, high or debug.  Default: medium'    , choices=VERBOSITY_LEVELS , required=False)
        parser_sim.add_argument('-e', "--errors"   , help='Specifies the number of errors at which compilation/elaboration/simulation is terminated.'          , type=int           , required=False)
        parser_sim.add_argument('-a', "--app"      , help='Specifies which simulator to use: dsim only one supported for now.'                                 , choices=LOGIC_SIMULATORS )
        parser_sim.add_argument('-w', "--waves"    , help='Enable wave capture to disk.'                                                                       , action="store_true", required=False)
        parser_sim.add_argument('-c', "--cov"      , help='Enable code & functional coverage capture.'                                                         , action="store_true", required=False)
        parser_sim.add_argument('-g', "--gui"      , help="Invoke the simulator's Graphical User Interface."                                                   , action="store_true", required=False)
        parser_sim.add_argument('-S'               , help='Force mio to simulate target IP.  Can be combined with -D, -C and/or -E.'                           , action="store_true", required=False)
        parser_sim.add_argument('-E'               , help='Force mio to elaborate target IP.  Can be combined with -D, -C and/or -S.'                          , action="store_true", required=False)
        parser_sim.add_argument('-C'               , help='Force mio to compile target IP.  Can be combined with -D, -E and/or -S.'                            , action="store_true", required=False)
        parser_sim.add_argument('-D'               , help='Force mio to prepare Device-Under-Test (DUT).  Can be combined with -C, -E and/or -S.'              , action="store_true", required=False)
        parser_sim.add_argument('-+', "--args"     , help='Add arguments for compilation (+define+NAME[=VALUE]) or simulation (+NAME[=VALUE])).', nargs='+'    , dest='add_args'    , required=False)

    _ip_definition: IpDefinition = None
    _ip: Ip = None
    _simulator: LogicSimulator = None
    _scheduler: JobScheduler = None
    _do_prepare_dut: bool = False
    _do_compile: bool = False
    _do_elaborate: bool = False
    _do_compile_and_elaborate: bool = False
    _do_simulate: bool = False
    _compilation_configuration: LogicSimulatorCompilationConfiguration
    _elaboration_configuration: LogicSimulatorElaborationConfiguration
    _compilation_and_elaboration_configuration: LogicSimulatorCompilationAndElaborationConfiguration
    _simulation_configuration: LogicSimulatorSimulationConfiguration
    _compilation_report: LogicSimulatorCompilationReport
    _elaboration_report: LogicSimulatorElaborationReport
    _compilation_and_elaboration_report: LogicSimulatorCompilationAndElaborationReport
    _simulation_report: LogicSimulatorSimulationReport
    _success:bool = False

    @property
    def simulator(self) -> LogicSimulator:
        return self._simulator

    @property
    def scheduler(self) -> JobScheduler:
        return self._scheduler

    @property
    def do_prepare_dut(self) -> bool:
        return self._do_prepare_dut
    @property
    def do_compile(self) -> bool:
        return self._do_compile
    @property
    def do_elaborate(self) -> bool:
        return self._do_elaborate
    @property
    def do_compile_and_elaborate(self) -> bool:
        return self._do_compile_and_elaborate
    @property
    def do_simulate(self) -> bool:
        return self._do_simulate

    @property
    def compilation_configuration(self) -> LogicSimulatorCompilationConfiguration:
        return self._compilation_configuration

    @property
    def elaboration_configuration(self) -> LogicSimulatorElaborationConfiguration:
        return self._elaboration_configuration

    @property
    def compilation_and_elaboration_configuration(self) -> LogicSimulatorCompilationAndElaborationConfiguration:
        return self._compilation_and_elaboration_configuration

    @property
    def simulation_configuration(self) -> LogicSimulatorSimulationConfiguration:
        return self._simulation_configuration

    @property
    def compilation_report(self) -> LogicSimulatorCompilationReport:
        return self._compilation_report

    @property
    def elaboration_report(self) -> LogicSimulatorElaborationReport:
        return self._elaboration_report

    @property
    def compilation_and_elaboration_report(self) -> LogicSimulatorCompilationAndElaborationReport:
        return self._compilation_and_elaboration_report

    @property
    def simulation_report(self) -> LogicSimulatorSimulationReport:
        return self._simulation_report

    @property
    def success(self) -> bool:
        return self._success

    @property
    def ip_definition(self) -> IpDefinition:
        return self._ip_definition

    @property
    def ip(self) -> Ip:
        return self._ip
    def needs_authentication(self) -> bool:
        return False

    def phase_init(self, phase:Phase):
        self._ip_definition = Ip.parse_ip_definition(self.parsed_cli_arguments.ip)
        if not self.parsed_cli_arguments.D and not self.parsed_cli_arguments.C and not self.parsed_cli_arguments.E and not self.parsed_cli_arguments.S:
            self._do_prepare_dut = True
            self._do_compile   = True
            self._do_elaborate = True
            self._do_simulate  = True
        else:
            if self.parsed_cli_arguments.D:
                self._do_prepare_dut = True
            else:
                self._do_prepare_dut = False
            if self.parsed_cli_arguments.C:
                self._do_compile = True
            else:
                self._do_compile = False
            if self.parsed_cli_arguments.E:
                self._do_elaborate = True
            else:
                self._do_elaborate = False
            if self.parsed_cli_arguments.S:
                self._do_simulate = True
            else:
                self._do_simulate = False

    def phase_post_validate_configuration_space(self, phase):
        if not self.parsed_cli_arguments.app:
            if not self.rmh.configuration.logic_simulation.default_simulator:
                phase.error = Exception(f"No simulator specified (-a/--app) and no default simulator in the Configuration")
                return
            else:
                self.parsed_cli_arguments.app = self.rmh.configuration.logic_simulation.default_simulator.value

    def phase_post_scheduler_discovery(self, phase:Phase):
        try:
            self._scheduler = self.rmh.scheduler_database.get_default_scheduler()
        except Exception as e:
            phase.error = e

    def phase_post_service_discovery(self, phase:Phase):
        try:
            self._simulator = self.rmh.service_database.find_service(ServiceType.LOGIC_SIMULATION, self.parsed_cli_arguments.app)
        except Exception as e:
            phase.error = e

    def phase_post_ip_discovery(self, phase:Phase):
        self._ip = self.rmh.ip_database.find_ip_definition(self.ip_definition, raise_exception_if_not_found=False)
        if not self.ip:
            phase.error = Exception(f"IP '{self.ip_definition}' could not be found")
        else:
            if self.do_simulate and (self.ip.ip.pkg_type != IpPkgType.DV_TB):
                phase.error = Exception(f"IP '{self.ip}' is not a Test Bench")
                return
            if self.ip.has_vhdl_content:
                # VHDL must be compiled and elaborated separately
                if self.do_compile_and_elaborate:
                    self._do_compile = True
                    self._do_elaborate = True
                    self._do_compile_and_elaborate = False
            else:
                if self.do_compile and self.do_elaborate:
                    self._do_compile = False
                    self._do_elaborate = False
                    self._do_compile_and_elaborate = True
    
    def phase_main(self, phase:Phase):
        if self.do_prepare_dut:
            self.prepare_dut(phase)
        if self.do_compile:
            self.compile(phase)
            if not self.compilation_report.success:
                self._do_elaborate = False
                self._do_simulate = False
        if self.do_elaborate:
            self.elaborate(phase)
            if not self.elaboration_report.success:
                self._do_simulate = False
        if self.do_compile_and_elaborate:
            self.compile_and_elaborate(phase)
            if not self.compilation_and_elaboration_report.success:
                self._do_simulate = False
        if self.do_simulate:
            self.simulate(phase)

    def prepare_dut(self, phase:Phase):
        pass

    def compile(self, phase:Phase):
        self._compilation_configuration = LogicSimulatorCompilationConfiguration()
        if self.parsed_cli_arguments.errors:
            self.compilation_configuration.max_errors = self.parsed_cli_arguments.errors
        if self.parsed_cli_arguments.waves:
            self.compilation_configuration.enable_waveform_capture = True
        if self.parsed_cli_arguments.cov:
            self.compilation_configuration.enable_coverage = True
        # TODO Parse and load values from CLI args into compilation config for boolean and value defines
        self._compilation_report = self.simulator.compile(self.ip, self.compilation_configuration, self.scheduler)

    def elaborate(self, phase:Phase):
        self._elaboration_configuration = LogicSimulatorElaborationConfiguration()
        self._elaboration_report = self.simulator.elaborate(self.ip, self.elaboration_configuration, self.scheduler)

    def compile_and_elaborate(self, phase:Phase):
        self._compilation_and_elaboration_configuration = LogicSimulatorCompilationAndElaborationConfiguration()
        # TODO Parse and load values from CLI args into compilation+elaboration config for boolean and value defines
        self._compilation_and_elaboration_report = self.simulator.compile_and_elaborate(self.ip, self.compilation_and_elaboration_configuration, self.scheduler)

    def simulate(self, phase:Phase):
        self._simulation_configuration = LogicSimulatorSimulationConfiguration()
        self.simulation_configuration.seed = self.parsed_cli_arguments.seed if self.parsed_cli_arguments.seed is not None else 1
        self.simulation_configuration.verbosity = self.parsed_cli_arguments.verbosity if self.parsed_cli_arguments.verbosity is not None else UvmVerbosity.MEDIUM
        self.simulation_configuration.max_errors = self.parsed_cli_arguments.errors if self.parsed_cli_arguments.errors is not None else 10
        self.simulation_configuration.gui_mode = self.parsed_cli_arguments.gui
        self.simulation_configuration.enable_waveform_capture = self.parsed_cli_arguments.waves
        self.simulation_configuration.enable_coverage = self.parsed_cli_arguments.cov
        self.simulation_configuration.test_name = self.parsed_cli_arguments.test.strip().lower()
        # TODO Parse and load values from CLI args into simulation config for boolean and value arguments
        self._simulation_report = self.simulator.simulate(self.ip, self.simulation_configuration, self.scheduler)

    def phase_report(self, phase:Phase):
        self._success = True
        if self.do_compile:
            self._success &= self.compilation_report.success
        if self.do_elaborate:
            self._success &= self.elaboration_report.success
        if self.do_compile_and_elaborate:
            self._success &= self.compilation_and_elaboration_report.success
        if self.do_simulate:
            self._success &= self.simulation_report.success
        if self.success:
            banner = f"{'*' * 53}\033[32m SUCCESS \033[0m{'*' * 54}"
        else:
            banner = f"{'*' * 53}\033[31m\033[4m FAILURE \033[0m{'*' * 54}"
        print(banner)
        if self.do_prepare_dut:
            self.print_prepare_dut_report(phase)
        if self.do_compile:
            self.print_compilation_report(phase)
        if self.do_elaborate:
            self.print_elaboration_report(phase)
        if self.do_compile_and_elaborate:
            self.print_compilation_and_elaboration_report(phase)
        if self.do_simulate:
            self.print_simulation_report(phase)
        print(banner)

    def phase_final(self, phase):
        if not self.success:
            phase.error = Exception(f"Logic Simulation failed.")

    def print_prepare_dut_report(self, phase:Phase):
        pass

    def print_compilation_report(self, phase:Phase):
        errors_str = f"\033[31m\033[1m{self.compilation_report.num_errors}E\033[0m" if self.compilation_report.num_errors > 0 else "0E"
        warnings_str = f"\033[33m\033[1m{self.compilation_report.num_errors}W\033[0m" if self.compilation_report.num_errors > 0 else "0W"
        fatal_str = f" \033[33m\033[1mF\033[0m" if self.compilation_report.num_fatals > 0 else ""
        if self.compilation_report.has_sv_files_to_compile and self.compilation_report.has_vhdl_files_to_compile:
            print(f" Compilation results - {errors_str} {warnings_str}{fatal_str}:")
            print(f"*     * {self.compilation_report.sv_log_path}")
            print(f"*     * {self.compilation_report.vhdl_log_path}")
        else:
            if self.compilation_report.has_sv_files_to_compile:
                print(f" Compilation results - {errors_str} {warnings_str}{fatal_str}: {self.compilation_report.sv_log_path}")
            if self.compilation_report.has_vhdl_files_to_compile:
                print(f" Compilation results - {errors_str} {warnings_str}{fatal_str}: {self.compilation_report.vhdl_log_path}")
        if not self.compilation_report.success:
            print('*' * 119)
            for error in self.compilation_report.errors:
                print(f"\033[31m{error}\033[0m")
            for fatal in self.compilation_report.fatals:
                print(f"\033[31m{fatal}\033[0m")
    
    def print_elaboration_report(self, phase:Phase):
        errors_str = f"\033[31m\033[1m{self.elaboration_report.num_errors}E\033[0m" if self.elaboration_report.num_errors > 0 else "0E"
        warnings_str = f"\033[33m\033[1m{self.elaboration_report.num_errors}W\033[0m" if self.elaboration_report.num_errors > 0 else "0W"
        fatal_str = f" \033[33m\033[1mF\033[0m" if self.elaboration_report.num_fatals > 0 else ""
        print(f" Elaboration results - {errors_str} {warnings_str}{fatal_str}: {self.elaboration_report.log_path}")
        if not self.elaboration_report.success:
            print('*' * 119)
            for error in self.elaboration_report.errors:
                print(f"\033[31m{error}\033[0m")
            for fatal in self.elaboration_report.fatals:
                print(f"\033[31m{fatal}\033[0m")
    
    def print_compilation_and_elaboration_report(self, phase:Phase):
        errors_str = f"\033[31m\033[1m{self.compilation_and_elaboration_report.num_errors}E\033[0m" if self.compilation_and_elaboration_report.num_errors > 0 else "0E"
        warnings_str = f"\033[33m\033[1m{self.compilation_and_elaboration_report.num_errors}W\033[0m" if self.compilation_and_elaboration_report.num_errors > 0 else "0W"
        fatal_str = f" \033[33m\033[1mF\033[0m" if self.compilation_and_elaboration_report.num_fatals > 0 else ""
        print(f" Compilation+Elaboration results - {errors_str} {warnings_str}{fatal_str}: {self.compilation_and_elaboration_report.log_path}")
        if not self.compilation_and_elaboration_report.success:
            print('*' * 119)
            for error in self.compilation_and_elaboration_report.errors:
                print(f"\033[31m{error}\033[0m")
            for fatal in self.compilation_and_elaboration_report.fatals:
                print(f"\033[31m{fatal}\033[0m")

    def print_simulation_report(self, phase:Phase):
        pass

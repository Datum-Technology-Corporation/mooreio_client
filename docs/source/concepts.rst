Concepts
========


Project
-------

A Project is a collection of IPs and the directories where simulation, linting, synthesis and other EDA task results are
stored. Only one Project is active at a time. The working directory from which ``mio`` is invoked must either be the
root of the Project or within a sub-directory.

A Project Descriptor file (``mio.toml``) in the root directory defines metadata specific for the Project.  This file
must contain the Project ``name``, ``full_name`` and ``sync``.  The latter denotes synchronization with the Moore.io
server.  The contents of this file are part of the Configuration Space and can set any parameter therein.


Sample Descriptor
*****************
::

  [project]
  sync     = false
  name     = "my_chip"
  full_name= "My Chip"

  [ip]
  local_paths=["rtl", "dv"]

  [logic_simulation]
  root_path="sim"
  uvm_version="1.2"

  [docs]
  root_path="docs"



Configuration Space
-------------------
The Configuration space is loaded from multiple ``mio.toml`` files which are merged into a final configuration space.
This information is then used in all further MIO operations.  The full Configuration Space is detailed in its own
section.



Directory Structure
*******************
Moore.io stores its internal files under ``.mio`` in the Project root directory.  These files are to be considered
read-only and should not be modified.  Any changes can lead to unpredictable behavior.  It is highly recommended to add
this directory to your Project ``.gitignore``.

IPs are by default stored under ``rtl`` and ``dv``.  These names are arbitrary and there is no obligation to store a
particular type of IP in one or the other.

Each EDA task has its own directory for results and reports, here are the defaults:

- Logic Simulation - ``sim``
- Documentation - ``docs``

Coming soon:

- Linting - ``lint``
- Synthesis - ``syn``
- Design for test - ``dft``
- Formal verification - ``fml``
- Place and route - ``pnr``
- Physical layout - ``lay``


IP
--
An IP is a described collection of source code, directories, and associated documentation files.  This descriptor is
captured using YAML and has a standard structure, regardless of its content.


Structure
*********

The standard structure is defined below:

- ``ip`` - Datasheet

  - ``sync`` - `Boolean` - Synchronized with https://www.mooreio.com
  - ``pkg_type`` - `Enum` - IP Type [``dv_lib``, ``dv_agent``, ``dv_env``, ``dv_tb``, ``lib``, ``block``, ``ss``, ``fpga``, ``chip``, ``system``, ``custom``]
  - ``vendor`` - `String` - (Short) Name of the Organization/User owning this IP.
  - ``name`` - `String` - (Short) Name
  - ``full_name`` - `String` - Descriptive name
  - ``version`` - `String` - Current version
  - ``sync_id`` - `Int` - (Optional) ID with https://www.mooreio.com
  - ``sync_revision`` - `String` - (Optional) Current synced version
  - ``encrypted`` - `List` - (Optional) List of simulators for which this IP provides encrypted HDL source
  - ``mlicensed`` - `Boolean` - (Optional) Indicates a license is required this IP

- ``structure`` - Paths for directory structure.

  - ``hdl_src_path`` - `String` - Location of HDL source code (SystemVerilog/VHDL).
  - ``docs_path`` - `String` - Location of documents for Doxygen to use when generating its reference documentation contents. Articles can be added by adding markdown (.md) files in this directory.
  - ``scripts_path`` - `String` - Location of scripts and misc. files.
  - ``examples_path`` - `String` - Location of sample code for users.

- ``hdl_src`` - Describes Hardware Description Language source code structure and data for compilation and simulation.

  - ``directories`` - `List` - Paths where source code is located, relative to ``src-path``. "``.``" equates the HDL source directory root.
  - ``top_sv_files`` - `List` - (Optional) Path to top SystemVerilog source file(s) for compilation.
  - ``top_vhdl_files`` - `List` - (Optional) Path to top VHDL source file(s) for compilation.
  - ``top`` - `List` - Name of top-level HDL module(s) for elaboration.
  - ``so_libs`` - `List` - Name of DPI Shared Objects ``.so`` to be loaded.  These must be located in the ``scripts_path`` directory of the IP.  Filename convention is ``<name>.<simulator>.so``.
  - ``tests_path`` - `String` - Path to tests source code files.  `Test Bench IPs only.`
  - ``tests_name_template`` - `String` - Jinja2 template with single argument: ``name`` describing the test naming convention for this IP.  `Test Bench IPs only.`

- ``dependencies`` - `List` - (Optional) IP dependencies.  Can include both local (project) and external (from Moore.io IP catalog).

  - ``"<Vendor>/<IP Name>" : "<VersionSpec>"`` - Where ``<IP Name>`` is the (short) name of an IP and ``<VersionSpec>`` is the required version of that IP via a semantic version spec.

- ``dut`` - (Optional) For Test Bench (``dv_tb``) IPs, the section describes the Device Under Test.

  - ``type`` - `Enum` - The DUT type (additional types coming soon): [``ip``]
  - ``name`` - `String` - IP (Short) Name.
  - ``version`` - `VersionSpec` - Semantic version spec for the DUT
  - ``target`` - `String` - Default target for the DUT

- ``targets`` - (Optional) List of IP Targets.

  - ``<Name> :`` - Target name. ``default`` is used when a target is not provided by the user

    - ``dut`` - `String` - DUT target name
    - ``cmp`` - `List` - Compilation arguments: `String` and `Boolean` are valid.
    - ``elab`` - `List` - Elaboration arguments (coming soon).
    - ``sim`` - `List` - Simulation arguments: `String` and `Boolean` are valid.



RTL IP Sample Descriptor
************************

The following is an IP descriptor for an Ethernet 100G MAC::

  ip:
     sync     : false
     pkg_type : ss
     vendor   : acme
     name     : eth_mac_100g
     full-name: 100G Ethernet MAC
     version  : 2.1.4

  dependencies:
    "datron/fec_lib": ">=1.2"
    "gigamicro/pcs_encoder": "5.1"

  structure:
     src-path: "src"

  hdl-src:
     directories: [".", "mac", "pcs", "fec"]
     top_sv_files: ["eth_100g_top.sv"]

  targets:
    default:
      cmp:
        PMA_WIDTH: 32
        INCLUDE_FEC: true
    fast:
      cmp:
        INCLUDE_FEC: false
    wide:
      cmp:
        PMA_WIDTH: 64



Test Bench IP Sample Descriptor
*******************************

The following is an IP descriptor for a Test Bench called '100G Ethernet MAC Sub-System'::

  ip:
    sync     : false
    pkg_type : dv_tb
    vendor   : acme
    name     : uvmt_eth_mac_100g
    full_name: 100G Ethernet MAC Sub-System Test Bench
    version  : 1.1.2

  dut:
    type: ip
    name: "acme/eth_mac_100g"
    version: *

  structure:
    scripts_path : "bin"
    docs_path    : "docs"
    examples_path: "examples"
    src_path     : "src"

  hdl_src:
    directories        : ["."]
    top_sv_files       : ["uvmt_eth_mac_100g_pkg.sv"]
    top                : ["uvmt_eth_mac_100g_tb"]
    tests_path         : "tests"
    tests_name_template: "uvmt_eth_mac_100g_{{ name }}_test_c"

  targets:
    default:
      dut: fast
      sim:
        NUM_PKTS: 10
    release:
      dut: default
      sim:
        NUM_PKTS: 1000






IP Marketplace
--------------
The Moore.io IP Marketplace hosts the IP catalog and its source code.  Developers interact with the marketplace primarily
via ``mio login``, ``mio install`` and ``mio publish``

License Types
*************
- Free & Open Source (FOS) - Free to list.  Source code and documentation stored on the Marketplace.
- Commercial - IPs that use the Moore.io IP Licensing System to charge end-user for IP.
- Private - Use Moore.io as your Private IP server; ideal for clean rooms and sites with restricted internet access.  Coming soon.




Test Suite
----------
Moore.io's regression system flips the script on the usual regression bash scripts of old.  Instead, Test Suite
descriptors (``ts.yml`` for default (single) target IPs, ``<Name>.ts.yml`` for multiple target IPs) describe several
regressions at once, with an inside-out approach of Test Sets and Test Groups.


Structure
*********
All test suites have 2 sections.  The metadata ``ts`` and the regression definitions  ``tests``.  ``mio`` does not
currently interface with scheduling engines such as GRID or LSF, but plans to in the near future.

The ``max_duration`` feature allows ``mio`` to prematurely end regressions via a hard time limit.  Simulations processes
are simply killed off.


Metadata
********
This section of the test suite contains the information necessary to run the regressions.

- ``ts`` - Test Suite Metadata

  - ``name`` - `String` - Descriptive name.  Ex: "Data Sub-System Test Suite for APB interconnect"
  - ``ip`` - `String` - Owner IP.  Ex: "uvmt_data_ss"
  - ``target`` - `List[String]` - Target Name.  Ex: "apb"
  - ``waves`` - `String[]` - List of regressions for which wave capture is enabled.  Ex: ``[sanity, bugs]``
  - ``cov`` - `String[]` - List of regressions for which coverage sampling is enabled.  Ex: ``[nightly, weekly]``
  - ``verbosity`` - `String[String]` - Dictionary mapping each regression with a UVM logging verbosity level.  Ex: ``{sanity:high, nightly:medium}``
  - ``max_duration`` - `Integer[Float]` - Dictionary mapping each regression with a timeout (specified in hours).  Ex: ``{sanity:1, nightly:5}``
  - ``max_jobs`` - `Integer[Integer]` - Dictionary mapping each regression with a limit on concurrent simulations.  Ex: ``{sanity:5, nightly:10}``

Regressions
***********
This section of the test suite defines the contents of the regressions.

- ``tests``

  - Test Set - Ex: ``functional`` - Top-level elements; encapsulate test groups.

      - Test - Ex: ``reg_bit_bash`` - The name of the test used must match what would be entered on the command line.

        - Regression Entry - `String` - Regression name.  Ex: ``sanity``

Regression Entries
******************
A regression entry can be either:

- `Int` - Amount of random seeds
- `List[Int]` - Specific seeds
- Default Group
- Named Groups

A Group is a pairing of ``seeds`` and ``args`` for specifying simulation arguments:

::

  smoke_test:
    group_a:
      seeds: 10
      args:
        ABC: 100
        DEF: false



Sample
******
::

  ts:
    name: Default
    ip: uvmt_eth_mac_100g
    target: ["*"]
    waves: [sanity, bugs]
    cov  : [nightly, weekly]
    max_errors  : { 'sanity':      1, 'nightly':       30, 'weekly':    30, 'bugs':       1 }
    verbosity   : { 'sanity': 'high', 'nightly': 'medium', 'weekly': 'low', 'bugs': 'debug' }
    max_duration: { 'sanity':    .25, 'nightly':        5, 'weekly':    12, 'bugs':       1 }
    max_jobs    : { 'sanity':      5, 'nightly':       10, 'weekly':    20, 'bugs':       1 }

  tests:
    functional:
      rand_traffic:
        sanity : [1]
        nightly: 10
        weekly : 50
      weekly :
        seeds: 50
        args :
          NUM_PKTS: 1000
      bugs: [5456984247]
      reg_hw_reset:
        sanity: [1]
        nightly: 1
        weekly: 1
      reg_bit_bash:
        sanity: [1]
        nightly: 1
        weekly: 1

    error:
      rand_err_traffic:
        sanity : [1]
        nightly: 10
        weekly :
          small_packets:
            seeds: 5
            args :
              MIN_PKT_SZ: 64
              MAX_PKT_SZ: 127
          large_packets:
            seeds: 5
            args :
              MIN_PKT_SZ: 256
              MAX_PKT_SZ: 512
       bugs: [
          8438499331868,
          6424554831489
       ]


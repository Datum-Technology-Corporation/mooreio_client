Commands
========

All commands can be prepended by ``--dbg`` to enable mio's debug printout.



Credentials Management
----------------------

login
*****

Description
^^^^^^^^^^^
Authenticates session with Moore.io Server.

Usage
^^^^^
``mio login [OPTIONS]``

Options
^^^^^^^
===============  =======================
``-u USERNAME``  ``--username USERNAME``  Specifies Moore.io username
``-n``           ``--no-input``           Specify credentials without a keyboard. Must be combined with `-u` and by setting the environment variable ``MIO_AUTHENTICATION_PASSWORD``
===============  =======================

Examples
^^^^^^^^
=====================================  ========
``mio login``                          Log in with prompts for username and password
``mio login -u user123``               Specify username inline and only get prompted for the password
``mio login -u user123 --no-input``    Authenticate without a keyboard (especially handy for CI)
=====================================  ========

logout
*****

Description
^^^^^^^^^^^
De-authenticates session with Moore.io Server.

Usage
^^^^^
``mio logout``



Documentation
-------------

dox
***

Description
^^^^^^^^^^^
Generates reference documentation from IP HDL source code using Doxygen.

Usage
^^^^^
``mio dox [IP]``


Examples
^^^^^^^^
=================  ===============
``mio dox my_ip``  Generates HTML documentation for IP ``my_ip``
``mio dox``        Generates HTML all local Project IPs
=================  ===============


help
****

Description
^^^^^^^^^^^
Prints out documentation on a specific command.

Usage
^^^^^
``mio help CMD``

Examples
^^^^^^^^
================  =====
``mio help sim``  Prints out a summary on the Logic Simulation command and its options
================  =====



EDA
---


clean
*****

Description
^^^^^^^^^^^
Deletes output artifacts from EDA tools and/or Moore.io Project directory contents ``.mio``.  Only logic simulation artifacts are currently supported.

Usage
^^^^^
``mio clean [IP] [OPTIONS]``

Options
^^^^^^^
================  =========================  ===========================
``-d``            ``--deep``                 Removes Project Moore.io directory ``.mio``
================  =========================  ===========================

Examples
^^^^^^^^
======================  ==============================
``mio clean my_ip``     Delete compilation, elaboration and simulation artifacts for IP 'my_ip'
``mio clean --deep``    Removes contents of Project Moore.io directory ``mio``
======================  ==============================



sim
***

Description
^^^^^^^^^^^
Performs necessary steps to run simulation of an IP.  Only supports Digital Logic Simulation for the time being.

An optional target may be specified for the IP. Ex: ``my_ip#target``.

While the controls for individual steps (DUT setup, compilation, elaboration and simulation) are exposed, it is
recommended to let `mio sim` manage this process as much as possible.  In the event of corrupt simulator artifacts,
see `mio clean`.  Combining any of the step-control arguments (``-D``, ``-X``, ``-C``, ``-E``, ``-S``) with missing steps is illegal
(ex: ``-DS``).

Two types of arguments (``--args``) can be passed: compilation (``+define+NAME[=VALUE]``) and simulation (``+NAME[=VALUE]``).

For running multiple tests in parallel, see ``mio regr``.

Usage
^^^^^
``mio sim IP[#TARGET] [OPTIONS] [--args ARG ...]``

Options
^^^^^^^
================  =========================  ===========================
``-t TEST``       ``--test TEST``            Specify the UVM test to be run.
``-s SEED``       ``--seed SEED``            Positive Integer. Specify randomization seed  If none is provided, a random one will be picked.
``-v VERBOSITY``  ``--verbosity VERBOSITY``  Specifies UVM logging verbosity: ``none``, ``low``, ``medium``, ``high``, ``full``, ``debug``. [default: ``medium``]
``-+ ARGS``       ``--args      ARGS``       Specifies compilation-time (``+define+ARG[=VAL]``) or simulation-time (``+ARG[=VAL]``) arguments
``-e ERRORS``     ``--errors    ERRORS``     Specifies the number of errors at which compilation/elaboration/simulation is terminated.  [default: ``10``]
``-a APP``        ``--app APP``              Specifies simulator application to use: ``dsim``, ``vivado``.
``-w``            ``--waves``                Enable wave capture to disk.
``-c``            ``--cov``                  Enable code & functional coverage capture.
``-g``            ``--gui``                  Invokes simulator in graphical or 'GUI' mode.
``-d DEST``       ``--dry-run   DEST``       Captures simulation command into tarball at DEST instead of invoking simulator.
================  =========================  ===========================

Steps
^^^^^
======  ======================================================
``-D``   Prepare Device-Under-Test (DUT) for logic simulation. Ex: invoke FuseSoC to prepare core(s) for compilation.
``-X``   Invoke Datum SiArx for code generation.
``-C``   Compile
``-E``   Elaborate
``-S``   Simulate
======  ======================================================


Examples
^^^^^^^^
================================================  =============
``mio sim my_ip -t smoke -s 1 -w -c``             Compile, elaborate and simulate test ``my_ip_smoke_test_c`` for IP ``my_ip`` with seed ``1`` and waves & coverage capture enabled.
``mio sim my_ip -t smoke -s 1 --args +NPKTS=10``  Compile, elaborate and simulate test ``my_ip_smoke_test_c`` for IP ``my_ip`` with seed ``1`` and a simulation argument.
``mio sim my_ip -S -t smoke -s 42 -v high -g``    Only simulates test ``my_ip_smoke_test_c`` for IP ``my_ip`` with seed ``42`` and ``UVM_HIGH`` verbosity using the simulator in GUI mode.
``mio sim my_ip -C``                              Only compile ``my_ip``.
``mio sim my_ip -E``                              Only elaborate ``my_ip``.
``mio sim my_ip -CE``                             Compile and elaborate ``my_ip``.
================================================  =============


regr
****

Description
^^^^^^^^^^^
Runs a regression (set of tests) against a specific IP.  Regressions are described in Test Suite files (``[<target>.]ts.yml``).

An optional target may be specified for the IP. Ex: ``my_ip#target``.

Usage
^^^^^
``mio regr IP[#TARGET] [TEST SUITE.]REGRESSION [OPTIONS]``

Options
^^^^^^^
======  =============  =============================================
``-d``  ``--dry-run``  Compiles, elaborates, but only prints the tests mio would normally run (does not actually run them).
======  =============  =============================================

Examples
^^^^^^^^
===================================  =====================
``mio regr my_ip sanity``            Run sanity regression for IP ``uvm_my_ip``, from test suite ``ts.yml``
``mio regr my_ip apb_xc.sanity``     Run sanity regression for IP ``uvm_my_ip``, from test suite ``apb_xc.ts.yml``
``mio regr my_ip axi_xc.sanity -d``  Dry-run sanity regression for IP ``uvm_my_ip``, from test suite ``axi_xc.ts.yml``
===================================  =====================



Generators
----------

init
****

Description
^^^^^^^^^^^
Creates a new Project skeleton if not already within a Project.  If so, a new IP skeleton is created.
This is the recommended method for importing code to the Moore.io ecosystem.

Usage
^^^^^
``mio init [OPTIONS]``

Options
^^^^^^^
======  ================  ==========================================================
``-i``  ``--input-file``  Specifies YAML input file path (instead of prompting user)
======  ================  ==========================================================

Examples
^^^^^^^^
=============================  ==========================================================
``mio init``                   Create a new empty Project/IP in this location.
``mio init -i ~/answers.yml``  Create a new empty Project/IP in this location with pre-filled data.
``mio -C ~/my_proj init``      Create a new empty Project at a specific location.
=============================  ==========================================================



siarx
*****

Description
^^^^^^^^^^^
Generates IP HDL code using Datum SiArx (requires license).  If not within an initialized Project, the ID must be
specified via ``-p/--project-id``.

Usage
^^^^^
``mio x [OPTIONS]``

Options
^^^^^^^
=========  ===================  ====================================================
``-p ID``  ``--project-id=ID``  Specifies Project ID when initializing a new project
``-f``     ``--force``          Overwrites user changes
=========  ===================  ====================================================


Examples
^^^^^^^^
================  =======================================================
``mio x``         Sync (generate) project with SiArx definition on server
``mio x -p 123``  Initialize and generate Project from empty directory
================  =======================================================










IP Management
-------------

install
*******

Description
^^^^^^^^^^^
Downloads IP(s) from Moore.io Server.  Can be used in 3 ways:

1. Without specifying an IP: install all missing dependencies for all IPs in the current Project
2. Specifying the name a local IP: install all missing dependencies for a specific IP in the current project
3. Specifying the name of an IP on the Moore.io Server: install remote IP and all its dependencies into the current Project


Usage
^^^^^
``mio install [IP] [OPTIONS]``

Options
^^^^^^^
===============  =======================  ==============
``-v SPEC``      ``--version SPEC``       Specifies IP version (only for remote IPs). Must specify IP when using this option.
===============  =======================  ==============

Examples
^^^^^^^^
=============================================  ================
``mio install``                                Install all dependencies for all IPs in the current Project
``mio install my_ip``                          Install all dependencies for a specific IP in the current Project
``mio install acme/abc``                       Install latest version of IP from Moore.io Server and its dependencies into current Project
``mio install acme/abc -v "1.2.3"``            Install specific version of IP from Moore.io Server and its dependencies into current Project
=============================================  ================

uninstall
*******

Description
^^^^^^^^^^^
Removes IP(s) installed in current Project.  Can be used in 3 ways:

1. Without specifying an IP: delete all installed dependencies for all IPs in the current Project
2. Specifying the name a local IP: delete all installed dependencies for a specific local IP in the current project
3. Specifying the name of an installed IP: delete installed IP and all its installed dependencies from the current Project


Usage
^^^^^
``mio uninstall [IP]``

Examples
^^^^^^^^
=============================================  ================
``mio uninstall``                              Delete all installed IPs in current project
``mio uninstall my_ip``                        Delete all installed dependencies for a specific local IP in the current project
``mio install acme/abc``                       Delete specific installed IP and all its installed dependencies from current project
=============================================  ================


package
*******

Description
^^^^^^^^^^^
Command for encrypting/compressing entire IP on local disk.  To enable IP encryption, add an 'encrypted' entry to the
``hdl_src`` section of your descriptor (ip.yml).  Moore.io will only attempt to encrypt using the simulators listed
under 'encrypted' of the 'ip' section.

Usage
^^^^^
``mio package IP DEST``

Examples
^^^^^^^^
==================================  ======
``mio package uvma_my_ip ~``        Create compressed archive of IP ``uvma_my_ip`` under user's home directory.
==================================  ======



publish
*******

Description
^^^^^^^^^^^
Packages and publishes an IP to the Moore.io IP Marketplace (https://mooreio.com).  Currently only available to administrator accounts.

Usage
^^^^^
``mio publish IP [OPTIONS]``

Options
^^^^^^^
===============  =======================  ==============
``-c ORG``       ``--customer ORG``       Specifies Customer Organization name.  Commercial IPs only.
===============  =======================  ==============

Examples
^^^^^^^^
==================================  ======
``mio publish uvma_my_ip``          Publish Public IP 'uvma_my_ip'.
``mio publish uvma_my_ip -c acme``  Publish Commercial IP 'uvma_my_ip' for customer 'acme'.
==================================  ======


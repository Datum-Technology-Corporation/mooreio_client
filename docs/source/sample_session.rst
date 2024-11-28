Sample Session
==============

This section outlines a command listing that should enable you to get an overview of the ``mio`` workflow and its
essential features.  This example assumes you are familiar with CLI basics.

0. Clone the sample session repository
--------------------------------------
1. The repository is available from GitHub: https://github.com/Datum-Technology-Corporation/mooreio_client_sample_session

  ``git clone https://github.com/Datum-Technology-Corporation/mooreio_client_sample_session.git mio_sample_session``


1. Check installation and view Documentation
--------------------------------------------

1. Ensure ``mio`` is installed and operational.  Display basic help text:

  ``mio --help``

2. Print the CLI manual for a command:

  ``mio help init``


2. Initialize a new Project
---------------------------
1. Move into Project root directory:

  ``cd mio_sample_session``

2. Initialize a new Project.  Creates ``mio.toml`` Project descriptor file and directory structure (if not present):

  ``mio init``


3. Initialize Design IP
-----------------------
1. Move into root directory of a design:

  ``cd rtl/example_design``

2. Initialize design IP:  creates ``ip.yml`` IP descriptor file:

  ``mio init``


4. Initialize Test Bench IP
---------------------------
1. Move into root directory of a test bench:

  ``cd dv/uvmt_example``

2. Initialize test bench IP.  Creates ``ip.yml`` IP descriptor and ``ts.yml`` Test Suite for defining regressions:

  ``mio init``



5. Install IP dependencies
--------------------------

1. Install the entire dependency tree from https://www.mooreio.com for a specific IP:

  ``mio install uvmt_example``



6. Run a simulation
-------------------

1. Run a test for a UVM test bench IP we initialized.

  ``mio sim uvmt_example -t rand_stim -s 1 -w -c -a dsim``

  - IP: ``uvmt_example``
  - Test Name: ``smoke``
  - Seed: ``1``
  - Waveform capture: ``Enabled``
  - Coverage sampling: ``Enabled``
  - Simulator: ``Metrics DSim``


2. View simulation results.

  All commands for viewing the results of a single test run are printed automatically to the terminal after simulation
  has ended.



7. Run a regression
-------------------

1. Clean up a work area. (Optional)

  ``mio clean uvmt_example``

  Deletes all compiled HDL code for block test bench, including external dependencies.  Whenever you encounter
  unexpected elaboration errors, run an ``mio clean`` command on your IP and try again.  Does not delete results.

2. Run ``sanity`` regression.

  ``mio regr uvmt_example sanity``

  - Runs `uvmt_example`'s Test Suite's "sanity" regression.
  - See command output for generated report locations (similar to simulation results).

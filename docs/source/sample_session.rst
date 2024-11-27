Sample Session
==============

This section outlines a command listing that should enable you to get an overview of the ``mio`` workflow and its
essential features.  This example assumes you are familiar with CLI basics.

Setup
-----

1. Ensure ``mio`` is installed and operational.  Displays basic help text.

  ``mio --help``


Initialize a new Project
------------------------
1. Create Project Root Directory.  Skip if importing existing codebase.

  ``mkdir test_chip``

2. Move into Project Root Directory.

  ``cd test_chip``

3. Initialize a new Project.  Creates ``mio.toml`` Project descriptor file and directory structure if not present.

  ``mio init``


Initialize Design IP
--------------------
1. Move into a Design IP Directory.

  ``cd rtl/example_design``

2. Initialize IP.  Creates ``ip.yml`` IP descriptor file.

  ``mio init``


Initialize DV IP
-----------------
1. Move into a Design Verification IP Directory.

  ``cd dv/uvm_example_tb``

2. Initialize IP.  Creates ``ip.yml`` IP descriptor file.

  ``mio init``



Run a simulation
----------------

1. Run a test for a UVM test bench IP we initialized.

  ``mio sim uvm_example_tb -t rand_stim -s 1 -w -c -a dsim``

  - IP: ``uvm_example_tb``
  - Test Name: ``rand_stim``
  - Seed: ``1``
  - Waveform capture: ``Enabled``
  - Coverage sampling: ``Enabled``
  - Simulator: ``Metrics DSim``


2. View simulation results.

  All commands for viewing the results of a single test run are printed automatically to the terminal after simulation
  has ended.



Run a regression
-------------------

1. Clean up the work area.

  ``mio clean uvm_example_tb``

  Deletes all compiled HDL code for block test bench, including external dependencies.  Whenever you encounter
  unexpected elaboration errors, run an ``mio clean`` command on your IP and try again.  Note: Does not delete results.

2. Run the ``sanity`` regression.

  ``mio regr uvm_example_tb sanity``

  - Runs `uvm_example_tb`'s test suite's "sanity" regression.
  - See command output for generated report locations (similar to simulation results).
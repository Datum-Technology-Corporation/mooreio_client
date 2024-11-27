Overview
============

The Moore.io Client is an open-source CLI tool designed to automate Electronic Design Automation (EDA) tasks encountered
during the development of ASIC, FPGA and UVM IP. This tool also serves as a client for the Moore.io Web Site
(https://mooreio.com), providing functionalities such as installing IP dependencies, generating UVM code and
packaging/publishing IPs.

Why?
----
The EDA (Electronic Design Automation) field clearly lags behind in terms of Free & Open-Source (FOS) developer tools
when compared to the software world. There is no FOS tool that can drive the various CAD software necessary and provide
the kind of automation needed to produce commercial-grade FPGA and ASIC designs. Instead, homebrew (and seldom shared)
Makefiles and Shell scripts rule the field of DevOps in semiconductors.

The Problem
***********
Writing a Makefile/Shell script that can perform all the tasks required to create a Chip Design is a LARGE job. Since
these languages do not come with any meaningful libraries, the end result is a mess of patched, brittle code painful to
maintain/debug, yet on which every engineering task directly depends. These issues are usually compounded by
copying the project Makefile/Shell script from project to project; thus losing all Git history while commenting
out old code and adding to the mess.

Surely, there must be a better way ...

The Solution
************
The Moore.io Client is a FOS Command Line Interface (CLI) tool implemented in Python 3, using Object-Oriented
Practices, strong typing, unit testing, and a modular architecture that will be very familiar to UVM engineers: the
primary target audience of this tool. The Client, invoked via `mio`, has all the features you would expect from a
"Project Makefile" at a high-end Semiconductor engineering firm AND all the best features from Software package
managers:

 * The concept of a Project, which is identified by a `mio.toml` file in its root directory
 * A layered Configuration Space defined with TOML files (`mio.toml`) at the user (`~/.mio/mio.toml`) and project levels
 * Packaging of HDL source file into IPs (Intellectual Property) identified by `ip.yml` descriptors in their root directory
 * Performing tasks at the IP-level, including generating code, specifying and installing dependencies
 * Ability to drive all Logic Simulators (VCS, XCelium, Questa, Vivado, Metrics DSim, Riviera-PRO) with a single set of commands and parameters
 * A feature-driven Test Suite schema for specifying Regressions in UVM Test Benches, AND the ability to run these Regressions on Job Schedulers (LSF, GRID, etc.)
 * Built-in compatibility with Continuous Integration (CI) tools like Jenkins

How much does it cost?
----------------------
The EDA Automation and Package management is Free & Open-Source. Some commands, such as UVM Code Generation, "phone
home" to the Moore.io Server and therefore require a User Account (which can be created at
https://mooreio.com/register) and a license for Datum UVMx. However, the tool operates independently of the site in all
other regards and can be used without authentication to build a Chip from start to finish.

Configuration Space
===================

``mio`` behavior is controlled by the configuration space, which is obtained from multiple sources, in decreasing precedence:

- Command line parameters - ``-c <name>=<value>`` or ``--config=<name>=<value>`` - `Coming soon`
- Project configuration file - ``<PROJECT ROOT PATH>/mio.toml``
- User configuration file - ``~/.mio/mio.toml``
- Built-in defaults - ``<MOOREIO CLIENT INSTALLATION PATH>/data/mio.toml``


applications
--------------

editor
*******

- Required: Yes
- Type: ``Path``
- Default: ``vim``

Default text editor.

web_browser
*******

- Required: Yes
- Type: ``Path``
- Default: ``firefox``

Default web browser.



authentication
--------------

offline
*******

- Required: Yes
- Type: ``Boolean``
- Default: ``false``

Prohibits ``mio`` from attempting to authenticate with the Moore.io Server.



docs
----

.. _doxygen_installation_path:
doxygen_installation_path
*****************

- Required: No
- Type: ``Path``

Path to ``doxygen`` installation directory.



root_path
*****************

- Required: Yes
- Type: ``Path``
- Default: ``docs``

Directory for Project documents.  Doxygen outputs to ``./doxygen_output`` under this directory.




encryption
----------

altair_dsim_sv_key_path
***************

- Required: No
- Type: ``Path``
- Example: ``/tools/dsim_sv.key``

Absolute path to location of Altair DSim SystemVerilog encryption key file.  This must be set in order to encrypt IP using DSim.
See https://help.Altair.ca/support/solutions/articles/154000141181-user-guide-dsim-ieee-1735-encryption-verilog-and-vhdl- for more information.

altair_dsim_vhdl_key_path
***************

- Required: No
- Type: ``Path``
- Example: ``/tools/dsim_vhdl.key``

Absolute path to location of Altair DSim VHDL encryption key file.  This must be set in order to encrypt IP using DSim.
See https://help.Altair.ca/support/solutions/articles/154000141181-user-guide-dsim-ieee-1735-encryption-verilog-and-vhdl- for more information.


xilinx_vivado_key_path
**********************

- Required: Yes
- Type: ``Path``
- Example: ``/tools/viv.key``

Absolute path to location of Xilinx Vivado encryption key file.  This must be set in order to encrypt IP using vivado.
See https://www.xilinx.com/products/intellectual-property/ip-encryption.html for more information.



ip
--

global_paths
************

- Required: Yes
- Type: ``List[Path]``
- Default: ``[]``

`mio` searches these absolute paths for IP descriptors.


local_paths
***********

- Required: Yes
- Type: ``List[Path]``
- Default: ``["dv","rtl"]``

`mio` searches these relative (to the project root) paths for IP descriptors.  The names used are irrelevant to the IP
types contained therein.  Ex: DV IPs could be stored under ``rtl`` and vice-versa with no impact on functionality.


lint
----

root_path
*********

- Required: Yes
- Type: ``Path``
- Default: ``lint``

Project-relative path to directory where HDL linting results and reports are stored.


project
-------

sync
****

- Required: Yes
- Type: ``Boolean``
- Default: ``false``

Denotes synchronization with the Moore.io Server.

sync_id
*******

- Required: No
- Type: ``Int``

Synchronization ID with the Moore.io Server.  Only present when ``sync`` is ``true``.

local_mode
**********

- Required: Yes
- Type: ``Boolean``
- Default: ``false``

Prohibits ``mio`` from attempting to make HTTP requests.

name
****

- Required: Yes
- Type: ``String``
- Example: ``chip_123``

Short name for the current project.  Cannot contain spaces.



full_name
*********

- Required: Yes
- Type: ``String``
- Example: ``Chip 123``

Descriptive name for the current project.


description
***********

- Required: No
- Type: ``String``
- Example: ``Chip for 123 clients``

Descriptive text for the current project.



logic_simulation
----------------

compilation_timeout
*****************

- Required: Yes
- Type: ``Float``
- Default: ``1.0``

Timeout for compilation jobs.  Measured in hour(s).

compilation_and_elaboration_timeout
*****************

- Required: Yes
- Type: ``Float``
- Default: ``1.0``

Timeout for compilation+elaboration jobs.  Measured in hour(s).



default_simulator
*****************

- Required: No
- Type: ``String``

Simulator used when invoking the ``sim`` command without specifying ``-a APP`` ``--app APP``.



elaboration_timeout
*****************

- Required: Yes
- Type: ``Float``
- Default: ``1.0``

Timeout for elaboration jobs.  Measured in hour(s).



logs_directory
**************

- Required: Yes
- Type: ``String``
- Default: ``results``

Name of directory where compilation and elaboration results are output.  This directory is always created directly under ``root_path``.


altair_dsim_default_compilation_and_elaboration_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``["+acc+b", "-suppress MultiBlockWrite:ReadingOutputModport", "-warn UndefinedMacro:DupModuleDefn"]``

Compilation arguments always passed to Altair DSim during compilation+elaboration.


altair_dsim_default_compilation_sv_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``["-suppress MultiBlockWrite:ReadingOutputModport:UndefinedMacro"]``

Compilation arguments always passed to Altair DSim during SystemVerilog compilation.


altair_dsim_default_compilation_vhdl_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``[]``

Compilation arguments always passed to Altair DSim during VHDL compilation.


altair_dsim_default_elaboration_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``["+acc+b", "-suppress DupModuleDefn"]``

Compilation arguments always passed to Altair DSim during elaboration.


altair_dsim_default_simulation_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``[]``

Compilation arguments always passed to Altair DSim during simulation.


.. _altair_dsim_license_path:
altair_dsim_license_path
************************

- Required: No
- Type: ``Path``

Path to Altair DSim Desktop license key.


.. _altair_dsim_cloud_installation_path:
altair_dsim_cloud_installation_path
************************

- Required: No
- Type: ``Path``

Path to Altair DSim Cloud simulator installation directory.


.. _altair_dsim_installation_path:
altair_dsim_installation_path
************************

- Required: No
- Type: ``Path``

Path to Altair DSim Desktop installation directory.


root_path
*********

- Required: Yes
- Type: ``Path``
- Default: ``sim``

Project-relative path to directory where HDL simulations results and reports are stored.


regression_directory_name
*************************

- Required: Yes
- Type: ``String``
- Default: ``regr``

Name of directory where regressions results are stored.  This directory is always created directly under ``root_path``.


results_directory_name
**********************

- Required: Yes
- Type: ``String``
- Default: ``results``

Name of directory where immediate results are stored.  This directory is always created directly under ``root_path``.



simulation_timeout
******************

- Required: Yes
- Type: ``Float``
- Default: ``1.0``

Timeout for simulation jobs.  Measured in hour(s).


test_result_path_template
*************************

- Required: Yes
- Type: ``String``
- Default: ``{{ ip }}{{ target }}_{{ test }}_{{ seed }}{% if args %}_{% for arg in args %}{{ arg }}_{% endfor %}{% endif %}``

Jinja2 template used to generate the directory names for IP simulation test results.


timescale
*********

- Required: Yes
- Type: ``String``
- Default: ``1ns/1ps``

Simulation timescale specified to the simulator via command line.


uvm_version
***********

- Required: Yes
- Type: ``String``
- Default: ``1.2``

Specifies the version of UVM to be used during simulation.


.. _vscode_installation_path:
vscode_installation_path
************************

- Required: No
- Type: ``Path``

Path to Microsoft VSCode installation directory.  Used by ``dsim`` to view ``.mxd`` waveform files.


xilinx_vivado_default_compilation_sv_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``["--incr"]``

Compilation arguments always passed to Xilinx Vivado during SystemVerilog compilation.


xilinx_vivado_default_compilation_vhdl_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``[]``

Compilation arguments always passed to Xilinx Vivado during VHDL compilation.


xilinx_vivado_default_elaboration_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``["--incr", "-relax", "--O0", "-dup_entity_as_module"]``

Compilation arguments always passed to Xilinx Vivado during elaboration.


xilinx_vivado_default_simulation_arguments
************************

- Required: Yes
- Type: ``List[String]``
- Default: ``["--stats"]``

Compilation arguments always passed to Xilinx Vivado during simulation.


.. _xilinx_vivado_installation_path:
xilinx_vivado_installation_path
************************

- Required: No
- Type: ``Path``

Path to Xilinx Vivado installation directory.





logic_synthesis
---------------

root_path
*********

- Required: Yes
- Type: ``Path``
- Default: ``syn``

Project-relative path to directory where logic synthesis results and reports are stored.
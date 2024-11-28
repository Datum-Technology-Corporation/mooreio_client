Installation
============

The Moore.io client is installed using ``pip`` (version ``>=3``):

``pip install mooreio_client``

To install/publish IP, generate UVM code as well as other features, a Moore.io User Account is required: https://www.mooreio.com/register


Tools
=====

The Moore.io client currently supports the following tools, which must be installed separately:

- `Metrics DSim Desktop <https://help.metrics.ca/support/solutions/articles/154000141162-install-dsim-desktop>`_
- `Metrics DSim Cloud <https://www.metrics.ca/get-started>`_
- `Xilinx Vivado <https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/>`_
- `Doxygen <https://www.doxygen.nl/manual/install.html>`_

To make these available, variables in the Configuration Space must be set:

- Metrics DSim Desktop: :ref:`metrics_dsim_license_path` :ref:`metrics_dsim_installation_path` :ref:`vscode_installation_path`
- Metrics DSim Cloud: :ref:`metrics_dsim_cloud_installation_path`
- Xilinx Vivado: :ref:`xilinx_vivado_installation_path`
- Doxygen: :ref:`doxygen_installation_path`

Example User Configuration
**************************

Save the following to ``~/.mio/mio.toml``:

::

  [logic_simulation]
  default_simulator="dsim"
  metrics_dsim_license_path="~/metrics-ca/dsim/license.json"
  metrics_dsim_installation_path="~/metrics-ca/dsim/20240422.9.0"
  metrics_dsim_cloud_installation_path="/usr/local/bin"
  xilinx_vivado_installation_path="/tools/vivado/2024.2/Vivado/2024.2"
  compilation_timeout=1.0
  compilation_and_elaboration_timeout=1.0
  elaboration_timeout=1.0
  simulation_timeout=1.0

  [applications]
  editor="emacs"
  web_browser="firefox"

  [docs]
  doxygen_installation_path="/usr/bin"


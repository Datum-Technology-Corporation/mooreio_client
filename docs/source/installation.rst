Installation
============

The Moore.io client is installed using 'pip' (version >=3):

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

- Metrics DSim Desktop: :ref:`metrics_dsim_license_path` :ref:`metrics_dsim_installation_path`
- Metrics DSim Cloud: :ref:`metrics_dsim_cloud_installation_path`
- Xilinx Vivado: :ref:`xilinx_vivado_installation_path`
- Doxygen: :ref:`doxygen_installation_path`

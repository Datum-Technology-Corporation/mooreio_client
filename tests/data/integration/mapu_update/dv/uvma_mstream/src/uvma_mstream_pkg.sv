// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_PKG_SV__
`define __UVMA_MSTREAM_PKG_SV__


/**
 * @defgroup uvma_mstream_pkg Matrix Stream Interface UVM Agent
 * @{
 * @defgroup uvma_mstream_comps Components
 * @defgroup uvma_mstream_misc  Miscellaneous
 * @defgroup uvma_mstream_obj   Objects
 * @defgroup uvma_mstream_seq   Sequences & Sequence Items
 * @}
 */


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvmx_macros.svh"
`include "uvma_mstream_macros.svh"
// pragma uvmx pkg_macros begin
`include "uvml_math_macros.svh"
// pragma uvmx pkg_macros end

// Interface(s)
`include "uvma_mstream_if.sv"
// pragma uvmx pkg_interfaces begin
// pragma uvmx pkg_interfaces end


/**
 * Encapsulates all the types needed for a UVM agent capable of driving and monitoring a Matrix Stream Interface interface.
 * @ingroup uvma_mstream_pkg
 */
package uvma_mstream_pkg;

   import uvm_pkg::*;
   import uvmx_pkg::*;

   // pragma uvmx pkg_start begin
   import uvml_math_pkg::*;
   // pragma uvmx pkg_start end

   // Constants / Structs / Enums
   `include "uvma_mstream_ftdecs.sv"
   `include "uvma_mstream_tdefs.sv"
   `include "uvma_mstream_constants.sv"

   // Objects
   `include "uvma_mstream_cfg.sv"
   `include "uvma_mstream_cntxt.sv"

   // Sequence Items and Monitor Transactions
   `include "uvma_mstream_pkt_seq_item.sv"
   `include "uvma_mstream_pkt_seq_item.sv"
   `include "uvma_mstream_pkt_mon_trn.sv"
   `include "uvma_mstream_host_ig_seq_item.sv"
   `include "uvma_mstream_card_ig_seq_item.sv"
   `include "uvma_mstream_host_eg_seq_item.sv"
   `include "uvma_mstream_card_eg_seq_item.sv"
   `include "uvma_mstream_ig_mon_trn.sv"
   `include "uvma_mstream_eg_mon_trn.sv"

   // Components
   `include "uvma_mstream_host_ig_drv.sv"
   `include "uvma_mstream_card_ig_drv.sv"
   `include "uvma_mstream_host_eg_drv.sv"
   `include "uvma_mstream_card_eg_drv.sv"
   `include "uvma_mstream_ig_mon.sv"
   `include "uvma_mstream_eg_mon.sv"
   `include "uvma_mstream_sqr.sv"
   `include "uvma_mstream_drv.sv"
   `include "uvma_mstream_mon.sv"
   `include "uvma_mstream_logger.sv"
   `include "uvma_mstream_agent.sv"

   // Sequences
   `include "uvma_mstream_base_seq.sv"
   `include "uvma_mstream_ig_mon_seq.sv"
   `include "uvma_mstream_eg_mon_seq.sv"
   `include "uvma_mstream_idle_drv_seq.sv"
   `include "uvma_mstream_pkt_drv_seq.sv"
   `include "uvma_mstream_rx_drv_seq.sv"
   `include "uvma_mstream_pkt_seq_lib.sv"

   // pragma uvmx pkg_end begin
   // pragma uvmx pkg_end end

endpackage


// Module(s) / Checker(s)
// pragma uvmx pkg_modules begin
// pragma uvmx pkg_modules end
`include "uvma_mstream_if_chkr.sv"


`endif // __UVMA_MSTREAM_PKG_SV__
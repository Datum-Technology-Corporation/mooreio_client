// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_PKG_SV__
`define __UVMA_MAPU_B_PKG_SV__


/**
 * @defgroup uvma_mapu_b_pkg Matrix APU Block UVM Agent
 * @{
 * @defgroup uvma_mapu_b_comps Components
 * @defgroup uvma_mapu_b_misc  Miscellaneous
 * @defgroup uvma_mapu_b_obj   Objects
 * @defgroup uvma_mapu_b_seq   Sequences & Sequence Items
 * @}
 */


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvmx_macros.svh"
`include "uvma_mapu_b_macros.svh"
// pragma uvmx pkg_macros begin
`include "uvml_math_macros.svh"
// pragma uvmx pkg_macros end

// Interface(s)
`include "uvma_mapu_b_if.sv"
// pragma uvmx pkg_interfaces begin
// pragma uvmx pkg_interfaces end


/**
 * Encapsulates all the types needed for a UVM agent capable of driving and monitoring a Matrix APU interface.
 * @ingroup uvma_mapu_b_pkg
 */
package uvma_mapu_b_pkg;

   import uvm_pkg::*;
   import uvmx_pkg::*;

   // pragma uvmx pkg_start begin
   import uvml_math_pkg::*;
   // pragma uvmx pkg_start end

   // Constants / Structs / Enums
   `include "uvma_mapu_b_ftdecs.sv"
   `include "uvma_mapu_b_tdefs.sv"
   `include "uvma_mapu_b_constants.sv"

   // Objects
   `include "uvma_mapu_b_cfg.sv"
   `include "uvma_mapu_b_cntxt.sv"

   // Sequence Items and Monitor Transactions
   `include "uvma_mapu_b_op_seq_item.sv"
   `include "uvma_mapu_b_op_seq_item.sv"
   `include "uvma_mapu_b_ig_mon_trn.sv"
   `include "uvma_mapu_b_eg_mon_trn.sv"
   `include "uvma_mapu_b_dpi_seq_item.sv"
   `include "uvma_mapu_b_dpo_seq_item.sv"
   `include "uvma_mapu_b_cp_seq_item.sv"
   `include "uvma_mapu_b_dpi_mon_trn.sv"
   `include "uvma_mapu_b_dpo_mon_trn.sv"
   `include "uvma_mapu_b_cp_mon_trn.sv"

   // Components
   `include "uvma_mapu_b_dpi_drv.sv"
   `include "uvma_mapu_b_dpo_drv.sv"
   `include "uvma_mapu_b_cp_drv.sv"
   `include "uvma_mapu_b_dpi_mon.sv"
   `include "uvma_mapu_b_dpo_mon.sv"
   `include "uvma_mapu_b_cp_mon.sv"
   `include "uvma_mapu_b_sqr.sv"
   `include "uvma_mapu_b_drv.sv"
   `include "uvma_mapu_b_mon.sv"
   `include "uvma_mapu_b_logger.sv"
   `include "uvma_mapu_b_agent.sv"

   // Sequences
   `include "uvma_mapu_b_base_seq.sv"
   `include "uvma_mapu_b_ig_mon_seq.sv"
   `include "uvma_mapu_b_eg_mon_seq.sv"
   `include "uvma_mapu_b_idle_drv_seq.sv"
   `include "uvma_mapu_b_ig_drv_seq.sv"
   `include "uvma_mapu_b_eg_drv_seq.sv"
   // pragma uvmx pkg_end begin
   // pragma uvmx pkg_end end

endpackage


// Module(s) / Checker(s)
// pragma uvmx pkg_modules begin
// pragma uvmx pkg_modules end
`include "uvma_mapu_b_if_chkr.sv"


`endif // __UVMA_MAPU_B_PKG_SV__
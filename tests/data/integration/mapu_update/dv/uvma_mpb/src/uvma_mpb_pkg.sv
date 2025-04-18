// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_PKG_SV__
`define __UVMA_MPB_PKG_SV__


/**
 * @defgroup uvma_mpb_pkg Matrix Peripheral Bus UVM Agent
 * @{
 * @defgroup uvma_mpb_comps Components
 * @defgroup uvma_mpb_misc  Miscellaneous
 * @defgroup uvma_mpb_obj   Objects
 * @defgroup uvma_mpb_reg   Register Modeling
 * @defgroup uvma_mpb_seq   Sequences & Sequence Items
 * @}
 */


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvmx_macros.svh"
`include "uvma_mpb_macros.svh"
// pragma uvmx pkg_macros begin
// pragma uvmx pkg_macros end

// Interface(s)
`include "uvma_mpb_if.sv"
// pragma uvmx pkg_interfaces begin
// pragma uvmx pkg_interfaces end


/**
 * Encapsulates all the types needed for a UVM agent capable of driving and monitoring a Matrix Peripheral Bus interface.
 * @ingroup uvma_mpb_pkg
 */
package uvma_mpb_pkg;

   import uvm_pkg::*;
   import uvmx_pkg::*;

   // pragma uvmx pkg_start begin
   // pragma uvmx pkg_start end

   // Constants / Structs / Enums
   `include "uvma_mpb_ftdecs.sv"
   `include "uvma_mpb_tdefs.sv"
   `include "uvma_mpb_constants.sv"

   // Objects
   `include "uvma_mpb_cfg.sv"
   `include "uvma_mpb_cntxt.sv"

   // Sequence Items and Monitor Transactions
   `include "uvma_mpb_access_seq_item.sv"
   `include "uvma_mpb_access_seq_item.sv"
   `include "uvma_mpb_access_mon_trn.sv"
   `include "uvma_mpb_main_p_seq_item.sv"
   `include "uvma_mpb_sec_p_seq_item.sv"
   `include "uvma_mpb_p_mon_trn.sv"

   // Components
   `include "uvma_mpb_main_p_drv.sv"
   `include "uvma_mpb_sec_p_drv.sv"
   `include "uvma_mpb_p_mon.sv"
   `include "uvma_mpb_sqr.sv"
   `include "uvma_mpb_drv.sv"
   `include "uvma_mpb_mon.sv"
   `include "uvma_mpb_logger.sv"
   `include "uvma_mpb_agent.sv"

   // Sequences
   `include "uvma_mpb_base_seq.sv"
   `include "uvma_mpb_access_mon_seq.sv"
   `include "uvma_mpb_idle_drv_seq.sv"
   `include "uvma_mpb_access_drv_seq.sv"
   `include "uvma_mpb_rsp_drv_seq.sv"
   `include "uvma_mpb_rsp_seq_lib.sv"

   // Register-related
   `include "uvma_mpb_reg_adapter.sv"

   // pragma uvmx pkg_end begin
   // pragma uvmx pkg_end end

endpackage


// Module(s) / Checker(s)
// pragma uvmx pkg_modules begin
// pragma uvmx pkg_modules end
`include "uvma_mpb_if_chkr.sv"


`endif // __UVMA_MPB_PKG_SV__
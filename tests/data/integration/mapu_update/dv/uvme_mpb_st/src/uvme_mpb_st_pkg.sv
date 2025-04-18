// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_PKG_SV__
`define __UVME_MPB_ST_PKG_SV__


/**
 * @defgroup uvme_mpb_st_pkg  Block UVM Environment
 * @{
 * @defgroup uvme_mpb_st_comps Components
 * @defgroup uvme_mpb_st_misc  Miscellaneous
 * @defgroup uvme_mpb_st_obj   Objects
 * @defgroup uvme_mpb_st_seq   Sequences
 * @{
 * @defgroup uvme_mpb_st_seq_functional   Functional
 * @}
 * @}
 */


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvmx_macros.svh"
`include "uvma_mpb_macros.svh"
`include "uvme_mpb_st_macros.svh"


// pragma uvmx pkg_pre begin
// pragma uvmx pkg_pre end


 /**
 * Encapsulates all the types of the Matrix Peripheral Bus UVM Agent Self-Test Environment.
 * @ingroup uvme_mpb_st_pkg
 */
package uvme_mpb_st_pkg;

   import uvm_pkg::*;
   import uvmx_pkg::*;
   import uvma_mpb_pkg::*;

   // pragma uvmx pkg_start begin
   // pragma uvmx pkg_start end

   // Constants / Structs / Enums
   `include "uvme_mpb_st_ftdecs.sv"
   `include "uvme_mpb_st_tdefs.sv"
   `include "uvme_mpb_st_constants.sv"

   // Objects
   `include "uvme_mpb_st_reg_block.sv"
   `include "uvme_mpb_st_cfg.sv"
   `include "uvme_mpb_st_cntxt.sv"

   // Components
   `include "uvme_mpb_st_sqr.sv"
   `include "uvme_mpb_st_prd.sv"
   `include "uvme_mpb_st_sb.sv"
   `include "uvme_mpb_st_cov_model.sv"
   `include "uvme_mpb_st_env.sv"

   // Sequences
   `include "uvme_mpb_st_seq_lib.sv"

   // pragma uvmx pkg_end begin
   // pragma uvmx pkg_end end

endpackage


// pragma uvmx pkg_modules begin
// pragma uvmx pkg_modules end


`endif // __UVME_MPB_ST_PKG_SV__
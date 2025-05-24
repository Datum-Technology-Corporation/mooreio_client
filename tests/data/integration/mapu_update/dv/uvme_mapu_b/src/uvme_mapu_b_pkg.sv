// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_PKG_SV__
`define __UVME_MAPU_B_PKG_SV__


/**
 * @defgroup uvme_mapu_b_pkg Matrix APU Block UVM Environment
 * @{
 * @defgroup uvme_mapu_b_comps Components
 * @defgroup uvme_mapu_b_misc  Miscellaneous
 * @defgroup uvme_mapu_b_obj   Objects
 * @defgroup uvme_mapu_b_seq   Sequences
 * @{
 * @defgroup uvme_mapu_b_seq_functional   Functional
 * @defgroup uvme_mapu_b_seq_error   Error
 * @}
 * @}
 */


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvmx_macros.svh"
`include "uvma_mapu_b_macros.svh"
`include "uvme_mapu_b_macros.svh"


// pragma uvmx pkg_pre begin
// pragma uvmx pkg_pre end


 /**
 * Encapsulates all the types of the Matrix APU Block UVM environment.
 * @ingroup uvme_mapu_b_pkg
 */
package uvme_mapu_b_pkg;

   import uvm_pkg::*;
   import uvmx_pkg::*;
   import uvma_mapu_b_pkg::*;

   // pragma uvmx pkg_start begin
   // pragma uvmx pkg_start end

   // Constants / Structs / Enums
   `include "uvme_mapu_b_ftdecs.sv"
   `include "uvme_mapu_b_tdefs.sv"
   `include "uvme_mapu_b_constants.sv"

   // Objects
   `include "uvme_mapu_b_cfg.sv"
   `include "uvme_mapu_b_cntxt.sv"

   // Components
   `include "uvme_mapu_b_sqr.sv"
   `include "uvme_mapu_b_prd.sv"
   `include "uvme_mapu_b_sb.sv"
   `include "uvme_mapu_b_cov_model.sv"
   `include "uvme_mapu_b_env.sv"

   // Sequences
   `include "uvme_mapu_b_seq_lib.sv"

   // pragma uvmx pkg_end begin
   // pragma uvmx pkg_end end

endpackage


// pragma uvmx pkg_modules begin
// pragma uvmx pkg_modules end


`endif // __UVME_MAPU_B_PKG_SV__
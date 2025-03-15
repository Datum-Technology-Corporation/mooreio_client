// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_PKG_SV__
`define __UVMT_MAPU_B_PKG_SV__


/**
 * @defgroup uvmt_mapu_b_pkg Matrix APU Block UVM Test Bench
 * @{
 * @defgroup uvmt_mapu_b_misc   Miscellaneous
 * @defgroup uvmt_mapu_b_tb     Test Bench
 * @defgroup uvmt_mapu_b_tests  Tests
 * @{
 * @defgroup uvmt_mapu_b_tests_functional   Functional
 * @defgroup uvmt_mapu_b_tests_error   Error
 * @}
 * @}
 */


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvmx_macros.svh"
`include "uvma_clk_macros.svh"
`include "uvma_reset_macros.svh"
`include "uvma_mapu_b_macros.svh"
`include "uvme_mapu_b_macros.svh"
`include "uvmt_mapu_b_macros.svh"


// pragma uvmx pkg_pre begin
// pragma uvmx pkg_pre end


/**
 * Encapsulates the test library of the Matrix APU Block Self-Test Bench.
 * @ingroup uvmt_mapu_b_st_pkg
 */
package uvmt_mapu_b_pkg;

   import uvm_pkg::*;
   import uvmx_pkg::*;
   import uvma_clk_pkg::*;
   import uvma_reset_pkg::*;
   import uvma_mapu_b_pkg::*;
   import uvme_mapu_b_pkg::*;

   // pragma uvmx pkg_start begin
   // pragma uvmx pkg_start end

   // Constants / Structs / Enums
   `include "uvmt_mapu_b_ftdecs.sv"
   `include "uvmt_mapu_b_tdefs.sv"
   `include "uvmt_mapu_b_constants.sv"

   // Base test
   `include "uvmt_mapu_b_test_cfg.sv"
   `include "uvmt_mapu_b_base_test.sv"

   // Tests
   `include "uvmt_mapu_b_fix_stim_test.sv"
   `include "uvmt_mapu_b_fix_ill_stim_test.sv"
   `include "uvmt_mapu_b_rand_stim_test.sv"
   `include "uvmt_mapu_b_rand_ill_stim_test.sv"

   // pragma uvmx pkg_end begin
   // pragma uvmx pkg_end end

endpackage


// Module(s) / Checker(s)
// pragma uvmx pkg_modules begin
// pragma uvmx pkg_modules end
`include "uvmt_mapu_b_dut_wrap.sv"
`include "uvmt_mapu_b_tb.sv"


`endif // __UVMT_MAPU_B_PKG_SV__
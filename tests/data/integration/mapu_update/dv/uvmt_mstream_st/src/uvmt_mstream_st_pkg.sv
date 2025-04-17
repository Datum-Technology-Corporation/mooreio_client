// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MSTREAM_ST_PKG_SV__
`define __UVMT_MSTREAM_ST_PKG_SV__


/**
 * @defgroup uvmt_mstream_st_pkg Matrix Stream Interface UVM Agent Self-Test Bench
 * @{
 * @defgroup uvmt_mstream_st_misc   Miscellaneous
 * @defgroup uvmt_mstream_st_tb     Test Bench
 * @defgroup uvmt_mstream_st_tests  Tests
 * @{
 * @defgroup uvmt_mstream_st_tests_functional   Functional
 * @}
 * @}
 */


// Pre-processor macros
`include "uvm_macros.svh"
`include "uvmx_macros.svh"
`include "uvma_clk_macros.svh"
`include "uvma_reset_macros.svh"
`include "uvma_mstream_macros.svh"
`include "uvme_mstream_st_macros.svh"
`include "uvmt_mstream_st_macros.svh"


// pragma uvmx pkg_pre begin
// pragma uvmx pkg_pre end


/**
 * Encapsulates the test library of the Matrix Stream Interface UVM Agent Self-Test Bench.
 * @ingroup uvmt_mstream_st_pkg
 */
package uvmt_mstream_st_pkg;

   import uvm_pkg::*;
   import uvmx_pkg::*;
   import uvma_clk_pkg::*;
   import uvma_reset_pkg::*;
   import uvma_mstream_pkg::*;
   import uvme_mstream_st_pkg::*;

   // pragma uvmx pkg_start begin
   // pragma uvmx pkg_start end

   // Constants / Structs / Enums
   `include "uvmt_mstream_st_ftdecs.sv"
   `include "uvmt_mstream_st_tdefs.sv"
   `include "uvmt_mstream_st_constants.sv"

   // Base test
   `include "uvmt_mstream_st_test_cfg.sv"
   `include "uvmt_mstream_st_base_test.sv"

   // Tests
   `include "uvmt_mstream_st_fix_stim_test.sv"
   `include "uvmt_mstream_st_rand_stim_test.sv"

   // pragma uvmx pkg_end begin
   // pragma uvmx pkg_end end

endpackage


// Module(s) / Checker(s)
// pragma uvmx pkg_modules begin
// pragma uvmx pkg_modules end
`include "uvmt_mstream_st_dut_wrap.sv"
`include "uvmt_mstream_st_tb.sv"


`endif // __UVMT_MSTREAM_ST_PKG_SV__
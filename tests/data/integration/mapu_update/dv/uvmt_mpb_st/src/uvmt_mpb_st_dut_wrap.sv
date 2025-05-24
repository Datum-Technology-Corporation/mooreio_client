// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MPB_ST_DUT_WRAP_SV__
`define __UVMT_MPB_ST_DUT_WRAP_SV__


/**
 * "DUT" connecting Matrix Peripheral Bus UVM Agent Self-Test Bench interfaces.  All ports are SV interfaces.
 * @ingroup uvmt_mpb_st_tb
 */
module uvmt_mpb_st_dut_wrap (
   uvma_mpb_if  main_if, ///< MAIN Agent interface
   uvma_mpb_if  sec_if, ///< SEC Agent interface
   uvma_mpb_if  passive_if, ///< Passive Agent interface
   uvma_clk_if  clock_if, ///< Clock interface
   uvma_reset_if  rst_if ///< Reset interface
);

   assign sec_if.vld = main_if.vld;
   assign passive_if.vld = main_if.vld;
   assign sec_if.wr = main_if.wr;
   assign passive_if.wr = main_if.wr;
   assign sec_if.wdata = main_if.wdata;
   assign passive_if.wdata = main_if.wdata;
   assign sec_if.addr = main_if.addr;
   assign passive_if.addr = main_if.addr;
   assign main_if.rdy = sec_if.rdy;
   assign passive_if.rdy = sec_if.rdy;
   assign main_if.rdata = sec_if.rdata;
   assign passive_if.rdata = sec_if.rdata;


   // pragma uvmx dut_wrap begin
   // pragma uvmx dut_wrap end

endmodule


`endif // __UVMT_MPB_ST_DUT_WRAP_SV__
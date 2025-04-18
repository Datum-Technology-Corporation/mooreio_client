// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MPB_ST_TB_SV__
`define __UVMT_MPB_ST_TB_SV__


/**
 * Module encapsulating the Matrix Peripheral Bus UVM Agent Self-Test "DUT" wrapper, agents and clock generating interfaces.
 * @ingroup uvmt_mpb_st_tb
 */
module uvmt_mpb_st_tb;

   import uvm_pkg ::*;
   import uvmx_pkg::*;
   import uvmt_mpb_st_pkg::*;

   /// @name Clock & Reset
   /// @{
   logic  clk; ///< Clock
   logic  reset_n; ///< Reset
   uvma_clk_if    clk_if(); ///< Clock interface
   uvma_reset_if  reset_n_if(.clk(clk)); ///< Reset interface
   assign clk = clk_if.clk;
   assign reset_n = reset_n_if.reset_n;
   /// @}

   uvma_mpb_if           main_if(.*); ///< MAIN Agent interface
   uvma_mpb_if           sec_if(.*); ///< SEC Agent interface
   uvma_mpb_if           passive_if(.*); ///< Passive Agent interface
   uvmt_mpb_st_dut_wrap  dut_wrap(.*); ///< "DUT" wrapper instance
   bind uvmt_mpb_st_dut_wrap : dut_wrap  uvma_mpb_if_chkr passive_if_chkr(.agent_if(passive_if)); ///< Checker instantiation and binding

   /**
    * Test Bench entry point.
    */
   initial begin
      uvm_config_db#(virtual uvma_clk_if)::set(null, "uvm_test_top.clk_agent", "vif", clk_if);
      uvm_config_db#(virtual uvma_reset_if)::set(null, "uvm_test_top.reset_n_agent", "vif", reset_n_if);
      uvm_config_db#(virtual uvma_mpb_if)::set(null, "uvm_test_top.env.main_agent", "vif", main_if);
      uvm_config_db#(virtual uvma_mpb_if)::set(null, "uvm_test_top.env.sec_agent", "vif", sec_if);
      uvm_config_db#(virtual uvma_mpb_if)::set(null, "uvm_test_top.env.passive_agent", "vif", passive_if);
      uvmx_top.run_test();
   end

   // pragma uvmx tb begin
   // pragma uvmx tb end

endmodule


`endif // __UVMT_MPB_ST_TB_SV__
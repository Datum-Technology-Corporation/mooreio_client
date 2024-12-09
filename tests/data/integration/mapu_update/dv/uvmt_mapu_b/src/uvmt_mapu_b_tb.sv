// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_TB_SV__
`define __UVMT_MAPU_B_TB_SV__


/**
 * Module encapsulating the Matrix APU Block DUT wrapper, agents and clock generating interfaces.
 * @ingroup uvmt_mapu_b_tb
 */
module uvmt_mapu_b_tb;

   import uvm_pkg ::*;
   import uvmx_pkg::*;
   import uvmt_mapu_b_pkg::*;

   /// @name Clock & Reset
   /// @{
   logic  clk; ///< Clock
   logic  reset_n; ///< Reset
   uvma_clk_if    clk_if(); ///< Clock interface
   uvma_reset_if  reset_n_if(.clk(clk)); ///< Reset interface
   assign clk = clk_if.clk;
   assign reset_n = reset_n_if.reset_n;
   /// @}

   uvma_mapu_b_if agent_if(.*); ///< Block Agent interface
   uvmt_mapu_b_dut_wrap  dut_wrap(.*); ///< DUT wrapper instance
   bind uvmt_mapu_b_dut_wrap : dut_wrap  uvma_mapu_b_if_chkr chkr(.*); ///< Checker instantiation and binding

   /**
    * Test Bench entry point.
    */
   initial begin
      uvm_config_db#(virtual uvma_clk_if)::set(null, "uvm_test_top.clk_agent", "vif", clk_if);
      uvm_config_db#(virtual uvma_reset_if)::set(null, "uvm_test_top.reset_n_agent", "vif", reset_n_if);
      uvm_config_db#(virtual uvma_mapu_b_if)::set(null, "uvm_test_top.env.agent", "vif", agent_if);
      uvmx_top.run_test();
   end

   // pragma uvmx tb begin
   // pragma uvmx tb end

endmodule


`endif // __UVMT_MAPU_B_TB_SV__
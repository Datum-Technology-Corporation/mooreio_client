// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MSTREAM_ST_TB_SV__
`define __UVMT_MSTREAM_ST_TB_SV__


/**
 * Module encapsulating the Matrix Stream Interface UVM Agent Self-Test "DUT" wrapper, agents and clock generating interfaces.
 * @ingroup uvmt_mstream_st_tb
 */
module uvmt_mstream_st_tb;

   import uvm_pkg ::*;
   import uvmx_pkg::*;
   import uvmt_mstream_st_pkg::*;

   /// @name Clock & Reset
   /// @{
   logic  sys_clk; ///< System
   logic  reset_n; ///< Reset
   uvma_clk_if    sys_clk_if(); ///< System interface
   uvma_reset_if  reset_n_if(.clk(sys_clk)); ///< Reset interface
   assign sys_clk = sys_clk_if.clk;
   assign reset_n = reset_n_if.reset_n;
   /// @}

   uvma_mstream_if           host_if(.*); ///< HOST Agent interface
   uvma_mstream_if           card_if(.*); ///< CARD Agent interface
   uvma_mstream_if           passive_if(.*); ///< Passive Agent interface
   uvmt_mstream_st_dut_wrap  dut_wrap(.*); ///< "DUT" wrapper instance
   bind uvmt_mstream_st_dut_wrap : dut_wrap  uvma_mstream_if_chkr passive_if_chkr(.agent_if(passive_if)); ///< Checker instantiation and binding

   /**
    * Test Bench entry point.
    */
   initial begin
      uvm_config_db#(virtual uvma_clk_if)::set(null, "uvm_test_top.sys_clk_agent", "vif", sys_clk_if);
      uvm_config_db#(virtual uvma_reset_if)::set(null, "uvm_test_top.reset_n_agent", "vif", reset_n_if);
      uvm_config_db#(virtual uvma_mstream_if)::set(null, "uvm_test_top.env.host_agent", "vif", host_if);
      uvm_config_db#(virtual uvma_mstream_if)::set(null, "uvm_test_top.env.card_agent", "vif", card_if);
      uvm_config_db#(virtual uvma_mstream_if)::set(null, "uvm_test_top.env.passive_agent", "vif", passive_if);
      uvmx_top.run_test();
   end

   // pragma uvmx tb begin
   // pragma uvmx tb end

endmodule


`endif // __UVMT_MSTREAM_ST_TB_SV__
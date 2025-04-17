// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MSTREAM_ST_DUT_WRAP_SV__
`define __UVMT_MSTREAM_ST_DUT_WRAP_SV__


/**
 * "DUT" connecting Matrix Stream Interface UVM Agent Self-Test Bench interfaces.  All ports are SV interfaces.
 * @ingroup uvmt_mstream_st_tb
 */
module uvmt_mstream_st_dut_wrap (
   uvma_mstream_if  host_if, ///< HOST Agent interface
   uvma_mstream_if  card_if, ///< CARD Agent interface
   uvma_mstream_if  passive_if, ///< Passive Agent interface
   uvma_clk_if  sys_clk_if, ///< System interface
   uvma_reset_if  reset_n_if ///< Reset interface
);

   // Ingress
   assign card_if.ig_vld = host_if.ig_vld;
   assign passive_if.ig_vld = host_if.ig_vld;
   assign card_if.ig_r0 = host_if.ig_r0;
   assign passive_if.ig_r0 = host_if.ig_r0;
   assign card_if.ig_r1 = host_if.ig_r1;
   assign passive_if.ig_r1 = host_if.ig_r1;
   assign card_if.ig_r2 = host_if.ig_r2;
   assign passive_if.ig_r2 = host_if.ig_r2;
   assign host_if.ig_rdy = card_if.ig_rdy;
   assign passive_if.ig_rdy = card_if.ig_rdy;

   // Egress
   assign card_if.eg_rdy = host_if.eg_rdy;
   assign passive_if.eg_rdy = host_if.eg_rdy;
   assign host_if.eg_vld = card_if.eg_vld;
   assign passive_if.eg_vld = card_if.eg_vld;
   assign host_if.eg_r0 = card_if.eg_r0;
   assign passive_if.eg_r0 = card_if.eg_r0;
   assign host_if.eg_r1 = card_if.eg_r1;
   assign passive_if.eg_r1 = card_if.eg_r1;
   assign host_if.eg_r2 = card_if.eg_r2;
   assign passive_if.eg_r2 = card_if.eg_r2;


   // pragma uvmx dut_wrap begin
   // pragma uvmx dut_wrap end

endmodule


`endif // __UVMT_MSTREAM_ST_DUT_WRAP_SV__
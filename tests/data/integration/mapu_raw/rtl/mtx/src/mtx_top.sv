// Copyright 2023 Acme Enterprises Inc.
// All rights reserved.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __MTX_TOP_SV__
`define __MTX_TOP_SV__


`include "mtx_macros.svh"


/**
 * Matrix Sub-System Top.
 */
module mtx_top # (
   parameter NUM_CH = 32,
   parameter DATA_WIDTH = 32
) (
   input  [(NUM_CH-1):0][(DATA_WIDTH-1):0]  i_dp_ig_r0, i_dp_ig_r1, i_dp_ig_r2,
   output [(NUM_CH-1):0][(DATA_WIDTH-1):0]  o_dp_eg_r0, o_dp_eg_r1, o_dp_eg_r2,
   input  [(NUM_CH-1):0]  i_dp_ig_vld, i_dp_eg_rdy,
   output [(NUM_CH-1):0]  o_dp_eg_vld, o_dp_ig_rdy,
   input  [31:0]  i_cp_addr, i_cp_wdata,
   output [31:0]  o_cp_rdata,
   input   i_cp_vld, i_cp_wr,
   output  o_cp_rdy,
   input  test_mode_en,
   input  sys_clk, sys_rst_n
);

   generate
      for (genvar ii=0; ii<NUM_CH; ii++) begin : gen_mapu_u
         mapu_top #(
            .DATA_WIDTH(DATA_WIDTH)
         ) mapu_u (
            .clk(sys_clk),
            .reset_n(sys_rst_n)
         );
      end
   endgenerate

endmodule: mtx_top


`endif // __MTX_TOP_SV__
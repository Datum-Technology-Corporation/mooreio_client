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
   input sys_clk, sys_rst_n, test_mode_en
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
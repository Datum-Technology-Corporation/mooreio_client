// Copyright 2023 Acme Enterprises Inc.
// All rights reserved.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __MTX_TOP_SV__
`define __MTX_TOP_SV__


`include "mtx_macros.svh"


/**
 *
 */
module mtx_top # (
   parameter NUM_CH = 32,
   parameter DATA_WIDTH = 32
) (
   input sys_clk, sys_rst_n, test_mode_en
);


endmodule: mtx_top


`endif // __MTX_TOP_SV__
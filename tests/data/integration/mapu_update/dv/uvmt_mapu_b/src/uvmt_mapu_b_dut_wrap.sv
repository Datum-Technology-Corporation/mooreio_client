// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_DUT_WRAP_SV__
`define __UVMT_MAPU_B_DUT_WRAP_SV__


/**
 * Module wrapper for Matrix APU Block DUT.  All ports are SV interfaces.
 * @ingroup uvmt_mapu_b_tb
 */
module uvmt_mapu_b_dut_wrap (
   uvma_mapu_b_if  agent_if, ///< Block signals
   uvma_clk_if  clk_if, ///< Clock interface
   uvma_reset_if  reset_n_if ///< Reset interface
);

   /**
    * Matrix APU Device Under Test from IP 'mapu'.
    */
   mapu_top #(
      .DATA_WIDTH(`UVMT_MAPU_B_DATA_WIDTH)
   ) dut (
      .clk(clk_if.clk),
      .reset_n(reset_n_if.reset_n)
   );

   // pragma uvmx dut_wrap begin
   // pragma uvmx dut_wrap end

endmodule


`endif // __UVMT_MAPU_B_DUT_WRAP_SV__
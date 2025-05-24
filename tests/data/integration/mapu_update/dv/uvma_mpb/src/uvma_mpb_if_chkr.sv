// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_IF_CHKR_SV__
`define __UVMA_MPB_IF_CHKR_SV__


/**
 * Module encapsulating assertions targeting Matrix Peripheral Bus Agent interface.
 * @ingroup uvma_mpb_pkg
 */
module uvma_mpb_if_chkr #(
   parameter int unsigned  DATA_WIDTH = `UVMA_MPB_DATA_WIDTH_MAX,
   parameter int unsigned  ADDR_WIDTH = `UVMA_MPB_ADDR_WIDTH_MAX
) (
   uvma_mpb_if  agent_if ///< Target interface
);

   // pragma uvmx interface_checker begin
   // Ex: /**
   //      * 'xyz' must assert within 1 cycle of 'abc' asserting, and stay asserted until 'abc' is de-asserted
   //.     */
   //     property abc_xyz;
   //        @(posedge agent_if.clk) disable iff (agent_if.reset_n === 0)
   //           $rose(agent_if.abc) |-> ##[0:1] (agent_if.xyz[*1:$] ##0 $fell(agent_if.abc));
   //     endproperty
   //     `uvmx_assert_cover(abc_xyz)
   // pragma uvmx interface_checker end

endmodule


`endif // __UVMA_MPB_IF_CHKR_SV__
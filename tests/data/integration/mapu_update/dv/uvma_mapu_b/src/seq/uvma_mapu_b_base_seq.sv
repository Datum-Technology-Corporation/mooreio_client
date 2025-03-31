// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_BASE_SEQ_SV__
`define __UVMA_MAPU_B_BASE_SEQ_SV__


/**
 * Abstract Sequence from which all Matrix APU Agent Sequences must extend.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_base_seq_c extends uvmx_agent_seq_c #(
   .T_CFG     (uvma_mapu_b_cfg_c  ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c),
   .T_SQR     (uvma_mapu_b_sqr_c  ),
   .T_SEQ_ITEM(uvma_mapu_b_op_seq_item_c)
);

   `uvm_object_utils(uvma_mapu_b_base_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_base_seq");
      super.new(name);
   endfunction

   // pragma uvmx base_seq_methods begin
   // pragma uvmx base_seq_methods end

endclass


`endif // __UVMA_MAPU_B_BASE_SEQ_SV__
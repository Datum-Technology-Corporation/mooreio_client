// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_BASE_SEQ_SV__
`define __UVMA_MPB_BASE_SEQ_SV__


/**
 * Abstract Sequence from which all Matrix Peripheral Bus Agent Sequences must extend.
 * @ingroup uvma_mpb_seq
 */
class uvma_mpb_base_seq_c extends uvmx_agent_seq_c #(
   .T_CFG     (uvma_mpb_cfg_c  ),
   .T_CNTXT   (uvma_mpb_cntxt_c),
   .T_SQR     (uvma_mpb_sqr_c  ),
   .T_SEQ_ITEM(uvma_mpb_access_seq_item_c)
);

   `uvm_object_utils(uvma_mpb_base_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_base_seq");
      super.new(name);
   endfunction

   // pragma uvmx base_seq_methods begin
   // pragma uvmx base_seq_methods end

endclass


`endif // __UVMA_MPB_BASE_SEQ_SV__
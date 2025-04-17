// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_BASE_SEQ_SV__
`define __UVMA_MSTREAM_BASE_SEQ_SV__


/**
 * Abstract Sequence from which all Matrix Stream Interface Agent Sequences must extend.
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_base_seq_c extends uvmx_agent_seq_c #(
   .T_CFG     (uvma_mstream_cfg_c  ),
   .T_CNTXT   (uvma_mstream_cntxt_c),
   .T_SQR     (uvma_mstream_sqr_c  ),
   .T_SEQ_ITEM(uvma_mstream_pkt_seq_item_c)
);

   `uvm_object_utils(uvma_mstream_base_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_base_seq");
      super.new(name);
   endfunction

   // pragma uvmx base_seq_methods begin
   // pragma uvmx base_seq_methods end

endclass


`endif // __UVMA_MSTREAM_BASE_SEQ_SV__
// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_PKT_BASE_SEQ_SV__
`define __UVMA_MSTREAM_PKT_BASE_SEQ_SV__


/**
 * 
 * @ingroup uvma_mstream_seq_pkt
 */
class uvma_mstream_pkt_base_seq_c extends uvma_mstream_base_seq_c;

   `uvm_object_utils(uvma_mstream_pkt_base_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_pkt_base_seq");
      super.new(name);
   endfunction

   // pragma uvmx pkt_base_seq_methods begin
   // pragma uvmx pkt_base_seq_methods end

endclass


`endif // __UVMA_MSTREAM_PKT_BASE_SEQ_SV__
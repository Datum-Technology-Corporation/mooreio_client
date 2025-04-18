// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_ACCESS_MON_SEQ_SV__
`define __UVMA_MPB_ACCESS_MON_SEQ_SV__


/**
 * Access: Parses bus operations
 * @ingroup uvma_mpb_seq
 */
class uvma_mpb_access_mon_seq_c extends uvma_mpb_base_seq_c;

   `uvm_object_utils(uvma_mpb_access_mon_seq_c)
   `uvmx_mon_seq(uvma_mpb_access_mon_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_access_mon_seq");
      super.new(name);
   endfunction

   // pragma uvmx access_mon_seq_monitor_dox begin
   /**
    * TODO Implement uvma_mpb_access_mon_seq_c::monitor()
    */
   // pragma uvmx access_mon_seq_monitor_dox end
   task monitor();
      // pragma uvmx access_mon_seq_monitor begin
      uvma_mpb_access_mon_trn_c  access_trn;
      uvma_mpb_p_mon_trn_c  p_trn;
      forever begin
         `uvmx_get_mon_trn(p_trn, p_mon_trn_fifo)
         if ((p_trn.vld === 1) && (p_trn.rdy === 1)) begin
            `uvmx_create_mon_trn(access_trn, uvma_mpb_access_mon_trn_c)
            access_trn.from(p_trn);
            access_trn.address = p_trn.addr;
            if (p_trn.wr === 0) begin
               access_trn.op = UVMA_MPB_OP_READ;
               access_trn.data = p_trn.rdata;
            end
            else if (p_trn.wr === 1) begin
               access_trn.op = UVMA_MPB_OP_WRITE;
               access_trn.data = p_trn.wdata;
            end
            `uvmx_write_mon_trn(access_trn, access_mon_trn_fifo)
         end
      end
      // pragma uvmx access_mon_seq_monitor end
   endtask

   // pragma uvmx access_mon_seq_methods begin
   // pragma uvmx access_mon_seq_methods end

endclass


`endif // __UVMA_MPB_ACCESS_MON_SEQ_SV__
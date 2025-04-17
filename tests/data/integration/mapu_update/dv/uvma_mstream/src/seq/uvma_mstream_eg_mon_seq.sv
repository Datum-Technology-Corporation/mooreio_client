// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_EG_MON_SEQ_SV__
`define __UVMA_MSTREAM_EG_MON_SEQ_SV__


/**
 * Egress: Parses packets in egress direction.
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_eg_mon_seq_c extends uvma_mstream_base_seq_c;

   `uvm_object_utils(uvma_mstream_eg_mon_seq_c)
   `uvmx_mon_seq(uvma_mstream_eg_mon_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_eg_mon_seq");
      super.new(name);
   endfunction

   // pragma uvmx eg_mon_seq_monitor_dox begin
   /**
    * TODO Implement uvma_mstream_eg_mon_seq_c::monitor()
    */
   // pragma uvmx eg_mon_seq_monitor_dox end
   task monitor();
      // pragma uvmx eg_mon_seq_monitor begin
      uvma_mstream_eg_mon_trn_c   eg_trn;
      uvma_mstream_pkt_mon_trn_c  pkt;
      int unsigned  row_count;
      forever begin
        row_count = 0;
        `uvmx_create_mon_trn(pkt, uvma_mstream_pkt_mon_trn_c)
        do begin
           `uvmx_get_mon_trn(eg_trn, eg_mon_trn_fifo)
           if ((eg_trn.eg_vld === 1) && (eg_trn.eg_rdy === 1)) begin
              pkt.from(eg_trn);
              pkt.direciton = UVMA_MSTREAM_DIR_EG;
              pkt.matrix.seti(row_count, 0, cfg.data_width, eg_trn.eg_r0);
              pkt.matrix.seti(row_count, 1, cfg.data_width, eg_trn.eg_r1);
              pkt.matrix.seti(row_count, 2, cfg.data_width, eg_trn.eg_r2);
              row_count++;
           end
        end while (row_count<3);
        `uvmx_write_mon_trn(pkt, eg_pkt_mon_trn_fifo)
      end
      // pragma uvmx eg_mon_seq_monitor end
   endtask

   // pragma uvmx eg_mon_seq_methods begin
   // pragma uvmx eg_mon_seq_methods end

endclass


`endif // __UVMA_MSTREAM_EG_MON_SEQ_SV__
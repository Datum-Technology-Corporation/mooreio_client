// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_EG_MON_SEQ_SV__
`define __UVMA_MAPU_B_EG_MON_SEQ_SV__


/**
 * Egress: Parses result matrices from the DUT.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_eg_mon_seq_c extends uvma_mapu_b_base_seq_c;

   `uvm_object_utils(uvma_mapu_b_eg_mon_seq_c)
   `uvmx_mon_seq(uvma_mapu_b_eg_mon_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_eg_mon_seq");
      super.new(name);
   endfunction

   // pragma uvmx eg_mon_seq_monitor_dox begin
   /**
    * Creates Egress Monitor Transactions.
    */
   // pragma uvmx eg_mon_seq_monitor_dox end
   task monitor();
      // pragma uvmx eg_mon_seq_monitor begin
      uvma_mapu_b_eg_mon_trn_c    eg_trn;
      uvma_mapu_b_dpo_mon_trn_c  dpo_trn;
      int unsigned  row_count;
      forever begin
         row_count = 0;
         `uvmx_create_mon_trn(eg_trn, uvma_mapu_b_eg_mon_trn_c)
         do begin
            `uvmx_get_mon_trn(dpo_trn, dpo_mon_trn_fifo)
            if ((dpo_trn.o_vld === 1) && (dpo_trn.i_rdy === 1)) begin
               eg_trn.from(dpo_trn);
               eg_trn.matrix.seti(row_count, 0, cfg.data_width, dpo_trn.o_r0);
               eg_trn.matrix.seti(row_count, 1, cfg.data_width, dpo_trn.o_r1);
               eg_trn.matrix.seti(row_count, 2, cfg.data_width, dpo_trn.o_r2);
               eg_trn.overflow = cntxt.mon_overflow;
               row_count++;
            end
         end while (row_count<3);
         if (eg_trn.overflow) begin
            cntxt.mon_overflow_count++;
         end
         `uvmx_write_mon_trn(eg_trn, eg_mon_trn_fifo)
      end
      // pragma uvmx eg_mon_seq_monitor end
   endtask

   // pragma uvmx eg_mon_seq_methods begin
   // pragma uvmx eg_mon_seq_methods end

endclass


`endif // __UVMA_MAPU_B_EG_MON_SEQ_SV__
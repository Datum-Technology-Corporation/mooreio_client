// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_IG_MON_SEQ_SV__
`define __UVMA_MAPU_B_IG_MON_SEQ_SV__


/**
 * Ingress: Parses operand matrices to the DUT.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_ig_mon_seq_c extends uvma_mapu_b_base_seq_c;

   `uvm_object_utils(uvma_mapu_b_ig_mon_seq_c)
   `uvmx_mon_seq(uvma_mapu_b_ig_mon_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_ig_mon_seq");
      super.new(name);
   endfunction

   // pragma uvmx ig_mon_seq_monitor_dox begin
   /**
    * Creates Ingress Monitor Transactions.
    */
   // pragma uvmx ig_mon_seq_monitor_dox end
   task monitor();
      // pragma uvmx ig_mon_seq_monitor begin
      uvma_mapu_b_ig_mon_trn_c   ig_trn   ;
      uvma_mapu_b_cp_mon_trn_c   cp_trn   ;
      uvma_mapu_b_dpi_mon_trn_c  dpi_trn  ;
      bit                        first_m  ;
      int unsigned               row_count;
      forever begin
         first_m = 1;
         repeat (2) begin
            row_count = 0;
            `uvmx_create_mon_trn(ig_trn, uvma_mapu_b_ig_mon_trn_c)
            do begin
               `uvmx_get_mon_trn(cp_trn , cp_mon_trn_fifo )
               `uvmx_get_mon_trn(dpi_trn, dpi_mon_trn_fifo)
               if ((dpi_trn.i_vld === 1) && (dpi_trn.o_rdy === 1)) begin
                  ig_trn.from(dpi_trn);
                  ig_trn.matrix.seti(row_count, 0, cfg.data_width, dpi_trn.i_r0);
                  ig_trn.matrix.seti(row_count, 1, cfg.data_width, dpi_trn.i_r1);
                  ig_trn.matrix.seti(row_count, 2, cfg.data_width, dpi_trn.i_r2);
                  row_count++;
               end
            end while (row_count<3);
            if (!first_m) begin
               while (cp_trn.i_en !== 1) begin
                  `uvmx_get_mon_trn(cp_trn , cp_mon_trn_fifo )
                  `uvmx_get_mon_trn(dpi_trn, dpi_mon_trn_fifo)
               end
               case (cp_trn.i_op)
                  0: ig_trn.op = UVMA_MAPU_B_OP_ADD ;
                  1: ig_trn.op = UVMA_MAPU_B_OP_MULT;
                  default: ig_trn.set_error(1);
               endcase
               if (cp_trn.o_of) begin
                  cntxt.mon_overflow = 1;
               end
               else begin
                  cntxt.mon_overflow = 0;
               end
               ig_trn.from(cp_trn);
            end
            `uvmx_write_mon_trn(ig_trn, ig_mon_trn_fifo)
            first_m = 0;
         end
      end
      // pragma uvmx ig_mon_seq_monitor end
   endtask

   // pragma uvmx ig_mon_seq_methods begin
   // pragma uvmx ig_mon_seq_methods end

endclass


`endif // __UVMA_MAPU_B_IG_MON_SEQ_SV__
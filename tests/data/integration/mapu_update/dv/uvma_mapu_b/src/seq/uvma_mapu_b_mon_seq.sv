// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_MON_SEQ_SV__
`define __UVMA_MAPU_B_MON_SEQ_SV__


/**
 * Sequence taking in Channel Monitor Transactions and creating Matrix APU Agent Monitor Transactions
 * (uvma_mapu_b_mon_trn_c) in both directions.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_mon_seq_c extends uvma_mapu_b_base_seq_c;

   // pragma uvmx mon_seq_fields begin
   // pragma uvmx mon_seq_fields end
   

   `uvm_object_utils_begin(uvma_mapu_b_mon_seq_c)
      // pragma uvmx mon_seq_uvm_field_macros begin
      // pragma uvmx mon_seq_uvm_field_macros end
   `uvm_object_utils_end
   `uvmx_mon_seq(uvma_mapu_b_mon_seq_c)


   // pragma uvmx mon_seq_constraints begin
   // pragma uvmx mon_seq_constraints end
   

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_mon_seq");
      super.new(name);
      // pragma uvmx mon_seq_constructor begin
      // pragma uvmx mon_seq_constructor end
   endfunction

   /**
    * Forks off `monitor_x()` tasks.
    */
   task monitor();
      fork
         monitor_in ();
         monitor_out();
      join
   endtask

   /**
    * Creates Matrix APU Agent Monitor Transactions for input direction (relative to DUT).
    */
   task monitor_in();
      // pragma uvmx mon_seq_monitor_in begin
      uvma_mapu_b_mon_trn_c      in_trn   ;
      uvma_mapu_b_cp_mon_trn_c   cp_trn   ;
      uvma_mapu_b_dpi_mon_trn_c  dpi_trn  ;
      bit                        first_m  ;
      int unsigned               row_count;
      forever begin
         first_m = 1;
         repeat (2) begin
            row_count = 0;
            `uvmx_create_mon_trn(in_trn, uvma_mapu_b_mon_trn_c)
            in_trn.direction = UVMX_BLOCK_MON_IN;
            do begin
               `uvmx_get_mon_trn(cp_trn , cp_mon_trn_fifo )
               `uvmx_get_mon_trn(dpi_trn, dpi_mon_trn_fifo)
               if ((dpi_trn.i_vld === 1) && (dpi_trn.o_rdy === 1)) begin
                  in_trn.matrix.seti(row_count, 0, cfg.data_width, dpi_trn.i_r0);
                  in_trn.matrix.seti(row_count, 1, cfg.data_width, dpi_trn.i_r1);
                  in_trn.matrix.seti(row_count, 2, cfg.data_width, dpi_trn.i_r2);
                  in_trn.from(dpi_trn);
                  row_count++;
               end
            end while (row_count<3);
            if (!first_m) begin
               while (cp_trn.i_en !== 1) begin
                  `uvmx_get_mon_trn(cp_trn , cp_mon_trn_fifo )
                  `uvmx_get_mon_trn(dpi_trn, dpi_mon_trn_fifo)
               end
               case (cp_trn.i_op)
                  0: in_trn.op = UVMA_MAPU_B_OP_ADD ;
                  1: in_trn.op = UVMA_MAPU_B_OP_MULT;
                  default: in_trn.set_error(1);
               endcase
               if (cp_trn.o_of) begin
                  cntxt.mon_overflow = 1;
               end
               else begin
                  cntxt.mon_overflow = 0;
               end
               in_trn.from(cp_trn);
            end
            `uvmx_write_mon_trn(in_trn, in_mon_trn_fifo)
            first_m = 0;
         end
      end
      // pragma uvmx mon_seq_monitor_in end
   endtask

   /**
    * Creates Matrix APU Agent Monitor Transactions for output direction (relative to DUT).
    */
   task monitor_out();
      // pragma uvmx mon_seq_monitor_out begin
      uvma_mapu_b_mon_trn_c      out_trn;
      uvma_mapu_b_dpo_mon_trn_c  dpo_trn;
      int unsigned  row_count;
      forever begin
         row_count = 0;
         `uvmx_create_mon_trn(out_trn, uvma_mapu_b_mon_trn_c)
         out_trn.direction = UVMX_BLOCK_MON_OUT;
         do begin
            `uvmx_get_mon_trn(dpo_trn, dpo_mon_trn_fifo)
            if ((dpo_trn.o_vld === 1) && (dpo_trn.i_rdy === 1)) begin
               out_trn.matrix.seti(row_count, 0, cfg.data_width, dpo_trn.o_r0);
               out_trn.matrix.seti(row_count, 1, cfg.data_width, dpo_trn.o_r1);
               out_trn.matrix.seti(row_count, 2, cfg.data_width, dpo_trn.o_r2);
               out_trn.overflow = cntxt.mon_overflow;
               out_trn.from(dpo_trn);
               row_count++;
            end
         end while (row_count<3);
         if (out_trn.overflow) begin
            cntxt.mon_overflow_count++;
         end
         `uvmx_write_mon_trn(out_trn, out_mon_trn_fifo)
      end
      // pragma uvmx mon_seq_monitor_out end
   endtask

   // pragma uvmx mon_seq_monitor_methods begin
   // pragma uvmx mon_seq_monitor_methods end

endclass


`endif // __UVMA_MAPU_B_MON_SEQ_SV__
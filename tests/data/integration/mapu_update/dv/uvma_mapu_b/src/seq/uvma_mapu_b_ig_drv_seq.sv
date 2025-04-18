// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_IG_DRV_SEQ_SV__
`define __UVMA_MAPU_B_IG_DRV_SEQ_SV__


/**
 * Ingress: Drives input matrices and operator
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_ig_drv_seq_c extends uvma_mapu_b_base_seq_c;

   `uvm_object_utils(uvma_mapu_b_ig_drv_seq_c)
   `uvmx_drv_main_seq(uvma_mapu_b_ig_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_ig_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx ig_drv_seq_drive_item_dox begin
   /**
    * * Drives 2 matrices, row-by-row using drive_row, while ensuring `i_en=1` and `i_op` is correct on the last row of the second matrix.
    * * Respects `ton` using `randcase`
    */
   // pragma uvmx ig_drv_seq_drive_item_dox end
   task drive_item(bit async=0, ref uvma_mapu_b_op_seq_item_c seq_item);
      // pragma uvmx ig_drv_seq_drive_item begin
      uvma_mapu_b_cp_seq_item_c   cp_seq_item ;
      uvma_mapu_b_dpi_seq_item_c  dpi_seq_item;
      int unsigned row_count = 0;
      do begin
         randcase
            seq_item.ton_pct: begin
               drive_row(seq_item, seq_item.ma, row_count);
               row_count++;
            end
            (100-seq_item.ton_pct): begin
               clk();
            end
         endcase
      end while (row_count<3);
      do begin
         randcase
            seq_item.ton_pct: begin
               fork
                  begin
                     drive_row(seq_item, seq_item.mb, row_count-3);
                  end
                  begin
                     if (row_count == 5) begin
                        `uvmx_create_on(cp_seq_item, cp_sequencer)
                        cp_seq_item.from(seq_item);
                        cp_seq_item.i_en = 1;
                        cp_seq_item.i_op = seq_item.op;
                        `uvmx_send_drv(cp_seq_item)
                     end
                  end
               join
               row_count++;
            end
            (100-seq_item.ton_pct): begin
               clk();
            end
         endcase
      end while (row_count<6);
      // pragma uvmx ig_drv_seq_drive_item end
   endtask

   // pragma uvmx ig_drv_seq_methods begin
   /**
    * Drives a single matrix row into the DUT.
    */
   virtual task drive_row(uvma_mapu_b_op_seq_item_c seq_item, uvml_math_mtx_c matrix, int unsigned row);
      uvma_mapu_b_dpi_seq_item_c  dpi_seq_item;
      do begin
         `uvmx_create_on(dpi_seq_item, dpi_sequencer)
         dpi_seq_item.from(seq_item);
         dpi_seq_item.i_vld = 1;
         dpi_seq_item.i_r0  = matrix.geti(row, 0, cfg.data_width);
         dpi_seq_item.i_r1  = matrix.geti(row, 1, cfg.data_width);
         dpi_seq_item.i_r2  = matrix.geti(row, 2, cfg.data_width);
         `uvmx_send_drv(dpi_seq_item)
      end while (cntxt.vif.o_rdy !== 1);
   endtask
   // pragma uvmx ig_drv_seq_methods end

endclass


`endif // __UVMA_MAPU_B_IG_DRV_SEQ_SV__
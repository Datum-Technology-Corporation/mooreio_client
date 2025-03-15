// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_OUT_DRV_SEQ_SV__
`define __UVMA_MAPU_B_OUT_DRV_SEQ_SV__


/**
 * Sequence generating Channel Sequence Items and driving uvma_mapu_b_drv_c.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_out_drv_seq_c extends uvma_mapu_b_base_seq_c;

   // pragma uvmx out_drv_seq_fields begin
   // pragma uvmx out_drv_seq_fields end
   

   `uvm_object_utils_begin(uvma_mapu_b_out_drv_seq_c)
      // pragma uvmx out_drv_seq_uvm_field_macros begin
      // pragma uvmx out_drv_seq_uvm_field_macros end
   `uvm_object_utils_end
   `uvmx_out_drv_seq(uvma_mapu_b_out_drv_seq_c)


   // pragma uvmx out_drv_seq_constraints begin
   // pragma uvmx out_drv_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_out_drv_seq");
      super.new(name);
      // pragma uvmx out_drv_seq_constructor begin
      // pragma uvmx out_drv_seq_constructor end
   endfunction

   /**
    * TODO Describe uvma_mapu_b_out_drv_seq_c::drive()
    */
   virtual task drive();
      // pragma uvmx out_drv_seq_drive begin
      uvma_mapu_b_dpo_seq_item_c  dpo_seq_item;
      bit                         within_transfer;
      forever begin
         within_transfer = 0;
         if (dpo_seq_item != null) begin
            if (dpo_seq_item.o_vld === 1) begin
               within_transfer = 1;
            end
         end
         if (within_transfer) begin
            `uvmx_create_on(dpo_seq_item, dpo_sequencer)
            `uvmx_rand_send_drv_with(dpo_seq_item, {
               i_rdy == 1;
            })
         end
         else begin
            randcase
               cfg.out_drv_ton_pct: begin
                  `uvmx_create_on(dpo_seq_item, dpo_sequencer)
                  `uvmx_rand_send_drv_with(dpo_seq_item, {
                     i_rdy == 1;
                  })
               end
               (100-cfg.out_drv_ton_pct): begin
                  clk();
               end
            endcase
         end
      end
      // pragma uvmx out_drv_seq_drive end
   endtask

   // pragma uvmx out_drv_seq_methods begin
   // pragma uvmx out_drv_seq_methods end

endclass


`endif // __UVMA_MAPU_B_OUT_DRV_SEQ_SV__
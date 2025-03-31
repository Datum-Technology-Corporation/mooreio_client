// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_EG_DRV_SEQ_SV__
`define __UVMA_MAPU_B_EG_DRV_SEQ_SV__


/**
 * Egress: Drives DUT output bus
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_eg_drv_seq_c extends uvma_mapu_b_base_seq_c;

   `uvm_object_utils(uvma_mapu_b_eg_drv_seq_c)
   `uvmx_drv_seq(uvma_mapu_b_eg_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_eg_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx eg_drv_seq_dox begin
   /**
    * Drives Egress port's i_rdy signal.
    */
   // pragma uvmx eg_drv_seq_dox end
   virtual task drive();
      // pragma uvmx eg_drv_seq_drive begin
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
               cfg.eg_drv_ton_pct: begin
                  `uvmx_create_on(dpo_seq_item, dpo_sequencer)
                  `uvmx_rand_send_drv_with(dpo_seq_item, {
                     i_rdy == 1;
                  })
               end
               (100-cfg.eg_drv_ton_pct): begin
                  clk();
               end
            endcase
         end
      end
      // pragma uvmx eg_drv_seq_drive end
   endtask

   // pragma uvmx eg_drv_seq_methods begin
   // pragma uvmx eg_drv_seq_methods end

endclass


`endif // __UVMA_MAPU_B_EG_DRV_SEQ_SV__
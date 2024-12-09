// Copyright 2024 Datron Limited Partnership
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
   `uvmx_out_drv_seq()


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
      forever begin
         clk(); // TODO Remove this line after implementing uvma_mapu_b_out_drv_seq_c::drive()
         // TODO Implement uvma_mapu_b_out_drv_seq_c::drive()
         //      Ex: randcase
         //             cfg.out_drv_ton_pct: begin
         //                uvma_mapu_b_dpi_seq_item_c  dpi_seq_item;
         //                `uvmx_create_on(dpi_seq_item, dpi_sequencer)
         //                dpi_seq_item.rdy = 1;
         //                `uvmx_send_drv(dpi_seq_item)
         //             end
         //             (100-cfg.out_drv_ton_pct): begin
         //                clk();
         //             end
         //          endcase
      end
      // pragma uvmx out_drv_seq_drive begin
   endtask

   // pragma uvmx out_drv_seq_methods begin
   // pragma uvmx out_drv_seq_methods end

endclass


`endif // __UVMA_MAPU_B_OUT_DRV_SEQ_SV__
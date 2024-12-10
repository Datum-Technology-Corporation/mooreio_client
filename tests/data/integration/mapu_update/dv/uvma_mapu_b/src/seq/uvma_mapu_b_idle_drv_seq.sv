// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_IDLE_DRV_SEQ_SV__
`define __UVMA_MAPU_B_IDLE_DRV_SEQ_SV__


/**
 * Sequence generating 'idle' Sequence Items at all times.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_idle_drv_seq_c extends uvma_mapu_b_base_seq_c;

   // pragma uvmx idle_drv_seq_fields begin
   // pragma uvmx idle_drv_seq_fields end
   
   
   `uvm_object_utils_begin(uvma_mapu_b_idle_drv_seq_c)
      // pragma uvmx idle_drv_seq_uvm_field_macros begin
      // pragma uvmx idle_drv_seq_uvm_field_macros end
   `uvm_object_utils_end
   `uvmx_idle_seq(uvma_mapu_b_idle_drv_seq_c)


   // pragma uvmx idle_drv_seq_constraints begin
   // pragma uvmx idle_drv_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_idle_drv_seq");
      super.new(name);
      // pragma uvmx idle_drv_seq_constructor begin
      // pragma uvmx idle_drv_seq_constructor end
   endfunction

   /**
    * Infinite loops generating idle sequence items.
    */
   task idle();
      // pragma uvmx idle_drv_seq_idle begin
      uvma_mapu_b_dpi_seq_item_c  dpi_seq_item;
      uvma_mapu_b_dpo_seq_item_c  dpo_seq_item;
      fork
         forever begin
            `uvmx_rand_idle_with(dpi_seq_item, dpi_sequencer, {
               i_vld == 0;
            })
         end
         forever begin
            `uvmx_rand_idle_with(dpo_seq_item, dpo_sequencer, {
               i_rdy == 0;
            })
         end
      join
      // pragma uvmx idle_drv_seq_idle end
   endtask

   // pragma uvmx idle_drv_seq_methods begin
   // pragma uvmx idle_drv_seq_methods end

endclass


`endif // __UVMA_MAPU_B_IDLE_DRV_SEQ_SV__
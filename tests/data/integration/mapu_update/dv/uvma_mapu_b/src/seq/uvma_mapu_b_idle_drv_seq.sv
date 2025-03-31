// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_IDLE_DRV_SEQ_SV__
`define __UVMA_MAPU_B_IDLE_DRV_SEQ_SV__


/**
 * Idle: Ensures valid signals stay low when buses are inactive
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_idle_drv_seq_c extends uvma_mapu_b_base_seq_c;
   
   `uvm_object_utils(uvma_mapu_b_idle_drv_seq_c)
   `uvmx_drv_idle_seq(uvma_mapu_b_idle_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_idle_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx idle_drv_seq_idle_dox begin
   /**
    * Infinite loops generating idle Sequence Items for Data Plane Input and Data Plane Output.
    */
   // pragma uvmx idle_drv_seq_idle_dox end
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
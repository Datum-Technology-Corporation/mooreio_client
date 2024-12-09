// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_IN_DRV_SEQ_SV__
`define __UVMA_MAPU_B_IN_DRV_SEQ_SV__


/**
 * Sequence taking in uvma_mapu_b_seq_item_c instances and driving uvma_mapu_b_drv_c with Channel Sequence Items.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_in_drv_seq_c extends uvma_mapu_b_base_seq_c;

   // pragma uvmx in_drv_seq_fields begin
   // pragma uvmx in_drv_seq_fields end
   

   `uvm_object_utils_begin(uvma_mapu_b_in_drv_seq_c)
      // pragma uvmx in_drv_seq_uvm_field_macros begin
      // pragma uvmx in_drv_seq_uvm_field_macros end
   `uvm_object_utils_end
   `uvmx_in_drv_seq()


   // pragma uvmx in_drv_seq_constraints begin
   // pragma uvmx in_drv_seq_constraints end
   

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_in_drv_seq");
      super.new(name);
      // pragma uvmx in_drv_seq_constructor begin
      // pragma uvmx in_drv_seq_constructor end
   endfunction

   // pragma uvmx in_drv_seq_drive_item begin
   /**
    * TODO Describe uvma_mapu_b_in_drv_seq_c::drive_item()
    *      Note: For asynchronous protocols (async==1), the response must be sent via `virtual task respond(seq_item)`.
    *            Use `uvma_mapu_b_cntxt_c` to store shared data.
    */
   task drive_item(bit async=0, ref uvma_mapu_b_seq_item_c seq_item);
      // TODO Implement uvma_mapu_b_in_drv_seq_c::drive()
      //      Ex: uvma_mapu_b_dpi_seq_item_c  dpi_seq_item;
      //          `uvmx_create_on(dpi_seq_item, dpi_sequencer)
      //          dpi_seq_item.from(seq_item);
      //          dpi_seq_item.xyz = seq_item.qrs;
      //          `uvmx_send_drv(dpi_seq_item)
   endtask
   // pragma uvmx in_drv_seq_drive_item begin

endclass


`endif // __UVMA_MAPU_B_IN_DRV_SEQ_SV__
// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_SEQ_ITEM_SV__
`define __UVMA_MAPU_B_SEQ_ITEM_SV__


/**
 * Sequence Item created by Matrix APU Sequences.
 * Analog of uvma_mapu_b_mon_trn_c
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_seq_item_c extends uvmx_block_sb_seq_item_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Data
   /// @{
   /// @}

   // pragma uvmx seq_item_fields begin
   // pragma uvmx seq_item_fields end

   `uvm_object_utils_begin(uvma_mapu_b_seq_item_c)
      // pragma uvmx seq_item_uvm_field_macros begin
      // pragma uvmx seq_item_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Describes data space.
    */
   constraint data_cons {
   }

   // pragma uvmx seq_item_constraints begin
   // pragma uvmx seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_seq_item");
      super.new(name);
      // pragma uvmx seq_item_constructor begin
      // pragma uvmx seq_item_constructor end
   endfunction

   // pragma uvmx seq_item_post_randomize_work begin
   /**
    * TODO Implement or remove uvma_mapu_b_seq_item_c::post_randomize()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx seq_item_post_randomize_work end

   // pragma uvmx seq_item_do_print begin
   /**
    * TODO Implement or remove uvma_mapu_b_seq_item_c::do_print()
    */
   virtual function void do_print(uvm_printer printer);
      super.do_print(printer);
      // Print dependent on configuration and/or fields
      // Ex: if (cfg.enable_abc) begin
      //        printer.print_field("abc", abc, 8);
      //     end
   endfunction
   // pragma uvmx seq_item_do_print end

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx seq_item_get_metadata begin
      string  val_str;

      // pragma uvmx seq_item_get_metadata end
   endfunction

   // pragma uvmx seq_item_methods begin
   // pragma uvmx seq_item_methods end

endclass


`endif // __UVMA_MAPU_B_SEQ_ITEM_SV__
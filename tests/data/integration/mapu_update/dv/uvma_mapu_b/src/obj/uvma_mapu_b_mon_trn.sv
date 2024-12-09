// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_MON_TRN_SV__
`define __UVMA_MAPU_B_MON_TRN_SV__


/**
 * Monitor Transaction rebuilt by the Monitor Sequence (uvma_mapu_b_mon_seq_c).
 * Analog of uvma_mapu_b_seq_item_c.
 * @ingroup uvma_mapu_b_obj
 */
class uvma_mapu_b_mon_trn_c extends uvmx_block_sb_mon_trn_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Data
   /// @{
   /// @}

   // pragma uvmx mon_trn_fields begin
   // pragma uvmx mon_trn_fields end


   `uvm_object_utils_begin(uvma_mapu_b_mon_trn_c)
      // pragma uvmx mon_trn_uvm_field_macros begin
      `uvm_field_enum(uvmx_block_mon_direction_enum, direction, UVM_DEFAULT)
      // pragma uvmx mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_mon_trn");
      super.new(name);
      // pragma uvmx mon_trn_constructor begin
      // pragma uvmx mon_trn_constructor end
   endfunction

   /**
    * TODO Implement or remove uvma_mapu_b_mon_trn_c::do_compare()
    */
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      // pragma uvmx mon_trn_do_compare begin
      uvma_mapu_b_mon_trn_c  trn;
      do_compare = super.do_compare(rhs, comparer);
      if (!$cast(trn, rhs)) begin
         `uvm_fatal("MAPU_B_MON_TRN", "Failed to cast rhs during do_compare()")
      end
      else begin
         // Add compares dependent on configuration and/or fields
         // Ex: if (cfg.enable_abc) begin
         //        do_compare &= comparer.compare_field_int("abc", abc, trn.abc, 8);
         //     end
      end
      // pragma uvmx mon_trn_do_compare begin
   endfunction

   /**
    * TODO Implement or remove uvma_mapu_b_mon_trn_c::do_print()
    */
   virtual function void do_print(uvm_printer printer);
      // pragma uvmx mon_trn_do_print begin
      super.do_print(printer);
      // Print dependent on configuration and/or fields
      // Ex: if (cfg.enable_abc) begin
      //        printer.print_field("abc", abc, 8);
      //     end
      // pragma uvmx mon_trn_do_print end
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx mon_trn_get_metadata begin
      string  val_str;
      // pragma uvmx mon_trn_get_metadata end
   endfunction

   // pragma uvmx mon_trn_methods begin
   // pragma uvmx mon_trn_methods end

endclass


`endif // __UVMA_MAPU_B_MON_TRN_SV__
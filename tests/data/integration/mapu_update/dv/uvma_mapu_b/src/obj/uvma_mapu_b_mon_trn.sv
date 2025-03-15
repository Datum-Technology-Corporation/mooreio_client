// Copyright 2025 Datron Limited Partnership
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
   uvma_mapu_b_op_enum  op; ///< Operation to be performed (only valid for dir_in=1)
   uvml_math_mtx_c  matrix; ///< Matrix observed.
   bit  overflow; ///< '1' when matrix has values outside the configured bit width.
   // pragma uvmx mon_trn_fields end


   `uvm_object_utils_begin(uvma_mapu_b_mon_trn_c)
      // pragma uvmx mon_trn_uvm_field_macros begin
      `uvm_field_enum(uvmx_block_mon_direction_enum, direction, UVM_DEFAULT)
      `uvm_field_object(matrix, UVM_DEFAULT + UVM_NOCOMPARE)
      `uvm_field_int(overflow, UVM_DEFAULT)
      `uvm_field_enum(uvma_mapu_b_op_enum, op, UVM_DEFAULT + UVM_NOCOMPARE)
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
    * Initializes objects and arrays.
    */
   virtual function void build();
      // pragma uvmx mon_trn_build begin
      matrix = uvml_math_mtx_c::type_id::create("matrix");
      matrix.build(3, 3);
      // pragma uvmx mon_trn_build end
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
      // pragma uvmx mon_trn_do_print end
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx mon_trn_get_metadata begin
      string           overflow_str, op_str;
      uvmx_metadata_t  mm;
      if (direction != UVMX_BLOCK_MON_IN) begin
         overflow_str = (overflow === 1) ? "OF" : "  ";
         `uvmx_metadata_field("of", overflow_str)
      end
      else begin
         op_str = (op === UVMA_MAPU_B_OP_ADD) ? "ADD " : "MULT";
         `uvmx_metadata_field("op", op_str)
      end
      mm = matrix.get_metadata();
      foreach (mm[ii]) begin
         if (cfg.data_width == 32) begin
            mm[ii].width = 12;
         end
         else if (cfg.data_width == 64) begin
            mm[ii].width = 18;
         end
         `uvmx_metadata_add(mm[ii])
      end
      // pragma uvmx mon_trn_get_metadata end
   endfunction

   // pragma uvmx mon_trn_methods begin
   // pragma uvmx mon_trn_methods end

endclass


`endif // __UVMA_MAPU_B_MON_TRN_SV__
// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_EG_MON_TRN_SV__
`define __UVMA_MAPU_B_EG_MON_TRN_SV__


/**
 * Egress: Output of matrix operation
 * @ingroup uvma_mapu_b_obj
 */
class uvma_mapu_b_eg_mon_trn_c extends uvmx_block_sb_mon_trn_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Fields
   /// @{
   bit  overflow; ///< Overflow: '1' when matrix has values outside the configured bit width.
   /// @}

   // pragma uvmx eg_mon_trn_fields begin
   uvml_math_mtx_c  matrix; ///< Matrix observed.
   // pragma uvmx eg_mon_trn_fields end


   `uvm_object_utils_begin(uvma_mapu_b_eg_mon_trn_c)
      // pragma uvmx eg_mon_trn_uvm_field_macros begin
      `uvm_field_int(overflow, UVM_DEFAULT)
      `uvm_field_object(matrix, UVM_DEFAULT)
      // pragma uvmx eg_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_eg_mon_trn");
      super.new(name);
   endfunction

   // pragma uvmx eg_mon_trn_do_compare begin
   /**
    * TODO Implement or remove uvma_mapu_b_eg_mon_trn_c::do_compare()
    */
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      uvma_mapu_b_eg_mon_trn_c  trn;
      do_compare = super.do_compare(rhs, comparer);
      if (!$cast(trn, rhs)) begin
         `uvm_fatal("MAPU_B_EG_MON_TRN", "Failed to cast rhs during do_compare()")
      end
      else begin
         // Add compares dependent on configuration and/or fields
         // Ex: if (cfg.enable_abc) begin
         //        do_compare &= comparer.compare_field_int("abc", abc, trn.abc, 8);
         //     end
      end
   endfunction
   // pragma uvmx eg_mon_trn_do_compare begin

   // pragma uvmx eg_mon_trn_do_print begin
   // pragma uvmx eg_mon_trn_do_print end

   // pragma uvmx eg_mon_trn_get_metadata begin
   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      string           overflow_str;
      uvmx_metadata_t  mm;
      overflow_str = (overflow === 1) ? "OF" : "  ";
     `uvmx_metadata_field("of", overflow_str)
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
   endfunction
   // pragma uvmx eg_mon_trn_get_metadata end

   // pragma uvmx eg_mon_trn_methods begin
   /**
    * Initializes objects and arrays.
    */
   virtual function void build();
      // pragma uvmx mon_trn_build begin
      matrix = uvml_math_mtx_c::type_id::create("matrix");
      matrix.build(3, 3);
      // pragma uvmx mon_trn_build end
   endfunction
   // pragma uvmx eg_mon_trn_methods end

endclass


`endif // __UVMA_MAPU_B_EG_MON_TRN_SV__
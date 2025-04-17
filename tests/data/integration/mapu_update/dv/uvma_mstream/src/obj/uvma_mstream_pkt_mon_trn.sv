// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_PKT_MON_TRN_SV__
`define __UVMA_MSTREAM_PKT_MON_TRN_SV__


/**
 * Packet: Monitored matrix
 * @ingroup uvma_mstream_obj
 */
class uvma_mstream_pkt_mon_trn_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Fields
   /// @{
   uvma_mstream_dir_enum  dir; ///< Direction: Direction of source
   /// @}

   // pragma uvmx pkt_mon_trn_fields begin
   uvml_math_mtx_c  matrix; ///< Matrix observed.
   // pragma uvmx pkt_mon_trn_fields end


   `uvm_object_utils_begin(uvma_mstream_pkt_mon_trn_c)
      // pragma uvmx pkt_mon_trn_uvm_field_macros begin
      `uvm_field_enum(uvma_mstream_dir_enum, dir, UVM_DEFAULT)
      `uvm_field_object(matrix, UVM_DEFAULT)
      // pragma uvmx pkt_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_pkt_mon_trn");
      super.new(name);
   endfunction

   // pragma uvmx pkt_mon_trn_do_compare begin
   /**
    * TODO Implement or remove uvma_mstream_pkt_mon_trn_c::do_compare()
    */
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      uvma_mstream_pkt_mon_trn_c  trn;
      do_compare = super.do_compare(rhs, comparer);
      if (!$cast(trn, rhs)) begin
         `uvm_fatal("MSTREAM_PKT_MON_TRN", "Failed to cast rhs during do_compare()")
      end
      else begin
         // Add compares dependent on configuration and/or fields
         // Ex: if (cfg.enable_abc) begin
         //        do_compare &= comparer.compare_field_int("abc", abc, trn.abc, 8);
         //     end
      end
   endfunction
   // pragma uvmx pkt_mon_trn_do_compare begin

   // pragma uvmx pkt_mon_trn_do_print begin
   // pragma uvmx pkt_mon_trn_do_print end

   // pragma uvmx pkt_mon_trn_get_metadata begin
   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      string  val_str;
      uvmx_metadata_t  mm;
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
   // pragma uvmx pkt_mon_trn_get_metadata end

   // pragma uvmx pkt_mon_trn_methods begin
   /**
    * Initializes objects and arrays.
    */
   virtual function void build();
      // pragma uvmx mon_trn_build begin
      matrix = uvml_math_mtx_c::type_id::create("matrix");
      matrix.build(3, 3);
      // pragma uvmx mon_trn_build end
   endfunction
   // pragma uvmx pkt_mon_trn_methods end

endclass


`endif // __UVMA_MSTREAM_PKT_MON_TRN_SV__
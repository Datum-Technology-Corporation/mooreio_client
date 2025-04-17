// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_IG_MON_TRN_SV__
`define __UVMA_MSTREAM__IG_MON_TRN_SV__


/**
 * Ingress monitor transaction sampled by uvma_mstream_ig_mon_c.
 * @ingroup uvma_mstream_obj
 */
class uvma_mstream_ig_mon_trn_c extends uvmx_mon_trn_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Data
   /// @{
   uvma_mstream_ig_vld_t  ig_vld; ///< Ingress Valid
   uvma_mstream_ig_rdy_t  ig_rdy; ///< Ingress Ready
   uvma_mstream_ig_r0_t  ig_r0; ///< Ingress Data Row 0
   uvma_mstream_ig_r1_t  ig_r1; ///< Ingress Data Row 1
   uvma_mstream_ig_r2_t  ig_r2; ///< Ingress Data Row 2
   /// @}

   // pragma uvmx ig_mon_trn_fields begin
   // pragma uvmx ig_mon_trn_fields end


   `uvm_object_utils_begin(uvma_mstream_ig_mon_trn_c)
      // pragma uvmx ig_mon_trn_uvm_field_macros begin
      `uvm_field_int(ig_vld, UVM_DEFAULT)
      `uvm_field_int(ig_rdy, UVM_DEFAULT)
      `uvm_field_int(ig_r0, UVM_DEFAULT)
      `uvm_field_int(ig_r1, UVM_DEFAULT)
      `uvm_field_int(ig_r2, UVM_DEFAULT)
      // pragma uvmx ig_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_ig_mon_trn");
      super.new(name);
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx ig_mon_trn_get_metadata begin
      string ig_vld_str;
      string ig_rdy_str;
      string ig_r0_str;
      string ig_r1_str;
      string ig_r2_str;
      ig_vld_str = $sformatf("%h", ig_vld);
      ig_rdy_str = $sformatf("%h", ig_rdy);
      ig_r0_str = $sformatf("%h", ig_r0);
      ig_r1_str = $sformatf("%h", ig_r1);
      ig_r2_str = $sformatf("%h", ig_r2);
      `uvmx_metadata_field("ig_vld", ig_vld_str)
      `uvmx_metadata_field("ig_rdy", ig_rdy_str)
      `uvmx_metadata_field("ig_r0", ig_r0_str)
      `uvmx_metadata_field("ig_r1", ig_r1_str)
      `uvmx_metadata_field("ig_r2", ig_r2_str)
      // pragma uvmx ig_mon_trn_get_metadata end
   endfunction

  // pragma uvmx custom ig_mon_trn_methods begin
  // pragma uvmx custom ig_mon_trn_methods end

endclass


`endif // __UVMA_MSTREAM_IG_MON_TRN_SV__
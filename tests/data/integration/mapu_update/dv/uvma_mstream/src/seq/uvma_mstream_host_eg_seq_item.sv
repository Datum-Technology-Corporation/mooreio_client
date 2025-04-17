// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_HOST_EG_SEQ_ITEM_SV__
`define __UVMA_MSTREAM_HOST_EG_SEQ_ITEM_SV__


/**
 * Sequence Item providing stimulus for HOST Egress driver (uvma_mstream_drv_c).
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_host_eg_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Driven Signals
   /// @{
   rand uvma_mstream_eg_rdy_b_t  eg_rdy; ///< Egress Ready
   /// @}

   /// @name Monitored Signals (following edge)
   /// @{
   uvma_mstream_eg_vld_l_t  eg_vld; ///< Egress Valid
   uvma_mstream_eg_r0_l_t  eg_r0; ///< Egress Data Row 0
   uvma_mstream_eg_r1_l_t  eg_r1; ///< Egress Data Row 1
   uvma_mstream_eg_r2_l_t  eg_r2; ///< Egress Data Row 2
   /// @}

   // pragma uvmx host_eg_seq_item_fields begin
   // pragma uvmx host_eg_seq_item_fields end


   `uvm_object_utils_begin(uvma_mstream_host_eg_seq_item_c)
      // pragma uvmx host_eg_seq_item_uvm_field_macros begin
      `uvm_field_int(eg_rdy, UVM_DEFAULT)
      `uvm_field_int(eg_vld, UVM_DEFAULT)
      `uvm_field_int(eg_r0, UVM_DEFAULT)
      `uvm_field_int(eg_r1, UVM_DEFAULT)
      `uvm_field_int(eg_r2, UVM_DEFAULT)
      // pragma uvmx host_eg_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx host_eg_seq_item_constraints begin
   // pragma uvmx host_eg_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_host_eg_seq_item");
      super.new(name);
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx host_eg_seq_item_get_metadata begin
      string eg_vld_str;
      string eg_rdy_str;
      string eg_r0_str;
      string eg_r1_str;
      string eg_r2_str;
      eg_vld_str = $sformatf("%h", eg_vld);
      eg_rdy_str = $sformatf("%h", eg_rdy);
      eg_r0_str = $sformatf("%h", eg_r0);
      eg_r1_str = $sformatf("%h", eg_r1);
      eg_r2_str = $sformatf("%h", eg_r2);
      `uvmx_metadata_field("eg_vld", eg_vld_str)
      `uvmx_metadata_field("eg_rdy", eg_rdy_str)
      `uvmx_metadata_field("eg_r0", eg_r0_str)
      `uvmx_metadata_field("eg_r1", eg_r1_str)
      `uvmx_metadata_field("eg_r2", eg_r2_str)
      // pragma uvmx host_eg_seq_item_get_metadata end
   endfunction

   // pragma uvmx host_eg_seq_item_methods begin
   // pragma uvmx host_eg_seq_item_methods end

endclass


`endif // __UVMA_MSTREAM_HOST_EG_SEQ_ITEM_SV__
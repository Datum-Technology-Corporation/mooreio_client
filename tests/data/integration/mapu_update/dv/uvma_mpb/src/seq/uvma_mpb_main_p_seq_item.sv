// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_MAIN_P_SEQ_ITEM_SV__
`define __UVMA_MPB_MAIN_P_SEQ_ITEM_SV__


/**
 * Sequence Item providing stimulus for MAIN Parallel driver (uvma_mpb_drv_c).
 * @ingroup uvma_mpb_seq
 */
class uvma_mpb_main_p_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mpb_cfg_c  ),
   .T_CNTXT(uvma_mpb_cntxt_c)
);

   /// @name Driven Signals
   /// @{
   rand uvma_mpb_vld_t  vld; ///< Data valid
   rand uvma_mpb_wr_t  wr; ///< Write
   rand uvma_mpb_wdata_t  wdata; ///< Write Data
   rand uvma_mpb_addr_t  addr; ///< Address
   /// @}

   /// @name Monitored Signals (following edge)
   /// @{
   uvma_mpb_rdy_t  rdy; ///< Data ready
   uvma_mpb_rdata_t  rdata; ///< Read Data
   /// @}

   // pragma uvmx main_p_seq_item_fields begin
   // pragma uvmx main_p_seq_item_fields end


   `uvm_object_utils_begin(uvma_mpb_main_p_seq_item_c)
      // pragma uvmx main_p_seq_item_uvm_field_macros begin
      `uvm_field_int(vld, UVM_DEFAULT)
      `uvm_field_int(wr, UVM_DEFAULT)
      `uvm_field_int(wdata, UVM_DEFAULT)
      `uvm_field_int(addr, UVM_DEFAULT)
      `uvm_field_int(rdy, UVM_DEFAULT)
      `uvm_field_int(rdata, UVM_DEFAULT)
      // pragma uvmx main_p_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx main_p_seq_item_constraints begin
   // pragma uvmx main_p_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_main_p_seq_item");
      super.new(name);
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx main_p_seq_item_get_metadata begin
      string vld_str;
      string rdy_str;
      string wr_str;
      string rdata_str;
      string wdata_str;
      string addr_str;
      vld_str = $sformatf("%h", vld);
      rdy_str = $sformatf("%h", rdy);
      wr_str = $sformatf("%h", wr);
      rdata_str = $sformatf("%h", rdata);
      wdata_str = $sformatf("%h", wdata);
      addr_str = $sformatf("%h", addr);
      `uvmx_metadata_field("vld", vld_str)
      `uvmx_metadata_field("rdy", rdy_str)
      `uvmx_metadata_field("wr", wr_str)
      `uvmx_metadata_field("rdata", rdata_str)
      `uvmx_metadata_field("wdata", wdata_str)
      `uvmx_metadata_field("addr", addr_str)
      // pragma uvmx main_p_seq_item_get_metadata end
   endfunction

   // pragma uvmx main_p_seq_item_methods begin
   // pragma uvmx main_p_seq_item_methods end

endclass


`endif // __UVMA_MPB_MAIN_P_SEQ_ITEM_SV__
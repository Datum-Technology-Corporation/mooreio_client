// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_P_MON_TRN_SV__
`define __UVMA_MPB__P_MON_TRN_SV__


/**
 * Parallel monitor transaction sampled by uvma_mpb_p_mon_c.
 * @ingroup uvma_mpb_obj
 */
class uvma_mpb_p_mon_trn_c extends uvmx_mon_trn_c #(
   .T_CFG  (uvma_mpb_cfg_c  ),
   .T_CNTXT(uvma_mpb_cntxt_c)
);

   /// @name Data
   /// @{
   uvma_mpb_vld_t  vld; ///< Data valid
   uvma_mpb_rdy_t  rdy; ///< Data ready
   uvma_mpb_wr_t  wr; ///< Write
   uvma_mpb_rdata_t  rdata; ///< Read Data
   uvma_mpb_wdata_t  wdata; ///< Write Data
   uvma_mpb_addr_t  addr; ///< Address
   /// @}

   // pragma uvmx p_mon_trn_fields begin
   // pragma uvmx p_mon_trn_fields end


   `uvm_object_utils_begin(uvma_mpb_p_mon_trn_c)
      // pragma uvmx p_mon_trn_uvm_field_macros begin
      `uvm_field_int(vld, UVM_DEFAULT)
      `uvm_field_int(rdy, UVM_DEFAULT)
      `uvm_field_int(wr, UVM_DEFAULT)
      `uvm_field_int(rdata, UVM_DEFAULT)
      `uvm_field_int(wdata, UVM_DEFAULT)
      `uvm_field_int(addr, UVM_DEFAULT)
      // pragma uvmx p_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_p_mon_trn");
      super.new(name);
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx p_mon_trn_get_metadata begin
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
      // pragma uvmx p_mon_trn_get_metadata end
   endfunction

  // pragma uvmx custom p_mon_trn_methods begin
  // pragma uvmx custom p_mon_trn_methods end

endclass


`endif // __UVMA_MPB_P_MON_TRN_SV__
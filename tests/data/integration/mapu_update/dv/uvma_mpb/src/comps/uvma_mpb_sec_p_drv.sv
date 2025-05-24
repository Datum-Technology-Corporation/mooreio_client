// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_SEC_P_DRV_SV__
`define __UVMA_MPB_SEC_P_DRV_SV__


/**
 * Driver driving uvma_mpb_if with SEC Parallel Sequence Items (uvma_mpb_sec_p_seq_item_c).
 * @ingroup uvma_mpb_comps
 */
class uvma_mpb_sec_p_drv_c extends uvmx_mp_drv_c #(
   .T_CFG     (uvma_mpb_cfg_c  ),
   .T_CNTXT   (uvma_mpb_cntxt_c),
   .T_MP      (virtual uvma_mpb_if.sec_p_drv_mp ),
   .T_SEQ_ITEM(        uvma_mpb_sec_p_seq_item_c)
);

   // pragma uvmx sec_p_drv_fields begin
   // pragma uvmx sec_p_drv_fields end


   `uvm_component_utils_begin(uvma_mpb_sec_p_drv_c)
      // pragma uvmx sec_p_drv_uvm_field_macros begin
      // pragma uvmx sec_p_drv_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_drv(sec_p_drv_mp, sec_p_drv_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_sec_p_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Drives SEC Parallel driver clocking block (sec_p_drv_cb) at the beginning of each clock cycle.
    */
   virtual task drive_item(ref uvma_mpb_sec_p_seq_item_c item);
      mp.sec_p_drv_cb.rdy <= item.rdy;
      mp.sec_p_drv_cb.rdata <= item.rdata;
      // pragma uvmx sec_p_drv_drive_item begin
      // pragma uvmx sec_p_drv_drive_item end
   endtask

   /**
    * Samples the SEC Parallel Driver clocking block (sec_p_drv_cb) at the end of each clock cycle.
    */
   virtual task sample_post_clk(ref uvma_mpb_sec_p_seq_item_c item);
      item.vld = mp.sec_p_drv_cb.vld;
      item.wr = mp.sec_p_drv_cb.wr;
      item.wdata = mp.sec_p_drv_cb.wdata;
      item.addr = mp.sec_p_drv_cb.addr;
      // pragma uvmx sec_p_drv_sample_post_clk begin
      // pragma uvmx sec_p_drv_sample_post_clk end
   endtask

   // pragma uvmx sec_p_drv_methods begin
   // pragma uvmx sec_p_drv_methods end
endclass


`endif // __UVMA_MPB_SEC_P_DRV_SV__
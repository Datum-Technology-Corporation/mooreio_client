// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_HOST_EG_DRV_SV__
`define __UVMA_MSTREAM_HOST_EG_DRV_SV__


/**
 * Driver driving uvma_mstream_if with HOST Egress Sequence Items (uvma_mstream_host_eg_seq_item_c).
 * @ingroup uvma_mstream_comps
 */
class uvma_mstream_host_eg_drv_c extends uvmx_mp_drv_c #(
   .T_CFG     (uvma_mstream_cfg_c  ),
   .T_CNTXT   (uvma_mstream_cntxt_c),
   .T_MP      (virtual uvma_mstream_if.host_eg_drv_mp ),
   .T_SEQ_ITEM(        uvma_mstream_host_eg_seq_item_c)
);

   // pragma uvmx host_eg_drv_fields begin
   // pragma uvmx host_eg_drv_fields end


   `uvm_component_utils_begin(uvma_mstream_host_eg_drv_c)
      // pragma uvmx host_eg_drv_uvm_field_macros begin
      // pragma uvmx host_eg_drv_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_drv(host_eg_drv_mp, host_eg_drv_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_host_eg_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Drives HOST Egress driver clocking block (host_eg_drv_cb) at the beginning of each clock cycle.
    */
   virtual task drive_item(ref uvma_mstream_host_eg_seq_item_c item);
      `uvmx_mp_drv_signal(item, eg_rdy)
      // pragma uvmx host_eg_drv_drive_item begin
      // pragma uvmx host_eg_drv_drive_item end
   endtask

   /**
    * Samples the HOST Egress Driver clocking block (host_eg_drv_cb) at the end of each clock cycle.
    */
   virtual task sample_post_clk(ref uvma_mstream_host_eg_seq_item_c item);
      `uvmx_mp_mon_signal(item, eg_vld)
      `uvmx_mp_mon_signal(item, eg_r0)
      `uvmx_mp_mon_signal(item, eg_r1)
      `uvmx_mp_mon_signal(item, eg_r2)
      // pragma uvmx host_eg_drv_sample_post_clk begin
      // pragma uvmx host_eg_drv_sample_post_clk end
   endtask

   // pragma uvmx host_eg_drv_methods begin
   // pragma uvmx host_eg_drv_methods end
endclass


`endif // __UVMA_MSTREAM_HOST_EG_DRV_SV__
// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_CP_DRV_SV__
`define __UVMA_MAPU_B_CP_DRV_SV__


/**
 * Driver driving uvma_mapu_b_if with Control Plane Sequence Items (uvma_mapu_b_cp_seq_item_c).
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_cp_drv_c extends uvmx_mp_drv_c #(
   .T_CFG     (uvma_mapu_b_cfg_c  ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c),
   .T_MP      (virtual uvma_mapu_b_if.cp_drv_mp ),
   .T_SEQ_ITEM(        uvma_mapu_b_cp_seq_item_c)
);

   // pragma uvmx cp_drv_fields begin
   // pragma uvmx cp_drv_fields end


   `uvm_component_utils_begin(uvma_mapu_b_cp_drv_c)
      // pragma uvmx cp_drv_uvm_field_macros begin
      // pragma uvmx cp_drv_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_drv(cp_drv_mp, cp_drv_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_cp_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Drives Control Plane driver clocking block (cp_drv_cb) at the beginning of each clock cycle.
    */
   virtual task drive_item(ref uvma_mapu_b_cp_seq_item_c item);
      `uvmx_mp_drv_signal(item, i_en)
      `uvmx_mp_drv_signal(item, i_op)
      // pragma uvmx cp_drv_drive_item begin
      // pragma uvmx cp_drv_drive_item end
   endtask

   /**
    * Samples the Control Plane Driver clocking block (cp_drv_cb) at the end of each clock cycle.
    */
   virtual task sample_post_clk(ref uvma_mapu_b_cp_seq_item_c item);
      `uvmx_mp_mon_signal(item, o_of)
      // pragma uvmx cp_drv_sample_post_clk begin
      // pragma uvmx cp_drv_sample_post_clk end
   endtask

   // pragma uvmx cp_drv_methods begin
   // pragma uvmx cp_drv_methods end
endclass


`endif // __UVMA_MAPU_B_CP_DRV_SV__
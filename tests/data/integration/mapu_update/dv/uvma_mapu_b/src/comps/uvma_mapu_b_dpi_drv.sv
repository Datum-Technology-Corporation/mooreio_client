// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_DPI_DRV_SV__
`define __UVMA_MAPU_B_DPI_DRV_SV__


/**
 * Driver driving uvma_mapu_b_if with Data Plane Input Sequence Items (uvma_mapu_b_dpi_seq_item_c).
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_dpi_drv_c extends uvmx_mp_drv_c #(
   .T_CFG     (uvma_mapu_b_cfg_c  ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c),
   .T_MP      (virtual uvma_mapu_b_if.dpi_drv_mp ),
   .T_SEQ_ITEM(        uvma_mapu_b_dpi_seq_item_c)
);

   // pragma uvmx dpi_drv_fields begin
   // pragma uvmx dpi_drv_fields end


   `uvm_component_utils_begin(uvma_mapu_b_dpi_drv_c)
      // pragma uvmx dpi_drv_uvm_field_macros begin
      // pragma uvmx dpi_drv_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_drv(dpi_drv_mp, dpi_drv_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_dpi_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Drives Data Plane Input driver clocking block (dpi_drv_cb) at the beginning of each clock cycle.
    */
   virtual task drive_item(ref uvma_mapu_b_dpi_seq_item_c item);
      mp.dpi_drv_cb.i_vld <= item.i_vld;
      mp.dpi_drv_cb.i_r0 <= item.i_r0;
      mp.dpi_drv_cb.i_r1 <= item.i_r1;
      mp.dpi_drv_cb.i_r2 <= item.i_r2;
      // pragma uvmx dpi_drv_drive_item begin
      // pragma uvmx dpi_drv_drive_item end
   endtask

   /**
    * Samples the Data Plane Input Driver clocking block (dpi_drv_cb) at the end of each clock cycle.
    */
   virtual task sample_post_clk(ref uvma_mapu_b_dpi_seq_item_c item);
      item.o_rdy = mp.dpi_drv_cb.o_rdy;
      // pragma uvmx dpi_drv_sample_post_clk begin
      // pragma uvmx dpi_drv_sample_post_clk end
   endtask

   // pragma uvmx dpi_drv_methods begin
   // pragma uvmx dpi_drv_methods end
endclass


`endif // __UVMA_MAPU_B_DPI_DRV_SV__
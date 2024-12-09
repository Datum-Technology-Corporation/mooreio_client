// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_DPI_MON_SV__
`define __UVMA_MAPU_B_DPI_MON_SV__


/**
 * Monitor sampling Data Plane Input monitor transactions (uvma_mapu_b_dpi_mon_trn_c) from uvma_mapu_b_if.
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_dpi_mon_c extends uvmx_mp_mon_c #(
   .T_CFG    (uvma_mapu_b_cfg_c  ),
   .T_CNTXT  (uvma_mapu_b_cntxt_c),
   .T_MP     (virtual uvma_mapu_b_if.dpi_mon_mp),
   .T_MON_TRN(        uvma_mapu_b_dpi_mon_trn_c)
);

   // pragma uvmx dpi_mon_fields begin
   // pragma uvmx dpi_mon_fields end


   `uvm_component_utils_begin(uvma_mapu_b_dpi_mon_c)
      // pragma uvmx dpi_mon_uvm_field_macros begin
      // pragma uvmx dpi_mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_mon(dpi_mon_mp, dpi_mon_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_dpi_mon", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx dpi_mon_constructor begin
      // pragma uvmx dpi_mon_constructor end
   endfunction

   /**
    * Samples #trn from the Data Plane Input monitor clocking block (dpi_mon_cb) on each clock cycle.
    */
   virtual task sample_trn(ref uvma_mapu_b_dpi_mon_trn_c trn);
      `uvmx_mp_mon_signal(trn, i_vld)
      `uvmx_mp_mon_signal(trn, o_rdy)
      `uvmx_mp_mon_signal(trn, i_r0)
      `uvmx_mp_mon_signal(trn, i_r1)
      `uvmx_mp_mon_signal(trn, i_r2)
      `uvmx_mp_mon_signal(trn, i_r3)
      // pragma uvmx dpi_mon_sample_trn begin
      // pragma uvmx dpi_mon_sample_trn end
   endtask

   /**
    * Trims data outside configured widths.
    */
   virtual function void process_trn(ref uvma_mapu_b_dpi_mon_trn_c trn);
      foreach (trn.i_r0[ii]) begin
         `uvmx_trim(trn.i_r0, cfg.data_width)
      end      foreach (trn.i_r1[ii]) begin
         `uvmx_trim(trn.i_r1, cfg.data_width)
      end      foreach (trn.i_r2[ii]) begin
         `uvmx_trim(trn.i_r2, cfg.data_width)
      end      foreach (trn.i_r3[ii]) begin
         `uvmx_trim(trn.i_r3, cfg.data_width)
      end      // pragma uvmx dpi_mon_process_trn begin
      // pragma uvmx dpi_mon_process_trn end
   endfunction

   // pragma uvmx dpi_mon_methods begin
   // pragma uvmx dpi_mon_methods end
endclass


`endif // __UVMA_MAPU_B_DPI_MON_SV__
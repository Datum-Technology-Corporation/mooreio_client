// Copyright 2025 Datron Limited Partnership
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
   endfunction

   /**
    * Samples #trn from the Data Plane Input monitor clocking block (dpi_mon_cb) on each clock cycle.
    */
   virtual task sample_trn(ref uvma_mapu_b_dpi_mon_trn_c trn);
      trn.i_vld = mp.dpi_mon_cb.i_vld;
      trn.o_rdy = mp.dpi_mon_cb.o_rdy;
      trn.i_r0 = mp.dpi_mon_cb.i_r0;
      trn.i_r1 = mp.dpi_mon_cb.i_r1;
      trn.i_r2 = mp.dpi_mon_cb.i_r2;
      // pragma uvmx dpi_mon_sample_trn begin
      // pragma uvmx dpi_mon_sample_trn end
   endtask

   /**
    * Determine if sampled transaction is meaningful traffic.
    */
   virtual function bit is_idle(ref uvma_mapu_b_dpi_mon_trn_c current_trn, ref uvma_mapu_b_dpi_mon_trn_c last_trn);
      // pragma uvmx dpi_mon_is_idle begin
      return current_trn.i_vld !== 1;
      // pragma uvmx dpi_mon_is_idle end
   endfunction

   /**
    * Trims data outside configured widths.
    */
   virtual function void process_trn(ref uvma_mapu_b_dpi_mon_trn_c trn);
      `uvmx_trim(trn.i_r0, cfg.data_width)
      `uvmx_trim(trn.i_r1, cfg.data_width)
      `uvmx_trim(trn.i_r2, cfg.data_width)
      // pragma uvmx dpi_mon_process_trn begin
      // pragma uvmx dpi_mon_process_trn end
   endfunction

   // pragma uvmx dpi_mon_methods begin
   // pragma uvmx dpi_mon_methods end
endclass


`endif // __UVMA_MAPU_B_DPI_MON_SV__
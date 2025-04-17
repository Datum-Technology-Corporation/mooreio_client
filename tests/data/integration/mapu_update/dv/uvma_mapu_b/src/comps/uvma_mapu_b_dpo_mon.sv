// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_DPO_MON_SV__
`define __UVMA_MAPU_B_DPO_MON_SV__


/**
 * Monitor sampling Data Plane Output monitor transactions (uvma_mapu_b_dpo_mon_trn_c) from uvma_mapu_b_if.
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_dpo_mon_c extends uvmx_mp_mon_c #(
   .T_CFG    (uvma_mapu_b_cfg_c  ),
   .T_CNTXT  (uvma_mapu_b_cntxt_c),
   .T_MP     (virtual uvma_mapu_b_if.dpo_mon_mp),
   .T_MON_TRN(        uvma_mapu_b_dpo_mon_trn_c)
);

   // pragma uvmx dpo_mon_fields begin
   // pragma uvmx dpo_mon_fields end


   `uvm_component_utils_begin(uvma_mapu_b_dpo_mon_c)
      // pragma uvmx dpo_mon_uvm_field_macros begin
      // pragma uvmx dpo_mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_mon(dpo_mon_mp, dpo_mon_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_dpo_mon", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Samples #trn from the Data Plane Output monitor clocking block (dpo_mon_cb) on each clock cycle.
    */
   virtual task sample_trn(ref uvma_mapu_b_dpo_mon_trn_c trn);
      `uvmx_mp_mon_signal(trn, o_vld)
      `uvmx_mp_mon_signal(trn, i_rdy)
      `uvmx_mp_mon_signal(trn, o_r0)
      `uvmx_mp_mon_signal(trn, o_r1)
      `uvmx_mp_mon_signal(trn, o_r2)
      // pragma uvmx dpo_mon_sample_trn begin
      // pragma uvmx dpo_mon_sample_trn end
   endtask

   /**
    * Determine if sampled transaction is meaningful traffic.
    */
   virtual function bit is_idle(ref uvma_mapu_b_dpo_mon_trn_c current_trn, ref uvma_mapu_b_dpo_mon_trn_c last_trn);
      // pragma uvmx dpo_mon_is_idle begin
      return current_trn.o_vld !== 1;
      // pragma uvmx dpo_mon_is_idle end
   endfunction

   /**
    * Trims data outside configured widths.
    */
   virtual function void process_trn(ref uvma_mapu_b_dpo_mon_trn_c trn);
      foreach (trn.o_r0[ii]) begin
         `uvmx_trim(trn.o_r0, cfg.data_width)
      end      foreach (trn.o_r1[ii]) begin
         `uvmx_trim(trn.o_r1, cfg.data_width)
      end      foreach (trn.o_r2[ii]) begin
         `uvmx_trim(trn.o_r2, cfg.data_width)
      end      // pragma uvmx dpo_mon_process_trn begin
      // pragma uvmx dpo_mon_process_trn end
   endfunction

   // pragma uvmx dpo_mon_methods begin
   // pragma uvmx dpo_mon_methods end
endclass


`endif // __UVMA_MAPU_B_DPO_MON_SV__
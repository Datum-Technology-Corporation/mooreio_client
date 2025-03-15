// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_CP_MON_SV__
`define __UVMA_MAPU_B_CP_MON_SV__


/**
 * Monitor sampling Control Plane monitor transactions (uvma_mapu_b_cp_mon_trn_c) from uvma_mapu_b_if.
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_cp_mon_c extends uvmx_mp_mon_c #(
   .T_CFG    (uvma_mapu_b_cfg_c  ),
   .T_CNTXT  (uvma_mapu_b_cntxt_c),
   .T_MP     (virtual uvma_mapu_b_if.cp_mon_mp),
   .T_MON_TRN(        uvma_mapu_b_cp_mon_trn_c)
);

   // pragma uvmx cp_mon_fields begin
   // pragma uvmx cp_mon_fields end


   `uvm_component_utils_begin(uvma_mapu_b_cp_mon_c)
      // pragma uvmx cp_mon_uvm_field_macros begin
      // pragma uvmx cp_mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_mon(cp_mon_mp, cp_mon_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_cp_mon", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx cp_mon_constructor begin
      // pragma uvmx cp_mon_constructor end
   endfunction

   /**
    * Samples #trn from the Control Plane monitor clocking block (cp_mon_cb) on each clock cycle.
    */
   virtual task sample_trn(ref uvma_mapu_b_cp_mon_trn_c trn);
      `uvmx_mp_mon_signal(trn, i_en)
      `uvmx_mp_mon_signal(trn, i_op)
      `uvmx_mp_mon_signal(trn, o_of)
      // pragma uvmx cp_mon_sample_trn begin
      // pragma uvmx cp_mon_sample_trn end
   endtask

   /**
    * Determine if sampled transaction is meaningful traffic.
    */
   virtual function bit is_idle(ref uvma_mapu_b_cp_mon_trn_c current_trn, ref uvma_mapu_b_cp_mon_trn_c last_trn);
      // pragma uvmx cp_mon_is_idle begin
      // TODO Implement uvma_mapu_b_cp_mon_c::is_idle()
      return super.is_idle(current_trn, last_trn);
      // pragma uvmx cp_mon_is_idle end
   endfunction


   // pragma uvmx cp_mon_methods begin
   // pragma uvmx cp_mon_methods end
endclass


`endif // __UVMA_MAPU_B_CP_MON_SV__
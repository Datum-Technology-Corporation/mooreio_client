// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_IG_MON_SV__
`define __UVMA_MSTREAM_IG_MON_SV__


/**
 * Monitor sampling Ingress monitor transactions (uvma_mstream_ig_mon_trn_c) from uvma_mstream_if.
 * @ingroup uvma_mstream_comps
 */
class uvma_mstream_ig_mon_c extends uvmx_mp_mon_c #(
   .T_CFG    (uvma_mstream_cfg_c  ),
   .T_CNTXT  (uvma_mstream_cntxt_c),
   .T_MP     (virtual uvma_mstream_if.ig_mon_mp),
   .T_MON_TRN(        uvma_mstream_ig_mon_trn_c)
);

   // pragma uvmx ig_mon_fields begin
   // pragma uvmx ig_mon_fields end


   `uvm_component_utils_begin(uvma_mstream_ig_mon_c)
      // pragma uvmx ig_mon_uvm_field_macros begin
      // pragma uvmx ig_mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_mon(ig_mon_mp, ig_mon_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_ig_mon", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Samples #trn from the Ingress monitor clocking block (ig_mon_cb) on each clock cycle.
    */
   virtual task sample_trn(ref uvma_mstream_ig_mon_trn_c trn);
      trn.ig_vld = mp.ig_mon_cb.ig_vld;
      trn.ig_rdy = mp.ig_mon_cb.ig_rdy;
      trn.ig_r0 = mp.ig_mon_cb.ig_r0;
      trn.ig_r1 = mp.ig_mon_cb.ig_r1;
      trn.ig_r2 = mp.ig_mon_cb.ig_r2;
      // pragma uvmx ig_mon_sample_trn begin
      // pragma uvmx ig_mon_sample_trn end
   endtask

   /**
    * Determine if sampled transaction is meaningful traffic.
    */
   virtual function bit is_idle(ref uvma_mstream_ig_mon_trn_c current_trn, ref uvma_mstream_ig_mon_trn_c last_trn);
      // pragma uvmx ig_mon_is_idle begin
      return !current_trn.ig_vld;
      // pragma uvmx ig_mon_is_idle end
   endfunction


   // pragma uvmx ig_mon_methods begin
   // pragma uvmx ig_mon_methods end
endclass


`endif // __UVMA_MSTREAM_IG_MON_SV__
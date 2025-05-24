// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_P_MON_SV__
`define __UVMA_MPB_P_MON_SV__


/**
 * Monitor sampling Parallel monitor transactions (uvma_mpb_p_mon_trn_c) from uvma_mpb_if.
 * @ingroup uvma_mpb_comps
 */
class uvma_mpb_p_mon_c extends uvmx_mp_mon_c #(
   .T_CFG    (uvma_mpb_cfg_c  ),
   .T_CNTXT  (uvma_mpb_cntxt_c),
   .T_MP     (virtual uvma_mpb_if.p_mon_mp),
   .T_MON_TRN(        uvma_mpb_p_mon_trn_c)
);

   // pragma uvmx p_mon_fields begin
   // pragma uvmx p_mon_fields end


   `uvm_component_utils_begin(uvma_mpb_p_mon_c)
      // pragma uvmx p_mon_uvm_field_macros begin
      // pragma uvmx p_mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mp_mon(p_mon_mp, p_mon_cb)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_p_mon", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Samples #trn from the Parallel monitor clocking block (p_mon_cb) on each clock cycle.
    */
   virtual task sample_trn(ref uvma_mpb_p_mon_trn_c trn);
      trn.vld = mp.p_mon_cb.vld;
      trn.rdy = mp.p_mon_cb.rdy;
      trn.wr = mp.p_mon_cb.wr;
      trn.rdata = mp.p_mon_cb.rdata;
      trn.wdata = mp.p_mon_cb.wdata;
      trn.addr = mp.p_mon_cb.addr;
      // pragma uvmx p_mon_sample_trn begin
      // pragma uvmx p_mon_sample_trn end
   endtask

   /**
    * Determine if sampled transaction is meaningful traffic.
    */
   virtual function bit is_idle(ref uvma_mpb_p_mon_trn_c current_trn, ref uvma_mpb_p_mon_trn_c last_trn);
      // pragma uvmx p_mon_is_idle begin
      return !current_trn.vld;
      // pragma uvmx p_mon_is_idle end
   endfunction


   // pragma uvmx p_mon_methods begin
   // pragma uvmx p_mon_methods end
endclass


`endif // __UVMA_MPB_P_MON_SV__
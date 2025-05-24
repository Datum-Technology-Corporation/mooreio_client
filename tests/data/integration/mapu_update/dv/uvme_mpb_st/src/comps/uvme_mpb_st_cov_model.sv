// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_COV_MODEL_SV__
`define __UVME_MPB_ST_COV_MODEL_SV__


/**
 * Component encapsulating Matrix Peripheral Bus Agent's functional coverage model.
 * @ingroup uvme_mpb_st_comps
 */
class uvme_mpb_st_cov_model_c extends uvmx_agent_env_cov_model_c #(
   .T_CFG  (uvme_mpb_st_cfg_c  ),
   .T_CNTXT(uvme_mpb_st_cntxt_c)
);

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mpb_access_seq_item_c)  access_seq_item_fifo; ///< Agent main sequence item
   uvm_tlm_analysis_fifo #(uvma_mpb_access_mon_trn_c)  access_mon_trn_fifo; ///< Agent main monitor transaction
   /// @}

   // pragma uvmx cov_model_fields begin
   /// @name Objects
   /// @{
   uvma_mpb_access_seq_item_c  access_seq_item; ///< Agent main sequence item Sequence Item being sampled.
   uvma_mpb_access_mon_trn_c  access_mon_trn; ///< Agent main monitor transaction Monitor Transaction being sampled.
   /// @}
   // pragma uvmx cov_model_fields end


   `uvm_component_utils_begin(uvme_mpb_st_cov_model_c)
      // pragma uvmx cov_model_uvm_field_macros begin
      // pragma uvmx cov_model_uvm_field_macros end
   `uvm_component_utils_end


   // pragma uvmx cov_model_covergroups begin
   // TODO Add covergroups to uvme_mpb_st_cov_model_c
   // pragma uvmx cov_model_covergroups end


   /**
    * Creates covergroups.
    */
   function new(string name="uvme_mpb_st_cov_model", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx cov_model_constructor begin
      // TODO Create uvme_mpb_st_cov_model_c covergroups
      // pragma uvmx cov_model_constructor end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      access_seq_item_fifo = new("access_seq_item_fifo", this);
      access_mon_trn_fifo = new("access_mon_trn_fifo", this);
      // pragma uvmx cov_model_create_fifos begin
      // pragma uvmx cov_model_create_fifos end
   endfunction

   // pragma uvmx cov_model_sample_cfg_dox begin
   /**
    * TODO Implement uvme_mpb_st_cov_model_c::sample_cfg()
    */
   // pragma uvmx cov_model_sample_cfg_dox end
   virtual function void sample_cfg();
      // pragma uvmx cov_model_sample_cfg begin
      // ...
      // pragma uvmx cov_model_sample_cfg end
   endfunction

   // pragma uvmx cov_model_sample_dox begin
   /**
    * TODO Implement uvme_mpb_st_cov_model_c::sample()
    */
   // pragma uvmx cov_model_sample_dox end
   virtual task sample();
      // pragma uvmx cov_model_sample begin
      fork
         forever begin
            access_seq_item_fifo.get(access_seq_item);
            // ...
         end
         forever begin
            access_mon_trn_fifo.get(access_mon_trn);
            // ...
         end
      join
      // pragma uvmx cov_model_sample end
   endtask

   // pragma uvmx cov_model_methods begin
   // pragma uvmx cov_model_methods end

endclass


`endif // __UVME_MPB_ST_COV_MODEL_SV__
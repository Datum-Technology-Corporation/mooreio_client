// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_COV_MODEL_SV__
`define __UVME_MSTREAM_ST_COV_MODEL_SV__


/**
 * Component encapsulating Matrix Stream Interface Agent's functional coverage model.
 * @ingroup uvme_mstream_st_comps
 */
class uvme_mstream_st_cov_model_c extends uvmx_agent_env_cov_model_c #(
   .T_CFG  (uvme_mstream_st_cfg_c  ),
   .T_CNTXT(uvme_mstream_st_cntxt_c)
);

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_seq_item_c)  stim_op_seq_item_fifo; ///< Agent operation
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_mon_trn_c)  ig_mon_trn_fifo; ///< Ingress
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_mon_trn_c)  eg_mon_trn_fifo; ///< Egress
   /// @}

   // pragma uvmx cov_model_fields begin
   /// @name Objects
   /// @{
   uvma_mstream_pkt_seq_item_c  stim_op_seq_item; ///< Agent operation Sequence Item being sampled.
   uvma_mstream_pkt_mon_trn_c  ig_mon_trn; ///< Ingress Monitor Transaction being sampled.
   uvma_mstream_pkt_mon_trn_c  eg_mon_trn; ///< Egress Monitor Transaction being sampled.
   /// @}
   // pragma uvmx cov_model_fields end


   `uvm_component_utils_begin(uvme_mstream_st_cov_model_c)
      // pragma uvmx cov_model_uvm_field_macros begin
      // pragma uvmx cov_model_uvm_field_macros end
   `uvm_component_utils_end


   // pragma uvmx cov_model_covergroups begin
   // TODO Add covergroups to uvme_mstream_st_cov_model_c
   // pragma uvmx cov_model_covergroups end


   /**
    * Creates covergroups.
    */
   function new(string name="uvme_mstream_st_cov_model", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx cov_model_constructor begin
      // TODO Create uvme_mstream_st_cov_model_c covergroups
      // pragma uvmx cov_model_constructor end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      stim_op_seq_item_fifo = new("stim_op_seq_item_fifo", this);
      ig_mon_trn_fifo = new("ig_mon_trn_fifo", this);
      eg_mon_trn_fifo = new("eg_mon_trn_fifo", this);
      // pragma uvmx cov_model_create_fifos begin
      // pragma uvmx cov_model_create_fifos end
   endfunction

   // pragma uvmx cov_model_sample_dox begin
   /**
    * TODO Implement uvme_mstream_st_cov_model_c::sample()
    */
   // pragma uvmx cov_model_sample_dox end
   virtual task sample();
      // pragma uvmx cov_model_sample begin
      fork
         forever begin
            stim_op_seq_item_fifo.get(stim_op_seq_item);
            // ...
         end
         forever begin
            ig_mon_trn_fifo.get(ig_mon_trn);
            // ...
         end
         forever begin
            eg_mon_trn_fifo.get(eg_mon_trn);
            // ...
         end
      join
      // pragma uvmx cov_model_sample end
   endtask

   // pragma uvmx cov_model_methods begin
   // pragma uvmx cov_model_methods end

endclass


`endif // __UVME_MSTREAM_ST_COV_MODEL_SV__
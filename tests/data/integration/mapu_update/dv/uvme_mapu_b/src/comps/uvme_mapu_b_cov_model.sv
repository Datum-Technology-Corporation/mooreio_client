// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_COV_MODEL_SV__
`define __UVME_MAPU_B_COV_MODEL_SV__


/**
 * Component encapsulating Matrix APU Block's functional coverage model.
 * @ingroup uvme_mapu_b_comps
 */
class uvme_mapu_b_cov_model_c extends uvmx_block_sb_env_cov_model_c #(
   .T_CFG  (uvme_mapu_b_cfg_c  ),
   .T_CNTXT(uvme_mapu_b_cntxt_c)
);

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mapu_b_op_seq_item_c)  agent_op_seq_item_fifo; ///< Input FIFO for Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_ig_mon_trn_c)  agent_ig_mon_trn_fifo; ///< Input FIFO for Agent Ingress Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_eg_mon_trn_c)  agent_eg_mon_trn_fifo; ///< Input FIFO for Agent Egress Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_eg_mon_trn_c)  predictor_eg_mon_trn_fifo; ///< Input FIFO for Predictor Egress Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpi_seq_item_c)  agent_dpi_seq_item_fifo; ///< Input FIFO for Agent Data Plane Input Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpo_seq_item_c)  agent_dpo_seq_item_fifo; ///< Input FIFO for Agent Data Plane Output Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_cp_seq_item_c)  agent_cp_seq_item_fifo; ///< Input FIFO for Agent Control Plane Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpi_mon_trn_c)  agent_dpi_mon_trn_fifo; ///< Input FIFO for Agent Data Plane Input Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpo_mon_trn_c)  agent_dpo_mon_trn_fifo; ///< Input FIFO for Agent Data Plane Output Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_cp_mon_trn_c)  agent_cp_mon_trn_fifo; ///< Input FIFO for Agent Control Plane Monitor Transactions.
   /// @}

   // pragma uvmx cov_model_fields begin
   uvma_mapu_b_op_seq_item_c   agent_op_seq_item; ///< Sequence Item being sampled.
   uvma_mapu_b_ig_mon_trn_c    agent_ig_mon_trn; ///< Ingress Monitor Transaction being sampled.
   uvma_mapu_b_eg_mon_trn_c    predictor_eg_mon_trn; ///< Egress Monitor Transaction being sampled.
   uvma_mapu_b_cp_seq_item_c   agent_cp_seq_item; ///< Control Plane Sequence Item being sampled.
   uvma_mapu_b_cp_mon_trn_c    agent_cp_mon_trn; ///< Control Plane Monitor Transaction being sampled.
   // pragma uvmx cov_model_fields end


   `uvm_component_utils_begin(uvme_mapu_b_cov_model_c)
      // pragma uvmx cov_model_uvm_field_macros begin
      // pragma uvmx cov_model_uvm_field_macros end
   `uvm_component_utils_end


   // pragma uvmx cov_model_covergroups begin
   /**
    * Environment configuration functional coverage.
    */
   covergroup mapu_b_cfg_cg;
      data_width_cp : coverpoint cfg.data_width {
         bins valid[] = {32,64};
      }
      eg_drv_ton_pct_cp : coverpoint cfg.agent_cfg.eg_drv_ton_pct {
         bins valid[] = {[1:100]};
      }
   endgroup

   /**
    * Environment context functional coverage.
    */
   covergroup mapu_b_cntxt_cg;
      prd_overflow_count_cp : coverpoint cntxt.prd_overflow_count {
         bins at_least_one[] = {[1:$]};
      }
   endgroup

   /**
    * Sequence Item functional coverage.
    */
   covergroup mapu_b_op_seq_item_cg;
      op_cp : coverpoint agent_op_seq_item.op;
      coverpoint agent_op_seq_item.ton_pct {
         bins valid[] = {[1:100]};
      }
   endgroup

   /**
    * Ingress Monitor Transaction functional coverage.
    */
   covergroup mapu_b_ig_mon_trn_cg;
      op_cp : coverpoint agent_ig_mon_trn.op;
   endgroup

   /**
    * Egress Monitor Transaction functional coverage.
    */
   covergroup mapu_b_eg_mon_trn_cg;
      overflow_cp : coverpoint predictor_eg_mon_trn.overflow;
   endgroup

   /**
    * Control Plane Sequence Item functional coverage.
    */
   covergroup mapu_b_cp_seq_item_cg;
      i_op_cp : coverpoint agent_cp_seq_item.i_op;
   endgroup

   /**
    * Control Plane Monitor Transaction functional coverage.
    */
   covergroup mapu_b_cp_mon_trn_cg;
      o_of_cp : coverpoint agent_cp_mon_trn.o_of;
   endgroup
   // pragma uvmx cov_model_covergroups end


   /**
    * Creates covergroups.
    */
   function new(string name="uvme_mapu_b_cov_model", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx cov_model_constructor begin
      mapu_b_cfg_cg          = new();
      mapu_b_cntxt_cg        = new();
      mapu_b_op_seq_item_cg  = new();
      mapu_b_ig_mon_trn_cg   = new();
      mapu_b_eg_mon_trn_cg   = new();
      mapu_b_cp_seq_item_cg  = new();
      mapu_b_cp_mon_trn_cg   = new();
      // pragma uvmx cov_model_constructor end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      agent_op_seq_item_fifo = new("op_seq_item_fifo", this);
      agent_ig_mon_trn_fifo = new("ig_mon_trn_fifo", this);
      agent_eg_mon_trn_fifo = new("eg_mon_trn_fifo", this);
      predictor_eg_mon_trn_fifo = new("eg_mon_trn_fifo", this);
      agent_dpi_seq_item_fifo = new("dpi_seq_item_fifo", this);
      agent_dpo_seq_item_fifo = new("dpo_seq_item_fifo", this);
      agent_cp_seq_item_fifo = new("cp_seq_item_fifo", this);
      agent_dpi_mon_trn_fifo = new("dpi_mon_trn_fifo", this);
      agent_dpo_mon_trn_fifo = new("dpo_mon_trn_fifo", this);
      agent_cp_mon_trn_fifo = new("cp_mon_trn_fifo", this);
      // pragma uvmx cov_model_create_fifos begin
      // pragma uvmx cov_model_create_fifos end
   endfunction

   // pragma uvmx cov_model_sample_dox begin
   virtual function void sample_cfg  (); mapu_b_cfg_cg  .sample(); endfunction
   virtual function void sample_cntxt(); mapu_b_cntxt_cg.sample(); endfunction
   /**
    * TODO Implement uvme_mapu_b_cov_model_c::sample()
    */
   // pragma uvmx cov_model_sample_dox end
   virtual task sample();
      // pragma uvmx cov_model_sample begin
      fork
         forever begin
            agent_op_seq_item_fifo.get(agent_op_seq_item);
            mapu_b_op_seq_item_cg.sample();
         end
         forever begin
            agent_ig_mon_trn_fifo.get(agent_ig_mon_trn);
            mapu_b_ig_mon_trn_cg.sample();
         end
         forever begin
            predictor_eg_mon_trn_fifo.get(predictor_eg_mon_trn);
            mapu_b_eg_mon_trn_cg.sample();
         end
         forever begin
            agent_cp_seq_item_fifo.get(agent_cp_seq_item);
            mapu_b_cp_seq_item_cg.sample();
         end
         forever begin
            agent_cp_mon_trn_fifo.get(agent_cp_mon_trn);
            mapu_b_cp_mon_trn_cg.sample();
         end
      join
      // pragma uvmx cov_model_sample end
   endtask

   // pragma uvmx cov_model_methods begin
   // pragma uvmx cov_model_methods end

endclass


`endif // __UVME_MAPU_B_COV_MODEL_SV__
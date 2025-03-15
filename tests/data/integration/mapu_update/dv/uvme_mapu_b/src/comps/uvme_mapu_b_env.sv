// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_ENV_SV__
`define __UVME_MAPU_B_ENV_SV__


/**
 * Matrix APU Block UVM Environment with TLM self-checking scoreboards and prediction.
 * @ingroup uvme_mapu_b_comps
 */
class uvme_mapu_b_env_c extends uvmx_block_sb_env_c #(
   .T_CFG      (uvme_mapu_b_cfg_c      ),
   .T_CNTXT    (uvme_mapu_b_cntxt_c    ),
   .T_SQR      (uvme_mapu_b_sqr_c      ),
   .T_PRD      (uvme_mapu_b_prd_c      ),
   .T_SB       (uvme_mapu_b_sb_c       ),
   .T_COV_MODEL(uvme_mapu_b_cov_model_c)
);

   /// @name Agents
   /// @{
   uvma_mapu_b_agent_c  agent; ///< Block agent
   /// @}

   // pragma uvmx env_fields begin
   // pragma uvmx env_fields end


   `uvm_component_utils_begin(uvme_mapu_b_env_c)
      // pragma uvmx env_uvm_field_macros begin
      // pragma uvmx env_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_env", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx env_constructor begin
      // pragma uvmx env_constructor end
   endfunction

   /**
    * Assigns configuration handles to components using UVM Configuration Database.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvma_mapu_b_cfg_c)::set(this, "agent", "cfg", cfg.agent_cfg);
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "scoreboard", "cfg", cfg.sb_cfg);
      // pragma uvmx env_assign_cfg begin
      // pragma uvmx env_assign_cfg end
   endfunction

   /**
    * Assigns context handles to components using UVM Configuration Database.
    */
   virtual function void assign_cntxt();
      uvm_config_db#(uvma_mapu_b_cntxt_c)::set(this, "agent", "cntxt", cntxt.agent_cntxt);
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "scoreboard", "cntxt", cntxt.sb_cntxt);
      // pragma uvmx env_assign_cntxt begin
      // pragma uvmx env_assign_cntxt end
   endfunction

   /**
    * Creates agent components.
    */
   virtual function void create_agents();
      agent = uvma_mapu_b_agent_c::type_id::create("agent", this);
      // pragma uvmx env_create_agents begin
      // pragma uvmx env_create_agents end
   endfunction

   /**
    * Connects agents to predictor.
    */
   virtual function void connect_predictor();
      agent.in_mon_trn_ap.connect(predictor.fifo.analysis_export);
      // pragma uvmx env_connect_predictor begin
      // pragma uvmx env_connect_predictor end
   endfunction

   /**
    * Connects scoreboards components to agents/predictor.
    */
   virtual function void connect_scoreboard();
      predictor.ap.connect(scoreboard.exp_export);
      agent.out_mon_trn_ap.connect(scoreboard.act_export);
      // pragma uvmx env_connect_scoreboard begin
      // pragma uvmx env_connect_scoreboard end
   endfunction

   /**
    * Connects environment coverage model to agents/predictor/scoreboard.
    */
   virtual function void connect_coverage_model();
      agent.seq_item_ap    .connect(cov_model.seq_item_fifo    .analysis_export);
      agent.in_mon_trn_ap  .connect(cov_model.in_mon_trn_fifo  .analysis_export);
      agent.out_mon_trn_ap .connect(cov_model.out_mon_trn_fifo .analysis_export);
      agent.dpi_seq_item_ap.connect(cov_model.dpi_seq_item_fifo.analysis_export);
      agent.dpo_seq_item_ap.connect(cov_model.dpo_seq_item_fifo.analysis_export);
      agent.cp_seq_item_ap.connect(cov_model.cp_seq_item_fifo.analysis_export);
      agent.dpi_mon_trn_ap.connect(cov_model.dpi_mon_trn_fifo.analysis_export);
      agent.dpo_mon_trn_ap.connect(cov_model.dpo_mon_trn_fifo.analysis_export);
      agent.cp_mon_trn_ap.connect(cov_model.cp_mon_trn_fifo.analysis_export);
      // pragma uvmx env_connect_coverage_model begin
      // pragma uvmx env_connect_coverage_model end
   endfunction

   /**
    * Assembles sequencer from agent sequencers.
    */
   virtual function void assemble_sequencer();
      sequencer.agent_sequencer = agent.sequencer;
      // pragma uvmx env_start_sequences begin
      // pragma uvmx env_start_sequences end
   endfunction

   // pragma uvmx env_methods begin
   // pragma uvmx env_methods end

endclass


`endif // __UVME_MAPU_B_ENV_SV__
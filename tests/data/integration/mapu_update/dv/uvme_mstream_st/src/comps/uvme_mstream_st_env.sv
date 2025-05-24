// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_ENV_SV__
`define __UVME_MSTREAM_ST_ENV_SV__


/**
 * Matrix Stream Interface Agent Self-Test UVM Environment with TLM prediction.
 * @ingroup uvme_mstream_st_comps
 */
class uvme_mstream_st_env_c extends uvmx_agent_env_c #(
   .T_CFG      (uvme_mstream_st_cfg_c      ),
   .T_CNTXT    (uvme_mstream_st_cntxt_c    ),
   .T_SQR      (uvme_mstream_st_sqr_c      ),
   .T_PRD      (uvme_mstream_st_prd_c      ),
   .T_SB       (uvme_mstream_st_sb_c       ),
   .T_COV_MODEL(uvme_mstream_st_cov_model_c)
);

   /// @name Agents
   /// @{
   uvma_mstream_agent_c  host_agent; ///< HOST Agent instance.
   uvma_mstream_agent_c  card_agent; ///< CARD Agent instance.
   uvma_mstream_agent_c  passive_agent; ///< Passive Agent instance.
   /// @}

   // pragma uvmx env_fields begin
   // pragma uvmx env_fields end


   `uvm_component_utils_begin(uvme_mstream_st_env_c)
      // pragma uvmx env_uvm_field_macros begin
      // pragma uvmx env_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mstream_st_env", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Assigns configuration handles to components using UVM Configuration Database.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvma_mstream_cfg_c)::set(this, "host_agent", "cfg", cfg.host_agent_cfg);
      uvm_config_db#(uvma_mstream_cfg_c)::set(this, "card_agent", "cfg", cfg.card_agent_cfg);
      uvm_config_db#(uvma_mstream_cfg_c)::set(this, "passive_agent", "cfg", cfg.passive_agent_cfg);
      // pragma uvmx env_assign_cfg begin
      // pragma uvmx env_assign_cfg end
   endfunction

   /**
    * Assigns context handles to components using UVM Configuration Database.
    */
   virtual function void assign_cntxt();
      uvm_config_db#(uvma_mstream_cntxt_c)::set(this, "host_agent", "cntxt", cntxt.host_agent_cntxt);
      uvm_config_db#(uvma_mstream_cntxt_c)::set(this, "card_agent", "cntxt", cntxt.card_agent_cntxt);
      uvm_config_db#(uvma_mstream_cntxt_c)::set(this, "passive_agent", "cntxt", cntxt.passive_agent_cntxt);
      // pragma uvmx env_assign_cntxt begin
      // pragma uvmx env_assign_cntxt end
   endfunction

   /**
    * Creates agent components.
    */
   virtual function void create_agents();
      host_agent = uvma_mstream_agent_c::type_id::create("host_agent", this);
      card_agent = uvma_mstream_agent_c::type_id::create("card_agent", this);
      passive_agent = uvma_mstream_agent_c::type_id::create("passive_agent", this);
      // pragma uvmx env_create_agents begin
      // pragma uvmx env_create_agents end
   endfunction

   /**
    * Connects agents to predictor.
    */
   virtual function void connect_predictor();
      host_agent.seq_item_ap.connect(predictor.agent_ig_fifo.analysis_export);
      card_agent.seq_item_ap.connect(predictor.agent_eg_fifo.analysis_export);
      host_agent.ig_pkt_mon_trn_ap.connect(predictor.e2e_ig_fifo.analysis_export);
      card_agent.eg_pkt_mon_trn_ap.connect(predictor.e2e_eg_fifo.analysis_export);
      // pragma uvmx env_connect_predictor begin
      // pragma uvmx env_connect_predictor end
   endfunction

   /**
    * Connects scoreboards components to agents/predictor.
    */
   virtual function void connect_scoreboard();
      predictor.agent_ig_ap.connect(scoreboard.agent_ig_scoreboard.exp_export);
      passive_agent.ig_pkt_mon_trn_ap.connect(scoreboard.agent_ig_scoreboard.act_export);
      predictor.agent_eg_ap.connect(scoreboard.agent_eg_scoreboard.exp_export);
      passive_agent.eg_pkt_mon_trn_ap.connect(scoreboard.agent_eg_scoreboard.act_export);
      predictor.e2e_ig_ap.connect(scoreboard.e2e_ig_scoreboard.exp_export);
      card_agent.ig_pkt_mon_trn_ap.connect(scoreboard.e2e_ig_scoreboard.act_export);
      predictor.e2e_eg_ap.connect(scoreboard.e2e_eg_scoreboard.exp_export);
      host_agent.eg_pkt_mon_trn_ap.connect(scoreboard.e2e_eg_scoreboard.act_export);
      // pragma uvmx env_connect_scoreboard begin
      // pragma uvmx env_connect_scoreboard end
   endfunction

   /**
    * Connects environment coverage model to agent/predictor.
    */
   virtual function void connect_coverage_model();
      host_agent.seq_item_ap.connect(cov_model.stim_op_fifo.analysis_export);
      predictor.e2e_ig_ap.connect(cov_model.ig_fifo.analysis_export);
      predictor.e2e_eg_ap.connect(cov_model.eg_fifo.analysis_export);
      // pragma uvmx env_connect_coverage_model begin
      // pragma uvmx env_connect_coverage_model end
   endfunction

   /**
    * Assembles sequencer from agent sequencers.
    */
   virtual function void assemble_sequencer();
      sequencer.host_sequencer = host_agent.sequencer;
      sequencer.card_sequencer = card_agent.sequencer;
      sequencer.passive_sequencer = passive_agent.sequencer;
      // pragma uvmx env_start_sequences begin
      // pragma uvmx env_start_sequences end
   endfunction
   // pragma uvmx env_methods begin
   // pragma uvmx env_methods end

endclass


`endif // __UVME_MSTREAM_ST_ENV_SV__
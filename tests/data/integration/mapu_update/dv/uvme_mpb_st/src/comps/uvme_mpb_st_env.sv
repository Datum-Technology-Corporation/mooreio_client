// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_ENV_SV__
`define __UVME_MPB_ST_ENV_SV__


/**
 * Matrix Peripheral Bus Agent Self-Test UVM Environment with TLM prediction.
 * @ingroup uvme_mpb_st_comps
 */
class uvme_mpb_st_env_c extends uvmx_agent_env_c #(
   .T_CFG      (uvme_mpb_st_cfg_c      ),
   .T_CNTXT    (uvme_mpb_st_cntxt_c    ),
   .T_SQR      (uvme_mpb_st_sqr_c      ),
   .T_PRD      (uvme_mpb_st_prd_c      ),
   .T_SB       (uvme_mpb_st_sb_c       ),
   .T_COV_MODEL(uvme_mpb_st_cov_model_c)
);

   /// @name Agents
   /// @{
   uvma_mpb_agent_c  main_agent; ///< MAIN Agent instance.
   uvma_mpb_agent_c  sec_agent; ///< SEC Agent instance.
   uvma_mpb_agent_c  passive_agent; ///< Passive Agent instance.
   /// @}

   /// @name Register Abstraction Layer (RAL)
   /// @{
   uvma_mpb_reg_adapter_c    reg_adapter  ; ///< Converts between UVM 'register ops' and Sequence Items.
   uvma_mpb_reg_predictor_c  reg_predictor; ///< Converts between Monitor Transaction and UVM 'register ops'.
   /// @}

   // pragma uvmx env_fields begin
   // pragma uvmx env_fields end


   `uvm_component_utils_begin(uvme_mpb_st_env_c)
      // pragma uvmx env_uvm_field_macros begin
      // pragma uvmx env_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_env", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Assigns configuration handles to components using UVM Configuration Database.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvma_mpb_cfg_c)::set(this, "main_agent", "cfg", cfg.main_agent_cfg);
      uvm_config_db#(uvma_mpb_cfg_c)::set(this, "sec_agent", "cfg", cfg.sec_agent_cfg);
      uvm_config_db#(uvma_mpb_cfg_c)::set(this, "passive_agent", "cfg", cfg.passive_agent_cfg);
      // pragma uvmx env_assign_cfg begin
      // pragma uvmx env_assign_cfg end
   endfunction

   /**
    * Assigns context handles to components using UVM Configuration Database.
    */
   virtual function void assign_cntxt();
      uvm_config_db#(uvma_mpb_cntxt_c)::set(this, "main_agent", "cntxt", cntxt.main_agent_cntxt);
      uvm_config_db#(uvma_mpb_cntxt_c)::set(this, "sec_agent", "cntxt", cntxt.sec_agent_cntxt);
      uvm_config_db#(uvma_mpb_cntxt_c)::set(this, "passive_agent", "cntxt", cntxt.passive_agent_cntxt);
      // pragma uvmx env_assign_cntxt begin
      // pragma uvmx env_assign_cntxt end
   endfunction

   /**
    * Creates agent components.
    */
   virtual function void create_agents();
      main_agent = uvma_mpb_agent_c::type_id::create("main_agent", this);
      sec_agent = uvma_mpb_agent_c::type_id::create("sec_agent", this);
      passive_agent = uvma_mpb_agent_c::type_id::create("passive_agent", this);
      // pragma uvmx env_create_agents begin
      // pragma uvmx env_create_agents end
   endfunction

   /**
    * Creates reg_adapter.
    */
   virtual function void create_reg_adapter();
      reg_adapter = uvma_mpb_reg_adapter_c::type_id::create("reg_adapter");
      reg_adapter.cfg   = cfg  .main_agent_cfg  ;
      reg_adapter.cntxt = cntxt.main_agent_cntxt;
   endfunction

   /**
    * Creates reg_predictor.
    */
   virtual function void create_reg_predictor();
      reg_predictor = uvma_mpb_reg_predictor_c::type_id::create("reg_predictor", this);
   endfunction


   /**
    * Connects agents to predictor.
    */
   virtual function void connect_predictor();
      main_agent.seq_item_ap.connect(predictor.agent_m2s_fifo.analysis_export);
      main_agent.access_mon_trn_ap.connect(predictor.e2e_fifo.analysis_export);
      // pragma uvmx env_connect_predictor begin
      // pragma uvmx env_connect_predictor end
   endfunction

   /**
    * Connects scoreboards components to agents/predictor.
    */
   virtual function void connect_scoreboard();
      predictor.agent_m2s_ap.connect(scoreboard.agent_m2s_scoreboard.exp_export);
      passive_agent.access_mon_trn_ap.connect(scoreboard.agent_m2s_scoreboard.act_export);
      predictor.e2e_ap.connect(scoreboard.e2e_scoreboard.exp_export);
      sec_agent.access_mon_trn_ap.connect(scoreboard.e2e_scoreboard.act_export);
      // pragma uvmx env_connect_scoreboard begin
      // pragma uvmx env_connect_scoreboard end
   endfunction

   /**
    * Connects environment coverage model to agent/predictor.
    */
   virtual function void connect_coverage_model();
      main_agent.seq_item_ap.connect(cov_model.access_seq_item_fifo.analysis_export);
      passive_agent.access_mon_trn_ap.connect(cov_model.access_mon_trn_fifo.analysis_export);
      // pragma uvmx env_connect_coverage_model begin
      // pragma uvmx env_connect_coverage_model end
   endfunction

   /**
    * Assembles sequencer from agent sequencers.
    */
   virtual function void assemble_sequencer();
      sequencer.main_sequencer = main_agent.sequencer;
      sequencer.sec_sequencer = sec_agent.sequencer;
      sequencer.passive_sequencer = passive_agent.sequencer;
      // pragma uvmx env_start_sequences begin
      // pragma uvmx env_start_sequences end
   endfunction

   /**
    * Connects register model to register adapter and predictor.
    */
   virtual function void connect_reg_block();
      cntxt.reg_model.default_map.set_sequencer(main_agent.sequencer, reg_adapter);
   endfunction

   /**
    * Connects register predictor to adapter.
    */
   virtual function void connect_reg_predictor();
      reg_predictor.map     = cntxt.reg_model.default_map;
      reg_predictor.adapter = reg_adapter;
      main_agent.access_mon_trn_ap.connect(reg_predictor.bus_in);
   endfunction
   // pragma uvmx env_methods begin
   // pragma uvmx env_methods end

endclass


`endif // __UVME_MPB_ST_ENV_SV__
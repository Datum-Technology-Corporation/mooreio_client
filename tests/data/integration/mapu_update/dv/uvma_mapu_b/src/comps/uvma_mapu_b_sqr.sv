// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_SQR_SV__
`define __UVMA_MAPU_B_SQR_SV__


/**
 * Data Plane Input Sequencer.
 * @ingroup uvma_mapu_b_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mapu_b_cfg_c  ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c),
   .T_SEQ_ITEM(uvma_mapu_b_dpi_seq_item_c)
) uvma_mapu_b_dpi_sqr_c;

/**
 * Data Plane Output Sequencer.
 * @ingroup uvma_mapu_b_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mapu_b_cfg_c  ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c),
   .T_SEQ_ITEM(uvma_mapu_b_dpo_seq_item_c)
) uvma_mapu_b_dpo_sqr_c;

/**
 * Control Plane Sequencer.
 * @ingroup uvma_mapu_b_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mapu_b_cfg_c  ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c),
   .T_SEQ_ITEM(uvma_mapu_b_cp_seq_item_c)
) uvma_mapu_b_cp_sqr_c;


/**
 * Sequencer running Matrix APU Agent Sequences extending uvma_mapu_b_base_seq_c.
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_sqr_c extends uvmx_block_agent_sqr_c #(
   .T_CFG     (uvma_mapu_b_cfg_c  ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c),
   .T_SEQ_ITEM(uvma_mapu_b_op_seq_item_c)
);

   /// @name Components
   /// @{
   uvma_mapu_b_dpi_sqr_c  dpi_sequencer; ///< Data Plane Input Sequencer connected to uvma_mapu_b_dpi_drv_c.
   uvma_mapu_b_dpo_sqr_c  dpo_sequencer; ///< Data Plane Output Sequencer connected to uvma_mapu_b_dpo_drv_c.
   uvma_mapu_b_cp_sqr_c  cp_sequencer; ///< Control Plane Sequencer connected to uvma_mapu_b_cp_drv_c.
   /// @}

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mapu_b_ig_mon_trn_c)  ig_mon_trn_fifo; ///< Output for  }} Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_eg_mon_trn_c)  eg_mon_trn_fifo; ///< Output for  }} Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpi_mon_trn_c)  dpi_mon_trn_fifo ; ///< Input for Monitor Transactions from uvma_mapu_b_dpi_mon_c.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpo_mon_trn_c)  dpo_mon_trn_fifo ; ///< Input for Monitor Transactions from uvma_mapu_b_dpo_mon_c.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_cp_mon_trn_c)  cp_mon_trn_fifo ; ///< Input for Monitor Transactions from uvma_mapu_b_cp_mon_c.
   /// @}

   // pragma uvmx sqr_fields begin
   // pragma uvmx sqr_fields end


   `uvm_component_utils_begin(uvma_mapu_b_sqr_c)
      // pragma uvmx sqr_uvm_field_macros begin
      // pragma uvmx sqr_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_sqr", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates Sequencer components.
    */
   virtual function void create_sequencers();
      dpi_sequencer = uvma_mapu_b_dpi_sqr_c::type_id::create("dpi_sequencer", this);
      dpo_sequencer = uvma_mapu_b_dpo_sqr_c::type_id::create("dpo_sequencer", this);
      cp_sequencer = uvma_mapu_b_cp_sqr_c::type_id::create("cp_sequencer", this);
      // pragma uvmx sqr_create_sequencers begin
      // pragma uvmx sqr_create_sequencers end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      ig_mon_trn_fifo = new("ig_mon_trn_fifo", this);
      eg_mon_trn_fifo = new("eg_mon_trn_fifo", this);
      dpi_mon_trn_fifo = new("dpi_mon_trn_fifo", this);
      dpo_mon_trn_fifo = new("dpo_mon_trn_fifo", this);
      cp_mon_trn_fifo = new("cp_mon_trn_fifo", this);
      // pragma uvmx sqr_create_fifos begin
      // pragma uvmx sqr_create_fifos end
   endfunction

   // pragma uvmx sqr_methods begin
   // pragma uvmx sqr_methods end

endclass


`endif // __UVMA_MAPU_B_SQR_SV__
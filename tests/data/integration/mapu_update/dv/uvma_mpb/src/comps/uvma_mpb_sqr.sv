// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_SQR_SV__
`define __UVMA_MPB_SQR_SV__


/**
 * MAIN Parallel Sequencer.
 * @ingroup uvma_mpb_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mpb_cfg_c  ),
   .T_CNTXT   (uvma_mpb_cntxt_c),
   .T_SEQ_ITEM(uvma_mpb_main_p_seq_item_c)
) uvma_mpb_main_p_sqr_c;

/**
 * SEC Parallel Sequencer.
 * @ingroup uvma_mpb_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mpb_cfg_c  ),
   .T_CNTXT   (uvma_mpb_cntxt_c),
   .T_SEQ_ITEM(uvma_mpb_sec_p_seq_item_c)
) uvma_mpb_sec_p_sqr_c;


/**
 * Sequencer running Matrix Peripheral Bus Agent Sequences extending uvma_mpb_base_seq_c.
 * @ingroup uvma_mpb_comps
 */
class uvma_mpb_sqr_c extends uvmx_agent_sqr_c #(
   .T_CFG     (uvma_mpb_cfg_c  ),
   .T_CNTXT   (uvma_mpb_cntxt_c),
   .T_SEQ_ITEM(uvma_mpb_access_seq_item_c)
);

   /// @name Components
   /// @{
   uvma_mpb_main_p_sqr_c  main_p_sequencer; ///< MAIN Parallel Sequencer connected to uvma_mpb_main_p_drv_c.
   uvma_mpb_sec_p_sqr_c  sec_p_sequencer; ///< SEC Parallel Sequencer connected to uvma_mpb_sec_p_drv_c.
   /// @}

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mpb_access_mon_trn_c)  access_mon_trn_fifo; ///< Output for  }} Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mpb_p_mon_trn_c)  p_mon_trn_fifo ; ///< Input for Monitor Transactions from uvma_mpb_p_mon_c.
   /// @}

   // pragma uvmx sqr_fields begin
   // pragma uvmx sqr_fields end


   `uvm_component_utils_begin(uvma_mpb_sqr_c)
      // pragma uvmx sqr_uvm_field_macros begin
      // pragma uvmx sqr_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_sqr", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates Sequencer components.
    */
   virtual function void create_sequencers();
      main_p_sequencer = uvma_mpb_main_p_sqr_c::type_id::create("main_p_sequencer", this);
      sec_p_sequencer = uvma_mpb_sec_p_sqr_c::type_id::create("sec_p_sequencer", this);
      // pragma uvmx sqr_create_sequencers begin
      // pragma uvmx sqr_create_sequencers end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      access_mon_trn_fifo = new("access_mon_trn_fifo", this);
      p_mon_trn_fifo = new("p_mon_trn_fifo", this);
      // pragma uvmx sqr_create_fifos begin
      // pragma uvmx sqr_create_fifos end
   endfunction

   // pragma uvmx sqr_methods begin
   // pragma uvmx sqr_methods end

endclass


`endif // __UVMA_MPB_SQR_SV__
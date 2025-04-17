// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_SQR_SV__
`define __UVMA_MSTREAM_SQR_SV__


/**
 * HOST Ingress Sequencer.
 * @ingroup uvma_mstream_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mstream_cfg_c  ),
   .T_CNTXT   (uvma_mstream_cntxt_c),
   .T_SEQ_ITEM(uvma_mstream_host_ig_seq_item_c)
) uvma_mstream_host_ig_sqr_c;

/**
 * CARD Ingress Sequencer.
 * @ingroup uvma_mstream_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mstream_cfg_c  ),
   .T_CNTXT   (uvma_mstream_cntxt_c),
   .T_SEQ_ITEM(uvma_mstream_card_ig_seq_item_c)
) uvma_mstream_card_ig_sqr_c;

/**
 * HOST Egress Sequencer.
 * @ingroup uvma_mstream_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mstream_cfg_c  ),
   .T_CNTXT   (uvma_mstream_cntxt_c),
   .T_SEQ_ITEM(uvma_mstream_host_eg_seq_item_c)
) uvma_mstream_host_eg_sqr_c;

/**
 * CARD Egress Sequencer.
 * @ingroup uvma_mstream_comps
 */
typedef uvmx_sqr_c #(
   .T_CFG     (uvma_mstream_cfg_c  ),
   .T_CNTXT   (uvma_mstream_cntxt_c),
   .T_SEQ_ITEM(uvma_mstream_card_eg_seq_item_c)
) uvma_mstream_card_eg_sqr_c;


/**
 * Sequencer running Matrix Stream Interface Agent Sequences extending uvma_mstream_base_seq_c.
 * @ingroup uvma_mstream_comps
 */
class uvma_mstream_sqr_c extends uvmx_agent_sqr_c #(
   .T_CFG     (uvma_mstream_cfg_c  ),
   .T_CNTXT   (uvma_mstream_cntxt_c),
   .T_SEQ_ITEM(uvma_mstream_pkt_seq_item_c)
);

   /// @name Components
   /// @{
   uvma_mstream_host_ig_sqr_c  host_ig_sequencer; ///< HOST Ingress Sequencer connected to uvma_mstream_host_ig_drv_c.
   uvma_mstream_card_ig_sqr_c  card_ig_sequencer; ///< CARD Ingress Sequencer connected to uvma_mstream_card_ig_drv_c.
   uvma_mstream_host_eg_sqr_c  host_eg_sequencer; ///< HOST Egress Sequencer connected to uvma_mstream_host_eg_drv_c.
   uvma_mstream_card_eg_sqr_c  card_eg_sequencer; ///< CARD Egress Sequencer connected to uvma_mstream_card_eg_drv_c.
   /// @}

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_mon_trn_c)  ig_pkt_mon_trn_fifo; ///< Output for  }} Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_mon_trn_c)  eg_pkt_mon_trn_fifo; ///< Output for  }} Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mstream_ig_mon_trn_c)  ig_mon_trn_fifo ; ///< Input for Monitor Transactions from uvma_mstream_ig_mon_c.
   uvm_tlm_analysis_fifo #(uvma_mstream_eg_mon_trn_c)  eg_mon_trn_fifo ; ///< Input for Monitor Transactions from uvma_mstream_eg_mon_c.
   /// @}

   // pragma uvmx sqr_fields begin
   // pragma uvmx sqr_fields end


   `uvm_component_utils_begin(uvma_mstream_sqr_c)
      // pragma uvmx sqr_uvm_field_macros begin
      // pragma uvmx sqr_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_sqr", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates Sequencer components.
    */
   virtual function void create_sequencers();
      host_ig_sequencer = uvma_mstream_host_ig_sqr_c::type_id::create("host_ig_sequencer", this);
      card_ig_sequencer = uvma_mstream_card_ig_sqr_c::type_id::create("card_ig_sequencer", this);
      host_eg_sequencer = uvma_mstream_host_eg_sqr_c::type_id::create("host_eg_sequencer", this);
      card_eg_sequencer = uvma_mstream_card_eg_sqr_c::type_id::create("card_eg_sequencer", this);
      // pragma uvmx sqr_create_sequencers begin
      // pragma uvmx sqr_create_sequencers end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      ig_pkt_mon_trn_fifo = new("ig_pkt_mon_trn_fifo", this);
      eg_pkt_mon_trn_fifo = new("eg_pkt_mon_trn_fifo", this);
      ig_mon_trn_fifo = new("ig_mon_trn_fifo", this);
      eg_mon_trn_fifo = new("eg_mon_trn_fifo", this);
      // pragma uvmx sqr_create_fifos begin
      // pragma uvmx sqr_create_fifos end
   endfunction

   // pragma uvmx sqr_methods begin
   // pragma uvmx sqr_methods end

endclass


`endif // __UVMA_MSTREAM_SQR_SV__
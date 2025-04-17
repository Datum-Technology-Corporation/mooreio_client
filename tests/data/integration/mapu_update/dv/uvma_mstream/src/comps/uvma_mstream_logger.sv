// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_LOGGER_SV__
`define __UVMA_MSTREAM_LOGGER_SV__


/**
 * Component logging to disk metadata from the transactions generated and monitored by uvma_mstream_agent_c.
 * @ingroup uvma_mstream_comps
 */
class uvma_mstream_logger_c extends uvmx_agent_logger_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Loggers
   /// @{
   uvmx_tlm_logger_c #(uvma_mstream_pkt_seq_item_c)  seq_item_logger; ///< Output port for 'Packet' Sequence Items
   uvmx_tlm_logger_c #(uvma_mstream_pkt_mon_trn_c)  ig_pkt_mon_trn_logger; ///< Logger for Ingress Packet Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mstream_pkt_mon_trn_c)  eg_pkt_mon_trn_logger; ///< Logger for Egress Packet Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mstream_host_ig_seq_item_c)  host_ig_seq_item_logger; ///< Logger for HOST Ingress Sequence Items.
   uvmx_tlm_logger_c #(uvma_mstream_card_ig_seq_item_c)  card_ig_seq_item_logger; ///< Logger for CARD Ingress Sequence Items.
   uvmx_tlm_logger_c #(uvma_mstream_host_eg_seq_item_c)  host_eg_seq_item_logger; ///< Logger for HOST Egress Sequence Items.
   uvmx_tlm_logger_c #(uvma_mstream_card_eg_seq_item_c)  card_eg_seq_item_logger; ///< Logger for CARD Egress Sequence Items.
   uvmx_tlm_logger_c #(uvma_mstream_ig_mon_trn_c)  ig_mon_trn_logger; ///< Logger for Ingress Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mstream_eg_mon_trn_c)  eg_mon_trn_logger; ///< Logger for Egress Monitor Transactions.
   /// @}

   // pragma uvmx logger_fields begin
   // pragma uvmx logger_fields end


   `uvm_component_utils_begin(uvma_mstream_logger_c)
      // pragma uvmx logger_uvm_field_macros begin
      // pragma uvmx logger_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_logger", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates logger components.
    */
   virtual function void create_loggers();
   seq_item_logger = uvmx_tlm_logger_c #(uvma_mstream_pkt_seq_item_c)::type_id::create("seq_item_logger", this);
      ig_pkt_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mstream_pkt_mon_trn_c)::type_id::create("ig_pkt_mon_trn_logger", this);
      eg_pkt_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mstream_pkt_mon_trn_c)::type_id::create("eg_pkt_mon_trn_logger", this);
      host_ig_seq_item_logger = uvmx_tlm_logger_c #(uvma_mstream_host_ig_seq_item_c)::type_id::create("host_ig_seq_item_logger", this);
      card_ig_seq_item_logger = uvmx_tlm_logger_c #(uvma_mstream_card_ig_seq_item_c)::type_id::create("card_ig_seq_item_logger", this);
      host_eg_seq_item_logger = uvmx_tlm_logger_c #(uvma_mstream_host_eg_seq_item_c)::type_id::create("host_eg_seq_item_logger", this);
      card_eg_seq_item_logger = uvmx_tlm_logger_c #(uvma_mstream_card_eg_seq_item_c)::type_id::create("card_eg_seq_item_logger", this);
      ig_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mstream_ig_mon_trn_c)::type_id::create("ig_mon_trn_logger", this);
      eg_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mstream_eg_mon_trn_c)::type_id::create("eg_mon_trn_logger", this);
      // pragma uvmx logger_create_loggers begin
      // pragma uvmx logger_create_loggers end
   endfunction

   /**
    * Sets filenames for logger components.
    */
   virtual function void configure_loggers();
   seq_item_logger.set_filename("seq_item");
      ig_pkt_mon_trn_logger.set_filename("ig_pkt_mon_trn");
      eg_pkt_mon_trn_logger.set_filename("eg_pkt_mon_trn");
      host_ig_seq_item_logger.set_filename("host_ig_seq_item");
      card_ig_seq_item_logger.set_filename("card_ig_seq_item");
      host_eg_seq_item_logger.set_filename("host_eg_seq_item");
      card_eg_seq_item_logger.set_filename("card_eg_seq_item");
      ig_mon_trn_logger.set_filename("ig_mon_trn");
      eg_mon_trn_logger.set_filename("eg_mon_trn");
      // pragma uvmx logger_configure_loggers begin
      // pragma uvmx logger_configure_loggers end
   endfunction

   // pragma uvmx logger_mon_methods begin
   // pragma uvmx logger_mon_methods end

endclass


`endif // __UVMA_MSTREAM_LOGGER_SV__
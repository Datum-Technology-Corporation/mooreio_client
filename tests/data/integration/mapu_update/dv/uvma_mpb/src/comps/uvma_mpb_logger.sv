// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_LOGGER_SV__
`define __UVMA_MPB_LOGGER_SV__


/**
 * Component logging to disk metadata from the transactions generated and monitored by uvma_mpb_agent_c.
 * @ingroup uvma_mpb_comps
 */
class uvma_mpb_logger_c extends uvmx_agent_logger_c #(
   .T_CFG  (uvma_mpb_cfg_c  ),
   .T_CNTXT(uvma_mpb_cntxt_c)
);

   /// @name Loggers
   /// @{
   uvmx_tlm_logger_c #(uvma_mpb_access_seq_item_c)  seq_item_logger; ///< Output port for 'Access' Sequence Items
   uvmx_tlm_logger_c #(uvma_mpb_access_mon_trn_c)  access_mon_trn_logger; ///< Logger for Access Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mpb_main_p_seq_item_c)  main_p_seq_item_logger; ///< Logger for MAIN Parallel Sequence Items.
   uvmx_tlm_logger_c #(uvma_mpb_sec_p_seq_item_c)  sec_p_seq_item_logger; ///< Logger for SEC Parallel Sequence Items.
   uvmx_tlm_logger_c #(uvma_mpb_p_mon_trn_c)  p_mon_trn_logger; ///< Logger for Parallel Monitor Transactions.
   /// @}

   // pragma uvmx logger_fields begin
   // pragma uvmx logger_fields end


   `uvm_component_utils_begin(uvma_mpb_logger_c)
      // pragma uvmx logger_uvm_field_macros begin
      // pragma uvmx logger_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_logger", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates logger components.
    */
   virtual function void create_loggers();
   seq_item_logger = uvmx_tlm_logger_c #(uvma_mpb_access_seq_item_c)::type_id::create("seq_item_logger", this);
      access_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mpb_access_mon_trn_c)::type_id::create("access_mon_trn_logger", this);
      main_p_seq_item_logger = uvmx_tlm_logger_c #(uvma_mpb_main_p_seq_item_c)::type_id::create("main_p_seq_item_logger", this);
      sec_p_seq_item_logger = uvmx_tlm_logger_c #(uvma_mpb_sec_p_seq_item_c)::type_id::create("sec_p_seq_item_logger", this);
      p_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mpb_p_mon_trn_c)::type_id::create("p_mon_trn_logger", this);
      // pragma uvmx logger_create_loggers begin
      // pragma uvmx logger_create_loggers end
   endfunction

   /**
    * Sets filenames for logger components.
    */
   virtual function void configure_loggers();
   seq_item_logger.set_filename("seq_item");
      access_mon_trn_logger.set_filename("access_mon_trn");
      main_p_seq_item_logger.set_filename("main_p_seq_item");
      sec_p_seq_item_logger.set_filename("sec_p_seq_item");
      p_mon_trn_logger.set_filename("p_mon_trn");
      // pragma uvmx logger_configure_loggers begin
      // pragma uvmx logger_configure_loggers end
   endfunction

   // pragma uvmx logger_mon_methods begin
   // pragma uvmx logger_mon_methods end

endclass


`endif // __UVMA_MPB_LOGGER_SV__
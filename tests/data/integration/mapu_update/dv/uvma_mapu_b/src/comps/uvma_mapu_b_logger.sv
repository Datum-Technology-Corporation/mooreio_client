// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_LOGGER_SV__
`define __UVMA_MAPU_B_LOGGER_SV__


/**
 * Component logging to disk metadata from the transactions generated and monitored by uvma_mapu_b_agent_c.
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_logger_c extends uvmx_block_sb_agent_logger_c #(
   .T_CFG     (uvma_mapu_b_cfg_c     ),
   .T_CNTXT   (uvma_mapu_b_cntxt_c   ),
   .T_SEQ_ITEM(uvma_mapu_b_seq_item_c)
);

   /// @name Loggers
   /// @{
   uvmx_tlm_logger_c #(uvma_mapu_b_mon_trn_c)  in_mon_trn_logger; ///< Logger for Input Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mapu_b_mon_trn_c)  out_mon_trn_logger; ///< Logger for Output Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mapu_b_dpi_seq_item_c)  dpi_seq_item_logger; ///< Logger for Data Plane Input Sequence Items.
   uvmx_tlm_logger_c #(uvma_mapu_b_dpo_seq_item_c)  dpo_seq_item_logger; ///< Logger for Data Plane Output Sequence Items.
   uvmx_tlm_logger_c #(uvma_mapu_b_cp_seq_item_c)  cp_seq_item_logger; ///< Logger for Control Plane Sequence Items.
   uvmx_tlm_logger_c #(uvma_mapu_b_dpi_mon_trn_c)  dpi_mon_trn_logger; ///< Logger for Data Plane Input Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mapu_b_dpo_mon_trn_c)  dpo_mon_trn_logger; ///< Logger for Data Plane Output Monitor Transactions.
   uvmx_tlm_logger_c #(uvma_mapu_b_cp_mon_trn_c)  cp_mon_trn_logger; ///< Logger for Control Plane Monitor Transactions.
   /// @}

   // pragma uvmx logger_fields begin
   // pragma uvmx logger_fields end


   `uvm_component_utils_begin(uvma_mapu_b_logger_c)
      // pragma uvmx logger_uvm_field_macros begin
      // pragma uvmx logger_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_logger", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx logger_constructor begin
      // pragma uvmx logger_constructor end
   endfunction

   /**
    * Creates logger components.
    */
   virtual function void create_loggers();
      in_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mapu_b_mon_trn_c)::type_id::create("in_mon_trn_logger", this);
      out_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mapu_b_mon_trn_c)::type_id::create("out_mon_trn_logger", this);
      dpi_seq_item_logger = uvmx_tlm_logger_c #(uvma_mapu_b_dpi_seq_item_c)::type_id::create("dpi_seq_item_logger", this);
      dpo_seq_item_logger = uvmx_tlm_logger_c #(uvma_mapu_b_dpo_seq_item_c)::type_id::create("dpo_seq_item_logger", this);
      cp_seq_item_logger = uvmx_tlm_logger_c #(uvma_mapu_b_cp_seq_item_c)::type_id::create("cp_seq_item_logger", this);
      dpi_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mapu_b_dpi_mon_trn_c)::type_id::create("dpi_mon_trn_logger", this);
      dpo_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mapu_b_dpo_mon_trn_c)::type_id::create("dpo_mon_trn_logger", this);
      cp_mon_trn_logger = uvmx_tlm_logger_c #(uvma_mapu_b_cp_mon_trn_c)::type_id::create("cp_mon_trn_logger", this);

      // pragma uvmx logger_create_loggers begin
      // pragma uvmx logger_create_loggers end
   endfunction

   /**
    * Sets filenames for logger components.
    */
   virtual function void configure_loggers();
      in_mon_trn_logger.set_filename("in_mon_trn");
      out_mon_trn_logger.set_filename("out_mon_trn");
      dpi_seq_item_logger.set_filename("dpi_seq_item");
      dpo_seq_item_logger.set_filename("dpo_seq_item");
      cp_seq_item_logger.set_filename("cp_seq_item");
      dpi_mon_trn_logger.set_filename("dpi_mon_trn");
      dpo_mon_trn_logger.set_filename("dpo_mon_trn");
      cp_mon_trn_logger.set_filename("cp_mon_trn");

      // pragma uvmx logger_configure_loggers begin
      // pragma uvmx logger_configure_loggers end
   endfunction

   // pragma uvmx logger_mon_methods begin
   // pragma uvmx logger_mon_methods end

endclass


`endif // __UVMA_MAPU_B_LOGGER_SV__
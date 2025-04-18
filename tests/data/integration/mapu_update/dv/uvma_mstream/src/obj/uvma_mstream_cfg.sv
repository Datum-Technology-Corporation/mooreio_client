// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_CFG_SV__
`define __UVMA_MSTREAM_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running all Matrix Stream Interface Agent (uvma_mstream_agent_c) components.
 * @ingroup uvma_mstream_obj
 */
class uvma_mstream_cfg_c extends uvmx_agent_cfg_c;

   /// @name Settings
   /// @{
   rand uvma_mstream_drv_mode_enum  drv_mode; ///< Specifies direction to drive when in active mode.
   rand int unsigned rx_drv_ton_pct; ///< Rx driver TON percentage: Percentage of rdy clock cycles.
   /// @}

   /// @name Bus Widths
   /// @{
   rand int unsigned  data_width; ///< Data Width
   /// @}

   // pragma uvmx cfg_fields begin
   // pragma uvmx cfg_fields end


   `uvm_object_utils_begin(uvma_mstream_cfg_c)
      // pragma uvmx cfg_uvm_field_macros begin
      `uvm_field_int(enabled, UVM_DEFAULT)
      `uvm_field_int(bypass_mode, UVM_DEFAULT)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
      `uvm_field_enum(uvma_mstream_drv_mode_enum, drv_mode, UVM_DEFAULT)
      `uvm_field_enum(uvmx_reset_type_enum, reset_type, UVM_DEFAULT)
      `uvm_field_enum(uvm_sequencer_arb_mode, sqr_arb_mode, UVM_DEFAULT)
      `uvm_field_int(data_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(rx_drv_ton_pct, UVM_DEFAULT + UVM_DEC)
      // pragma uvmx cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Describes fields randomization space.
    */
   constraint settings_space_cons {
       rx_drv_ton_pct inside {[1:100]};
   }

   /**
    * Rules for parameters.
    */
   constraint parameter_space_cons {
      data_width inside {[`UVMA_MSTREAM_DATA_WIDTH_MIN:`UVMA_MSTREAM_DATA_WIDTH_MAX]};
   }

   // pragma uvmx cfg_constraints begin
   /**
    * Restricts settings randomization space.
    */
   constraint rules_cons {
      soft rx_drv_ton_pct inside {[50:100]};
   }
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_cfg");
      super.new(name);
   endfunction

   // pragma uvmx cfg_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx cfg_seq_build_dox end
   virtual function void build();
      // pragma uvmx cfg_build begin
      // pragma uvmx cfg_build end
   endfunction

   // pragma uvmx cfg_post_randomize_work begin
   /**
    * TODO Implement or remove uvma_mstream_cfg_c::post_randomize()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx cfg_post_randomize_work end

   // pragma uvmx cfg_methods begin
   // pragma uvmx cfg_methods end

endclass


`endif // __UVMA_MSTREAM_CFG_SV__
// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_CFG_SV__
`define __UVMA_MAPU_B_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running all Matrix APU Agent (uvma_mapu_b_agent_c) components.
 * @ingroup uvma_mapu_b_obj
 */
class uvma_mapu_b_cfg_c extends uvmx_block_sb_agent_cfg_c;

   /// @name Bus Widths
   /// @{
   rand int unsigned  data_width; ///< Data Width
   /// @}

   /// @name Virtual Sequence Types
   /// @{
   uvm_object_wrapper  idle_drv_seq_type;
   uvm_object_wrapper  in_drv_seq_type ; ///< Sequence Type driving data into the DUT.
   uvm_object_wrapper  out_drv_seq_type; ///< Sequence Type driving data out of the DUT.
   /// @}

   // pragma uvmx cfg_fields begin
   // pragma uvmx cfg_fields end


   `uvm_object_utils_begin(uvma_mapu_b_cfg_c)
      // pragma uvmx cfg_uvm_field_macros begin
      `uvm_field_int(enabled, UVM_DEFAULT)
      `uvm_field_int(bypass_mode, UVM_DEFAULT)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
      `uvm_field_enum(uvmx_reset_type_enum, reset_type, UVM_DEFAULT)
      `uvm_field_int(drv_idle_random, UVM_DEFAULT)
      `uvm_field_enum(uvm_sequencer_arb_mode, sqr_arb_mode, UVM_DEFAULT)
      `uvm_field_int(data_width, UVM_DEFAULT + UVM_DEC)
      // pragma uvmx cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Rules for parameters.
    */
   constraint parameter_space_cons {
      data_width inside {[`UVMA_MAPU_B_DATA_WIDTH_MIN:`UVMA_MAPU_B_DATA_WIDTH_MAX]};
   }

   /**
    * Restricts settings randomization space.
    */
   constraint rules_cons {
      soft drv_idle_random == 0;
   }

   // pragma uvmx cfg_constraints begin
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_cfg");
      super.new(name);
      // pragma uvmx cfg_constructor begin
      // pragma uvmx cfg_constructor end
   endfunction

   /**
    * Specifies agent sequence types for driving and monitoring.
    */
   virtual function void set_seq_types();
      idle_drv_seq_type = uvma_mapu_b_idle_drv_seq_c::get_type();
      mon_seq_type = uvma_mapu_b_mon_seq_c::get_type();
      in_drv_seq_type = uvma_mapu_b_in_drv_seq_c::get_type();
      out_drv_seq_type = uvma_mapu_b_out_drv_seq_c::get_type();
      // pragma uvmx cfg_set_seq_types begin
      // pragma uvmx cfg_set_seq_types end
   endfunction

   // pragma uvmx cfg_post_randomize_work begin
   /**
    * TODO Implement or remove uvma_mapu_b_cfg_c::post_randomize()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx cfg_post_randomize_work end

   // pragma uvmx cfg_methods begin
   // pragma uvmx cfg_methods end

endclass


`endif // __UVMA_MAPU_B_CFG_SV__
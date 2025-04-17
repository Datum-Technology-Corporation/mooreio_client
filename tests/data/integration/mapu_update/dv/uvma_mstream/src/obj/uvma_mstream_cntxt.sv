// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_CNTXT_SV__
`define __UVMA_MSTREAM_CNTXT_SV__


/**
 * Object encapsulating all state variables for all Matrix Stream Interface Agent (uvma_mstream_agent_c) components.
 * @ingroup uvma_mstream_obj
 */
class uvma_mstream_cntxt_c extends uvmx_agent_cntxt_c #(
   .T_CFG(uvma_mstream_cfg_c     ),
   .T_VIF(virtual uvma_mstream_if)
);

   // pragma uvmx cntxt_fields begin
   // pragma uvmx cntxt_fields end


   `uvm_object_utils_begin(uvma_mstream_cntxt_c)
      // pragma uvmx cntxt_uvm_field_macros begin
      `uvm_field_enum(uvmx_reset_state_enum, reset_state, UVM_DEFAULT)
      // pragma uvmx cntxt_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_cntxt");
      super.new(name);
   endfunction

   /**
    * Sets all state variables to initial values.
    */
   virtual function void do_reset(uvma_mstream_cfg_c cfg);
      // pragma uvmx cntxt_do_reset begin
      // pragma uvmx cntxt_do_reset end
   endfunction

   // pragma uvmx cntxt_methods begin
   // pragma uvmx cntxt_methods end

endclass


`endif // __UVMA_MSTREAM_CNTXT_SV__
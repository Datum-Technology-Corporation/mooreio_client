// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_CNTXT_SV__
`define __UVMA_MPB_CNTXT_SV__


/**
 * Object encapsulating all state variables for all Matrix Peripheral Bus Agent (uvma_mpb_agent_c) components.
 * @ingroup uvma_mpb_obj
 */
class uvma_mpb_cntxt_c extends uvmx_agent_cntxt_c #(
   .T_CFG(uvma_mpb_cfg_c     ),
   .T_VIF(virtual uvma_mpb_if)
);

   // pragma uvmx cntxt_fields begin
   uvma_mpb_rsp_base_seq_c  rsp_handlers[$];
   // pragma uvmx cntxt_fields end


   `uvm_object_utils_begin(uvma_mpb_cntxt_c)
      // pragma uvmx cntxt_uvm_field_macros begin
      `uvm_field_enum(uvmx_reset_state_enum, reset_state, UVM_DEFAULT)
      // pragma uvmx cntxt_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_cntxt");
      super.new(name);
   endfunction

   // pragma uvmx cntxt_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx cntxt_seq_build_dox end
   virtual function void build(uvma_mpb_cfg_c cfg);
      // pragma uvmx cntxt_build begin
      // pragma uvmx cntxt_build end
   endfunction

   /**
    * Sets all state variables to initial values.
    */
   virtual function void do_reset(uvma_mpb_cfg_c cfg);
      // pragma uvmx cntxt_do_reset begin
      // pragma uvmx cntxt_do_reset end
   endfunction

   // pragma uvmx cntxt_methods begin
   // pragma uvmx cntxt_methods end

endclass


`endif // __UVMA_MPB_CNTXT_SV__
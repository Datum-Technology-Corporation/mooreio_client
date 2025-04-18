// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_MON_SV__
`define __UVMA_MPB_MON_SV__


/**
 * Component sampling Monitor Transactions from Matrix Peripheral Bus Interface (uvma_mpb_if).
 * @ingroup uvma_mpb_comps
 */
class uvma_mpb_mon_c extends uvmx_mon_c #(
   .T_CFG  (uvma_mpb_cfg_c  ),
   .T_CNTXT(uvma_mpb_cntxt_c)
);

   /// @name Components
   /// @{
   uvma_mpb_p_mon_c  p_monitor; ///< Parallel Monitor.
   /// @}

   // pragma uvmx mon_fields begin
   // pragma uvmx mon_fields end


   `uvm_component_utils_begin(uvma_mpb_mon_c)
      // pragma uvmx mon_uvm_field_macros begin
      // pragma uvmx mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mon_reset(reset_n)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_mon", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates sub-monitor components.
    */
   virtual function void create_monitors();
       p_monitor = uvma_mpb_p_mon_c::type_id::create("p_monitor", this);
      // pragma uvmx mon_create_monitors begin
      // pragma uvmx mon_create_monitors end
   endfunction

   // pragma uvmx mon_methods begin
   // pragma uvmx mon_methods end

endclass


`endif // __UVMA_MPB_MON_SV__
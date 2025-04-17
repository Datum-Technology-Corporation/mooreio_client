// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_MON_SV__
`define __UVMA_MSTREAM_MON_SV__


/**
 * Component sampling Monitor Transactions from Matrix Stream Interface Interface (uvma_mstream_if).
 * @ingroup uvma_mstream_comps
 */
class uvma_mstream_mon_c extends uvmx_mon_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Components
   /// @{
   uvma_mstream_ig_mon_c  ig_monitor; ///< Ingress Monitor.
   uvma_mstream_eg_mon_c  eg_monitor; ///< Egress Monitor.
   /// @}

   // pragma uvmx mon_fields begin
   // pragma uvmx mon_fields end


   `uvm_component_utils_begin(uvma_mstream_mon_c)
      // pragma uvmx mon_uvm_field_macros begin
      // pragma uvmx mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mon_reset(reset_n)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_mon", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates sub-monitor components.
    */
   virtual function void create_monitors();
       ig_monitor = uvma_mstream_ig_mon_c::type_id::create("ig_monitor", this);
       eg_monitor = uvma_mstream_eg_mon_c::type_id::create("eg_monitor", this);
      // pragma uvmx mon_create_monitors begin
      // pragma uvmx mon_create_monitors end
   endfunction

   // pragma uvmx mon_methods begin
   // pragma uvmx mon_methods end

endclass


`endif // __UVMA_MSTREAM_MON_SV__
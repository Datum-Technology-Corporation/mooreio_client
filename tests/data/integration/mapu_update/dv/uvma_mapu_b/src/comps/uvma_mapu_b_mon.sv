// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_MON_SV__
`define __UVMA_MAPU_B_MON_SV__


/**
 * Component sampling Monitor Transactions from Matrix APU Interface (uvma_mapu_b_if).
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_mon_c extends uvmx_block_sb_mon_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Components
   /// @{
   uvma_mapu_b_dpi_mon_c  dpi_monitor; ///< Data Plane Input Monitor.
   uvma_mapu_b_dpo_mon_c  dpo_monitor; ///< Data Plane Output Monitor.
   uvma_mapu_b_cp_mon_c  cp_monitor; ///< Control Plane Monitor.
   /// @}

   // pragma uvmx mon_fields begin
   // pragma uvmx mon_fields end


   `uvm_component_utils_begin(uvma_mapu_b_mon_c)
      // pragma uvmx mon_uvm_field_macros begin
      // pragma uvmx mon_uvm_field_macros end
   `uvm_component_utils_end
   `uvmx_mon_reset(reset_n)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_mon", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx mon_uvm_field_macros begin
      // pragma uvmx mon_uvm_field_macros end
   endfunction

   /**
    * Creates sub-monitor components.
    */
   virtual function void create_monitors();
       dpi_monitor = uvma_mapu_b_dpi_mon_c::type_id::create("dpi_monitor", this);
       dpo_monitor = uvma_mapu_b_dpo_mon_c::type_id::create("dpo_monitor", this);
       cp_monitor = uvma_mapu_b_cp_mon_c::type_id::create("cp_monitor", this);

      // pragma uvmx mon_create_monitors begin
      // pragma uvmx mon_create_monitors end
   endfunction

   // pragma uvmx mon_methods begin
   // pragma uvmx mon_methods end

endclass


`endif // __UVMA_MAPU_B_MON_SV__
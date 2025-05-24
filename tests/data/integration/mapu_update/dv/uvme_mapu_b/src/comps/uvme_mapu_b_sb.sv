// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_SB_SV__
`define __UVME_MAPU_B_SB_SV__


/**
 * Component encapsulating scoreboarding components for Matrix APU Block.
 * @ingroup uvme_mapu_b_comps
 */
class uvme_mapu_b_sb_c extends uvmx_block_sb_c #(
   .T_CFG  (uvme_mapu_b_cfg_c  ),
   .T_CNTXT(uvme_mapu_b_cntxt_c)
);

   /// @name Components
   /// @{
   uvme_mapu_b_egress_sb_c  egress_scoreboard; ///< Egress: Compares predicted Matrix operations against results from DUT
   /// @}

   // pragma uvmx sb_fields begin
   // pragma uvmx sb_fields end


   `uvm_component_utils_begin(uvme_mapu_b_sb_c)
      // pragma uvmx sb_uvm_field_macros begin
      // pragma uvmx sb_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_sb", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Assigns configuration handles to components using UVM Configuration Database.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "egress_scoreboard", "cfg", cfg.egress_scoreboard_cfg);
      // pragma uvmx sb_assign_cfg begin
      // pragma uvmx sb_assign_cfg end
   endfunction

   /**
    * Assigns context handles to components using UVM Configuration Database.
    */
   virtual function void assign_cntxt();
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "egress_scoreboard", "cntxt", cntxt.egress_scoreboard_cntxt);
      // pragma uvmx sb_assign_cntxt begin
      // pragma uvmx sb_assign_cntxt end
   endfunction

   /**
    * Creates scoreboard components.
    */
   virtual function void create_components();
      egress_scoreboard = uvme_mapu_b_egress_sb_c::type_id::create("egress_scoreboard", this);
      // pragma uvmx sb_create_components begin
      // pragma uvmx sb_create_components end
   endfunction

   // pragma uvmx sb_methods begin
   // pragma uvmx sb_methods end

endclass


`endif // __UVME_MAPU_B_SB_SV__
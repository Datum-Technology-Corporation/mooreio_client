// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_DRV_SV__
`define __UVMA_MAPU_B_DRV_SV__


/**
 * Component driving Matrix APU Interface (uvma_mapu_b_if) for all planes.
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_drv_c extends uvmx_block_drv_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Components
   /// @{
   uvma_mapu_b_dpi_drv_c  dpi_driver; ///< Data Plane Input Driver.
   uvma_mapu_b_dpo_drv_c  dpo_driver; ///< Data Plane Output Driver.
   uvma_mapu_b_cp_drv_c  cp_driver; ///< Control Plane Driver.
   /// @}

   // pragma uvmx drv_fields begin
   // pragma uvmx drv_fields end


   `uvm_component_utils_begin(uvma_mapu_b_drv_c)
      // pragma uvmx drv_uvm_field_macros begin
      // pragma uvmx drv_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates sub-driver components.
    */
   virtual function void create_drivers();
      dpi_driver = uvma_mapu_b_dpi_drv_c::type_id::create("dpi_driver", this);
      dpo_driver = uvma_mapu_b_dpo_drv_c::type_id::create("dpo_driver", this);
      cp_driver = uvma_mapu_b_cp_drv_c::type_id::create("cp_driver", this);

      // pragma uvmx drv_create_drivers begin
      // pragma uvmx drv_create_drivers end
   endfunction

   // pragma uvmx drv_methods begin
   // pragma uvmx drv_methods end

endclass


`endif // __UVMA_MAPU_B_DRV_SV__
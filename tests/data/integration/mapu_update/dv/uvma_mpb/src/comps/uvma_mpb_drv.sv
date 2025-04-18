// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_DRV_SV__
`define __UVMA_MPB_DRV_SV__


/**
 * Component driving Matrix Peripheral Bus Interface (uvma_mpb_if) in either direction.
 * @ingroup uvma_mpb_comps
 */
class uvma_mpb_drv_c extends uvmx_drv_c #(
   .T_CFG  (uvma_mpb_cfg_c  ),
   .T_CNTXT(uvma_mpb_cntxt_c)
);

   /// @name Components
   /// @{
   uvma_mpb_main_p_drv_c  main_p_driver; ///< MAIN Parallel Driver.
   uvma_mpb_sec_p_drv_c  sec_p_driver; ///< SEC Parallel Driver.
   /// @}

   // pragma uvmx drv_fields begin
   // pragma uvmx drv_fields end


   `uvm_component_utils_begin(uvma_mpb_drv_c)
      // pragma uvmx drv_uvm_field_macros begin
      // pragma uvmx drv_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates sub-driver components.
    */
   virtual function void create_drivers();
      main_p_driver = uvma_mpb_main_p_drv_c::type_id::create("main_p_driver", this);
      sec_p_driver = uvma_mpb_sec_p_drv_c::type_id::create("sec_p_driver", this);
      // pragma uvmx drv_create_drivers begin
      // pragma uvmx drv_create_drivers end
   endfunction

   // pragma uvmx drv_methods begin
   // pragma uvmx drv_methods end

endclass


`endif // __UVMA_MPB_DRV_SV__
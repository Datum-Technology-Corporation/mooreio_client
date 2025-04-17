// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_DRV_SV__
`define __UVMA_MSTREAM_DRV_SV__


/**
 * Component driving Matrix Stream Interface Interface (uvma_mstream_if) in either direction.
 * @ingroup uvma_mstream_comps
 */
class uvma_mstream_drv_c extends uvmx_drv_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Components
   /// @{
   uvma_mstream_host_ig_drv_c  host_ig_driver; ///< HOST Ingress Driver.
   uvma_mstream_card_ig_drv_c  card_ig_driver; ///< CARD Ingress Driver.
   uvma_mstream_host_eg_drv_c  host_eg_driver; ///< HOST Egress Driver.
   uvma_mstream_card_eg_drv_c  card_eg_driver; ///< CARD Egress Driver.
   /// @}

   // pragma uvmx drv_fields begin
   // pragma uvmx drv_fields end


   `uvm_component_utils_begin(uvma_mstream_drv_c)
      // pragma uvmx drv_uvm_field_macros begin
      // pragma uvmx drv_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_drv", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates sub-driver components.
    */
   virtual function void create_drivers();
      host_ig_driver = uvma_mstream_host_ig_drv_c::type_id::create("host_ig_driver", this);
      card_ig_driver = uvma_mstream_card_ig_drv_c::type_id::create("card_ig_driver", this);
      host_eg_driver = uvma_mstream_host_eg_drv_c::type_id::create("host_eg_driver", this);
      card_eg_driver = uvma_mstream_card_eg_drv_c::type_id::create("card_eg_driver", this);
      // pragma uvmx drv_create_drivers begin
      // pragma uvmx drv_create_drivers end
   endfunction

   // pragma uvmx drv_methods begin
   // pragma uvmx drv_methods end

endclass


`endif // __UVMA_MSTREAM_DRV_SV__
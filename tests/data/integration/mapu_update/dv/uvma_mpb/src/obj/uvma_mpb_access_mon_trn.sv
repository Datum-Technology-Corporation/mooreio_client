// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_ACCESS_MON_TRN_SV__
`define __UVMA_MPB_ACCESS_MON_TRN_SV__


/**
 * Access: Read/Write register access
 * @ingroup uvma_mpb_obj
 */
class uvma_mpb_access_mon_trn_c extends uvmx_mon_trn_c #(
   .T_CFG  (uvma_mpb_cfg_c  ),
   .T_CNTXT(uvma_mpb_cntxt_c)
);

   /// @name Fields
   /// @{
   uvma_mpb_op_enum  op; ///< Operation: Access type Read/Write
   uvm_reg_addr_t  address; ///< Address: Read/Write Address
   uvm_reg_data_t  data; ///< Data: Read/Write Data
   /// @}

   // pragma uvmx access_mon_trn_fields begin
   // pragma uvmx access_mon_trn_fields end


   `uvm_object_utils_begin(uvma_mpb_access_mon_trn_c)
      // pragma uvmx access_mon_trn_uvm_field_macros begin
      `uvm_field_enum(uvma_mpb_op_enum, op, UVM_DEFAULT)
      `uvm_field_int(address, UVM_DEFAULT)
      `uvm_field_int(data, UVM_DEFAULT)
      // pragma uvmx access_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_access_mon_trn");
      super.new(name);
   endfunction

   // pragma uvmx access_mon_trn_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx access_mon_trn_build_dox end
   virtual function void build();
      // pragma uvmx access_mon_trn_build begin
      // pragma uvmx access_mon_trn_build end
   endfunction

   // pragma uvmx access_mon_trn_do_compare begin
   /**
    * TODO Implement or remove uvma_mpb_access_mon_trn_c::do_compare()
    */
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      uvma_mpb_access_mon_trn_c  trn;
      do_compare = super.do_compare(rhs, comparer);
      if (!$cast(trn, rhs)) begin
         `uvm_fatal("MPB_ACCESS_MON_TRN", "Failed to cast rhs during do_compare()")
      end
      else begin
         // Add compares dependent on configuration and/or fields
         // Ex: if (cfg.enable_abc) begin
         //        do_compare &= comparer.compare_field_int("abc", abc, trn.abc, 8);
         //     end
      end
   endfunction
   // pragma uvmx access_mon_trn_do_compare begin

   // pragma uvmx access_mon_trn_do_print begin
   /**
    * TODO Implement or remove uvma_mpb_access_mon_trn_c::do_print()
    */
   virtual function void do_print(uvm_printer printer);
      super.do_print(printer);
      // Print dependent on configuration and/or fields
      // Ex: if (cfg.enable_abc) begin
      //        printer.print_field("abc", abc, 8);
      //     end
   endfunction
   // pragma uvmx access_mon_trn_do_print end

   // pragma uvmx access_mon_trn_do_copy_dox begin
   /**
    * TODO Implement remove uvma_mpb_access_mon_trn_c::do_copy()
    */
   // pragma uvmx access_mon_trn_do_copy_dox end
   virtual function void do_copy(uvm_object rhs);
      // Necessary for uvma_mpb_reg_predictor_c
      uvma_mpb_access_seq_item_c  seq_item;
      super.do_copy(rhs);
      if ($cast(seq_item, rhs)) begin
         // pragma uvmx access_mon_trn_do_copy begin
         op = seq_item.op;
         address = seq_item.address;
         data = seq_item.data;
         // pragma uvmx access_mon_trn_do_copy end
      end
   endfunction

   // pragma uvmx access_mon_trn_get_metadata begin
   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      string  val_str;
      case (op)
         UVMA_MPB_OP_READ: val_str = "READ";
         UVMA_MPB_OP_WRITE: val_str = "WRITE";
         default: val_str = "UNKNOWN";
      endcase
      `uvmx_metadata_field("OP", val_str)
      val_str = $sformatf("%0h", address);
      `uvmx_metadata_field("ADDRESS", val_str)
      val_str = $sformatf("%0h", data);
      `uvmx_metadata_field("DATA", val_str)
   endfunction
   // pragma uvmx access_mon_trn_get_metadata end

   // pragma uvmx access_mon_trn_methods begin
   // pragma uvmx access_mon_trn_methods end

endclass


`endif // __UVMA_MPB_ACCESS_MON_TRN_SV__
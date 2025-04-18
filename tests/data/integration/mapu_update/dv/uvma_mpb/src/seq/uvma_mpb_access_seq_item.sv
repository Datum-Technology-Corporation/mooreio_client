// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_ACCESS_SEQ_ITEM_SV__
`define __UVMA_MPB_ACCESS_SEQ_ITEM_SV__


/**
 * Access: Read/Write register access
 * @ingroup uvma_mpb_seq
 */
class uvma_mpb_access_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mpb_cfg_c  ),
   .T_CNTXT(uvma_mpb_cntxt_c)
);

   /// @name Random Fields
   /// @{
   rand uvma_mpb_op_enum  op; ///< Operation: Access type Read/Write
   rand uvm_reg_addr_t  address; ///< Address: Read/Write Address
   rand uvm_reg_data_t  data; ///< Data: Read/Write Data
   /// @}

   // pragma uvmx access_seq_item_fields begin
   // pragma uvmx access_seq_item_fields end

   `uvm_object_utils_begin(uvma_mpb_access_seq_item_c)
      // pragma uvmx access_seq_item_uvm_field_macros begin
      `uvm_field_enum(uvma_mpb_op_enum, op, UVM_DEFAULT)
      `uvm_field_int(address, UVM_DEFAULT)
      `uvm_field_int(data, UVM_DEFAULT)
      // pragma uvmx access_seq_item_uvm_field_macros end
   `uvm_object_utils_end



   // pragma uvmx access_seq_item_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      // ...
   }
   // pragma uvmx access_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_access_seq_item");
      super.new(name);
   endfunction

   // pragma uvmx access_seq_item_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx access_seq_item_build_dox end
   virtual function void build();
      // pragma uvmx access_seq_item_build begin
      // pragma uvmx access_seq_item_build end
   endfunction

   // pragma uvmx access_seq_item_post_randomize_work begin
   /**
    * TODO Implement or remove uvma_mpb_seq_item_c::post_randomize()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx access_seq_item_post_randomize_work end

   // pragma uvmx access_seq_item_do_print begin
   /**
    * TODO Implement or remove uvma_mpb_seq_item_c::do_print()
    */
   virtual function void do_print(uvm_printer printer);
      super.do_print(printer);
      // Print dependent on configuration and/or fields
      // Ex: if (cfg.enable_abc) begin
      //        printer.print_field("abc", abc, 8);
      //     end
   endfunction
   // pragma uvmx access_seq_item_do_print end

   // pragma uvmx access_seq_item_do_copy_dox begin
   /**
    * TODO Implement remove uvma_mpb_seq_item_c::do_copy()
    */
   // pragma uvmx access_seq_item_do_copy_dox end
   virtual function void do_copy(uvm_object rhs);
      // Necessary for uvma_mpb_reg_predictor_c
      uvma_mpb_access_mon_trn_c  trn;
      super.do_copy(rhs);
      if ($cast(trn, rhs)) begin
         // pragma uvmx access_seq_item_do_copy begin
         op = trn.op;
         address = trn.address;
         data = trn.data;
         // pragma uvmx access_seq_item_do_copy end
      end
   endfunction

   // pragma uvmx access_seq_item_get_metadata begin
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
   // pragma uvmx access_seq_item_get_metadata end

   // pragma uvmx access_seq_item_methods begin
   // pragma uvmx access_seq_item_methods end

endclass


`endif // __UVMA_MPB_ACCESS_SEQ_ITEM_SV__
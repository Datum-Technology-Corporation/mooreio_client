// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_OP_SEQ_ITEM_SV__
`define __UVMA_MAPU_B_OP_SEQ_ITEM_SV__


/**
 * Operation: Operation on 2 matrices
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_op_seq_item_c extends uvmx_block_sb_seq_item_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Random Fields
   /// @{
   rand int unsigned  ton_pct; ///< Percentage ON: Percentage of active clock cycles.
   rand uvma_mapu_b_op_enum  op; ///< Operation: Operation to be performed
   /// @}

   // pragma uvmx op_seq_item_fields begin
   rand uvml_math_mtx_c  ma; ///< Matrix A
   rand uvml_math_mtx_c  mb; ///< Matrix B
   // pragma uvmx op_seq_item_fields end

   `uvm_object_utils_begin(uvma_mapu_b_op_seq_item_c)
      // pragma uvmx op_seq_item_uvm_field_macros begin
      `uvm_field_enum(uvma_mapu_b_op_enum, op, UVM_DEFAULT)
      `uvm_field_object(ma, UVM_DEFAULT)
      `uvm_field_object(mb, UVM_DEFAULT)
      `uvm_field_int(ton_pct, UVM_DEFAULT + UVM_DEC)
      // pragma uvmx op_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Sets randomization space for random fields.
    */
   constraint space_cons {
      ton_pct inside {[1:100]};
   }

   // pragma uvmx op_seq_item_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      ma.min_val == 0;
      mb.min_val == 0;
      ma.num_rows == 3;
      ma.num_cols == 3;
      mb.num_rows == 3;
      mb.num_cols == 3;
      soft ton_pct inside {[50:100]};
   }
   // pragma uvmx op_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_op_seq_item");
      super.new(name);
   endfunction

   // pragma uvmx op_seq_item_post_randomize_work begin
   // pragma uvmx op_seq_item_post_randomize_work end

   // pragma uvmx op_seq_item_do_print begin
   // pragma uvmx op_seq_item_do_print end

   // pragma uvmx op_seq_item_get_metadata begin
   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      string  op_str, ton_pct_str;
      uvmx_metadata_t  mam, mbm;
      case (op)
         UVMA_MAPU_B_OP_ADD : op_str = "ADD ";
         UVMA_MAPU_B_OP_MULT: op_str = "MULT";
      endcase
      `uvmx_metadata_field("op", op_str)
      ton_pct_str = $sformatf("%0d", ton_pct);
      `uvmx_metadata_field("ton", ton_pct_str)
      mam = ma.get_metadata();
      foreach (mam[ii]) begin
         if (cfg.data_width == 32) begin
            mam[ii].width = 12;
         end
         else if (cfg.data_width == 64) begin
            mam[ii].width = 18;
         end
         `uvmx_metadata_add(mam[ii])
      end
      mbm = mb.get_metadata();
      foreach (mbm[ii]) begin
         if (cfg.data_width == 32) begin
            mbm[ii].width = 12;
         end
         else if (cfg.data_width == 64) begin
            mbm[ii].width = 18;
         end
         `uvmx_metadata_add(mbm[ii])
      end
   endfunction
   // pragma uvmx op_seq_item_get_metadata end

   // pragma uvmx op_seq_item_methods begin
   /**
    * Initializes objects and arrays.
    */
   virtual function void build();
      ma = uvml_math_mtx_c::type_id::create("ma");
      mb = uvml_math_mtx_c::type_id::create("mb");
   endfunction
   // pragma uvmx op_seq_item_methods end

endclass


`endif // __UVMA_MAPU_B_OP_SEQ_ITEM_SV__
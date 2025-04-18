// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_PKT_SEQ_ITEM_SV__
`define __UVMA_MSTREAM_PKT_SEQ_ITEM_SV__


/**
 * Packet: Stimulus matrix
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_pkt_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Random Fields
   /// @{
   rand int unsigned  ton_pct; ///< Percentage ON: Percentage of active clock cycles.
   /// @}

   // pragma uvmx pkt_seq_item_fields begin
   rand uvml_math_mtx_c  matrix; ///< Matrix A
   // pragma uvmx pkt_seq_item_fields end

   `uvm_object_utils_begin(uvma_mstream_pkt_seq_item_c)
      // pragma uvmx pkt_seq_item_uvm_field_macros begin
      `uvm_field_int(ton_pct, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(matrix, UVM_DEFAULT)
      // pragma uvmx pkt_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Sets randomization space for random fields.
    */
   constraint space_cons {
      ton_pct inside {[1:100]};
   }

   // pragma uvmx pkt_seq_item_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      matrix.min_val == 0;
      matrix.num_rows == 3;
      matrix.num_cols == 3;
      soft ton_pct inside {[50:100]};
   }
   // pragma uvmx pkt_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_pkt_seq_item");
      super.new(name);
   endfunction

   // pragma uvmx pkt_seq_item_build_dox begin
   /**
    * Initializes objects and arrays.
    */
   // pragma uvmx pkt_seq_item_build_dox end
   virtual function void build();
      // pragma uvmx pkt_seq_item_build begin
      matrix = uvml_math_mtx_c::type_id::create("matrix");
      // pragma uvmx pkt_seq_item_build end
   endfunction

   // pragma uvmx pkt_seq_item_post_randomize_work begin
   virtual function void post_randomize();
      matrix.round_to_int();
   endfunction
   // pragma uvmx pkt_seq_item_post_randomize_work end

   // pragma uvmx pkt_seq_item_do_print begin
   // pragma uvmx pkt_seq_item_do_print end

   // pragma uvmx pkt_seq_item_get_metadata begin
   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      string  val_str;
      uvmx_metadata_t  mam;
      val_str = $sformatf("%0d", ton_pct);
      `uvmx_metadata_field("ton", val_str)
      mam = matrix.get_metadata();
      foreach (mam[ii]) begin
         if (cfg.data_width == 32) begin
            mam[ii].width = 12;
         end
         else if (cfg.data_width == 64) begin
            mam[ii].width = 18;
         end
         `uvmx_metadata_add(mam[ii])
      end
   endfunction
   // pragma uvmx pkt_seq_item_get_metadata end

   // pragma uvmx pkt_seq_item_methods begin
   // pragma uvmx pkt_seq_item_methods end

endclass


`endif // __UVMA_MSTREAM_PKT_SEQ_ITEM_SV__
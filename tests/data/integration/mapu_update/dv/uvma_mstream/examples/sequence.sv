// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This file contains sample code that demonstrates how to add a new Sequence to the Matrix Stream Interface UVM Agent.


`ifndef __UVMA_MSTREAM_EXAMPLE_SEQ_SV__
`define __UVMA_MSTREAM_EXAMPLE_SEQ_SV__


/**
 * Example Sequence that generates 10 fully random items by default.
 */
class uvma_mstream_example_seq_c extends uvma_mstream_base_seq_c;

   /// @name Knobs
   /// @{
   rand int unsigned  num_items; ///< Number of items to be generated.
   /// @}


   `uvm_object_utils_begin(uvma_mstream_example_seq_c)
      `uvm_field_int(num_items, UVM_DEFAULT)
   `uvm_object_utils_end


   /**
    * Default values for random fields.
    */
   constraint defaults_cons {
      soft num_items == 10;
   }


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_example_seq");
      super.new(name);
   endfunction

   /**
    * Generates num_items of fully random items.
    */
   virtual task body();
      for (int unsigned ii=0; ii<num_items; ii++) begin
         `uvm_info("MSTREAM_EXAMPLE_SEQ", $sformatf("Starting item %0d/%0d", (ii+1), num_items), UVM_LOW)
         `uvm_do_with(req, {
            // ...
         })
         `uvm_info("MSTREAM_EXAMPLE_SEQ", $sformatf("Finished item %0d/%0d", (ii+1), num_items), UVM_MEDIUM)
      end
   endtask

endclass


`endif // __UVMA_MSTREAM_EXAMPLE_SEQ_SV__
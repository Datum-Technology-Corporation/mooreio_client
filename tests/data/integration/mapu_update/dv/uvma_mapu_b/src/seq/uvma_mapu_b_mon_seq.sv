// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_MON_SEQ_SV__
`define __UVMA_MAPU_B_MON_SEQ_SV__


/**
 * Sequence taking in Channel Monitor Transactions and creating Matrix APU Agent Monitor Transactions
 * (uvma_mapu_b_mon_trn_c) in both directions.
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_mon_seq_c extends uvma_mapu_b_base_seq_c;

   // pragma uvmx mon_seq_fields begin
   // pragma uvmx mon_seq_fields end
   

   `uvm_object_utils_begin(uvma_mapu_b_mon_seq_c)
      // pragma uvmx mon_seq_uvm_field_macros begin
      // pragma uvmx mon_seq_uvm_field_macros end
   `uvm_object_utils_end
   `uvmx_mon_seq()


   // pragma uvmx mon_seq_constraints begin
   // pragma uvmx mon_seq_constraints end
   

   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_mon_seq");
      super.new(name);
      // pragma uvmx mon_seq_constructor begin
      // pragma uvmx mon_seq_constructor end
   endfunction

   /**
    * Forks off `monitor_x()` tasks.
    */
   task monitor();
      fork
         monitor_in ();
         monitor_out();
      join
   endtask

   /**
    * Creates Matrix APU Agent Monitor Transactions for input direction (relative to DUT).
    */
   task monitor_in();
      // pragma uvmx mon_seq_monitor_in begin
      uvma_mapu_b_mon_trn_c  in_trn;
      forever begin
         // TODO Implement uvma_mapu_b_mon_seq_c::monitor_in()
         //      Ex: `uvmx_get_mon_trn(dpi_trn, dpi_mon_trn_fifo)
         //          if (dpi_trn.vld) begin
         //             in_trn = uvma_mapu_b_mon_trn_c::type_id::create("in_trn");
         //             in_trn.dir_in = 1;
         //             in_trn.abc = dpi_trn.abc;
         //             in_trn.from(dpi_trn);
         //          end
         //          `uvmx_get_mon_trn(dpi_trn, dpi_mon_trn_fifo)
         //          // ...
         //          in_trn.from(dpi_trn);
         //          `uvmx_write_mon_trn(in_trn, in_mon_trn_fifo)
      end
      // pragma uvmx mon_seq_monitor_in end
   endtask

   /**
    * Creates Matrix APU Agent Monitor Transactions for output direction (relative to DUT).
    */
   task monitor_out();
      // pragma uvmx mon_seq_monitor_out begin
      uvma_mapu_b_mon_trn_c  out_trn;
      forever begin
         // TODO Implement uvma_mapu_b_mon_seq_c::monitor_out()
         //      Ex: `uvmx_get_mon_trn(dpi_trn, dpi_mon_trn_fifo)
         //          if (dpi_trn.vld) begin
         //             out_trn = uvma_mapu_b_mon_trn_c::type_id::create("out_trn");
         //             out_trn.dir_in = 0;
         //             out_trn.def = dpi_trn.def;
         //             out_trn.from(dpi_trn);
         //          end
         //          // ...
         //          out_trn.xyz = dpi_trn.xyz;
         //          out_trn.from(dpi_trn);
         //          `uvmx_write_mon_trn(out_trn, out_mon_trn_fifo)
      end
      // pragma uvmx mon_seq_monitor_out end
   endtask

   // pragma uvmx mon_seq_monitor_methods begin
   // pragma uvmx mon_seq_monitor_methods end

endclass


`endif // __UVMA_MAPU_B_MON_SEQ_SV__
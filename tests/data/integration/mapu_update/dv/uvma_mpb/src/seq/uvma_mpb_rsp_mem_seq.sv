// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_RSP_MEM_SEQ_SV__
`define __UVMA_MPB_RSP_MEM_SEQ_SV__


/**
 * Memory: Mock memory
 * @ingroup uvma_mpb_seq_rsp
 */
class uvma_mpb_rsp_mem_seq_c extends uvma_mpb_rsp_base_seq_c;

   // pragma uvmx rsp_mem_seq_fields begin
   uvm_reg_data_t  memory[uvm_reg_addr_t]; ///< Memory model
   // pragma uvmx rsp_mem_seq_fields end


   `uvm_object_utils_begin(uvma_mpb_rsp_mem_seq_c)
      // pragma uvmx rsp_mem_seq_uvm_field_macros begin
      // pragma uvmx rsp_mem_seq_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx rsp_mem_seq_constraints begin
   // pragma uvmx rsp_mem_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_rsp_mem_seq");
      super.new(name);
   endfunction

   // pragma uvmx rsp_mem_seq_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx rsp_mem_seq_build_dox end
   virtual function void build();
      // pragma uvmx rsp_mem_seq_build begin
      // pragma uvmx rsp_mem_seq_build end
   endfunction

   // pragma uvmx rsp_mem_seq_create_sequences_dox begin
   /**
    * Empty
    */
   // pragma uvmx rsp_mem_seq_create_sequences_dox end
   virtual function void create_sequences();
      // pragma uvmx rsp_mem_seq_create_sequences begin
      // pragma uvmx rsp_mem_seq_create_sequences end
   endfunction

   // pragma uvmx rsp_mem_seq_post_randomize_work begin
   // pragma uvmx rsp_mem_seq_post_randomize_work end

   // pragma uvmx rsp_mem_seq_drive_rsp_dox begin
   /**
    * TODO Implement uvma_mpb_rsp_mem_seq_c::drive_rsp()
    */
   // pragma uvmx rsp_mem_seq_drive_rsp_dox end
   virtual task drive_rsp(output bit handled,
      // pragma uvmx rsp_mem_seq_drive_rsp_sig begin
      ref uvma_mpb_p_mon_trn_c  trn
      // pragma uvmx rsp_mem_seq_drive_rsp_sig end
   );
      // pragma uvmx rsp_mem_seq_drive_rsp begin
      if (trn.wr === 0) begin
         drive_read(trn);
         handled = 1;
      end
      else if (trn.wr === 1) begin
         drive_write(trn);
         handled = 1;
      end
      else begin
         `uvm_error("MPB_MEM_SEQ", $sformatf("Invalid 'wr' value: %h", trn.wr))
         handled = 0;
      end
      // pragma uvmx rsp_mem_seq_drive_rsp end
   endtask

   // pragma uvmx rsp_mem_seq_methods begin
   task drive_read(ref uvma_mpb_p_mon_trn_c  trn);
      uvma_mpb_sec_p_seq_item_c  p_seq_item;
      uvm_reg_data_t  data = 'hDEAD_BEEF;
      if (memory.exists(trn.addr)) begin
         data = memory[trn.addr];
      end
      `uvmx_create_on(p_seq_item, sec_p_sequencer)
      `uvmx_rand_send_drv_with(p_seq_item, {
         rdy == 1;
         rdata == data;
      })
   endtask

   task drive_write(ref uvma_mpb_p_mon_trn_c  trn);
      uvma_mpb_sec_p_seq_item_c  p_seq_item;
      memory[trn.addr] = trn.wdata;
      `uvmx_create_on(p_seq_item, sec_p_sequencer)
      `uvmx_rand_send_drv_with(p_seq_item, {
         rdy == 1;
      })
   endtask
   // pragma uvmx rsp_mem_seq_methods end

endclass


`endif // __UVMA_MPB_RSP_MEM_SEQ_SV__
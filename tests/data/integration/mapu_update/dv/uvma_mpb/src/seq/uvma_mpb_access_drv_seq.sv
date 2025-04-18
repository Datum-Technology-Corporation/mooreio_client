// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_ACCESS_DRV_SEQ_SV__
`define __UVMA_MPB_ACCESS_DRV_SEQ_SV__


/**
 * Access: Drives main access
 * @ingroup uvma_mpb_seq
 */
class uvma_mpb_access_drv_seq_c extends uvma_mpb_base_seq_c;

   `uvm_object_utils(uvma_mpb_access_drv_seq_c)
   `uvmx_drv_main_seq(uvma_mpb_access_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_access_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx access_drv_seq_drive_item_dox begin
   /**
    * TODO Implement uvma_mpb_access_drv_seq_c::drive()
    */
   // pragma uvmx access_drv_seq_drive_item_dox end
   task drive_item(bit async=0, ref uvma_mpb_access_seq_item_c seq_item);
      // pragma uvmx access_drv_seq_drive_item begin
      if (cfg.drv_mode == UVMA_MPB_DRV_MODE_MAIN) begin
         if (seq_item.op == UVMA_MPB_OP_READ) begin
            drive_read(seq_item);
         end
         else if (seq_item.op == UVMA_MPB_OP_WRITE) begin
            drive_write(seq_item);
         end
         else begin
            `uvm_fatal("ACCESS_DRV_SEQ", $sformatf("Invalid seq_item.op: %s", seq_item.op.name()))
         end
      end
      else begin
         `uvm_fatal("ACCESS_DRV_SEQ", $sformatf("Invalid cfg.drv_mode: %s", cfg.drv_mode.name()))
      end
      // pragma uvmx access_drv_seq_drive_item end
   endtask

   // pragma uvmx access_drv_seq_methods begin
   task drive_read(ref uvma_mpb_access_seq_item_c seq_item);
      uvma_mpb_main_p_seq_item_c  p_seq_item;
      do begin
         `uvmx_create_on(p_seq_item, main_p_sequencer)
         p_seq_item.from(seq_item);
         p_seq_item.vld = 1;
         p_seq_item.wr = 0;
         p_seq_item.addr = seq_item.address;
         `uvmx_send_drv(p_seq_item)
      end while (p_seq_item.rdy !== 1);
      seq_item.data = p_seq_item.rdata;
   endtask

   task drive_write(ref uvma_mpb_access_seq_item_c seq_item);
      uvma_mpb_main_p_seq_item_c  p_seq_item;
      do begin
         `uvmx_create_on(p_seq_item, main_p_sequencer)
         p_seq_item.from(seq_item);
         p_seq_item.vld = 1;
         p_seq_item.wr = 1;
         p_seq_item.addr = seq_item.address;
         p_seq_item.wdata = seq_item.data;
         `uvmx_send_drv(p_seq_item)
      end while (p_seq_item.rdy !== 1);
   endtask
   // pragma uvmx access_drv_seq_methods end

endclass


`endif // __UVMA_MPB_ACCESS_DRV_SEQ_SV__
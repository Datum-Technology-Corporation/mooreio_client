// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_IDLE_DRV_SEQ_SV__
`define __UVMA_MPB_IDLE_DRV_SEQ_SV__


/**
 * Idle: Ensures valid signals stay low when buses are inactive
 * @ingroup uvma_mpb_seq
 */
class uvma_mpb_idle_drv_seq_c extends uvma_mpb_base_seq_c;
   
   `uvm_object_utils(uvma_mpb_idle_drv_seq_c)
   `uvmx_drv_idle_seq(uvma_mpb_idle_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_idle_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx idle_drv_seq_idle_dox begin
   /**
    * TODO Implement uvma_mpb_idle_drv_seq_c::idle()
    */
   // pragma uvmx idle_drv_seq_idle_dox end
   task idle();
      // pragma uvmx idle_drv_seq_idle begin
      uvma_mpb_main_p_seq_item_c  main_p_seq_item;
      uvma_mpb_sec_p_seq_item_c  sec_p_seq_item;
      if (cfg.drv_mode == UVMA_MPB_DRV_MODE_MAIN) begin
         fork
            forever begin
               `uvmx_rand_idle_with(main_p_seq_item, main_p_sequencer, {
                  vld == 0;
               })
            end
         join
      end
      else if (cfg.drv_mode == UVMA_MPB_DRV_MODE_SEC) begin
         fork
            forever begin
               `uvmx_rand_idle_with(sec_p_seq_item, sec_p_sequencer, {
                  rdy == 0;
               })
            end
         join
      end
      else begin
         `uvm_fatal("MPB_IDLE_DRV_SEQ", $sformatf("Invalid cfg.drv_mode: %s", cfg.drv_mode.name()))
      end
      // pragma uvmx idle_drv_seq_idle end
   endtask

   // pragma uvmx idle_drv_seq_methods begin
   // pragma uvmx idle_drv_seq_methods end

endclass


`endif // __UVMA_MPB_IDLE_DRV_SEQ_SV__
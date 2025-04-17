// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_IDLE_DRV_SEQ_SV__
`define __UVMA_MSTREAM_IDLE_DRV_SEQ_SV__


/**
 * Idle: Ensures valid signals stay low when buses are inactive
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_idle_drv_seq_c extends uvma_mstream_base_seq_c;
   
   `uvm_object_utils(uvma_mstream_idle_drv_seq_c)
   `uvmx_drv_idle_seq(uvma_mstream_idle_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_idle_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx idle_drv_seq_idle_dox begin
   /**
    * TODO Implement uvma_mstream_idle_drv_seq_c::idle()
    */
   // pragma uvmx idle_drv_seq_idle_dox end
   task idle();
      // pragma uvmx idle_drv_seq_idle begin
      uvma_mstream_host_ig_seq_item_c  host_ig_seq_item;
      uvma_mstream_card_ig_seq_item_c  card_ig_seq_item;
      uvma_mstream_host_eg_seq_item_c  host_eg_seq_item;
      uvma_mstream_card_eg_seq_item_c  card_eg_seq_item;
      if (cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_HOST) begin
         fork
            forever begin
               `uvmx_rand_idle_with(host_ig_seq_item, host_ig_sequencer, {
                  ig_vld == 0;
               })
            end
            forever begin
               `uvmx_rand_idle_with(host_eg_seq_item, host_eg_sequencer, {
                  eg_rdy == 0;
               })
            end
         join
      end
      else if (cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_CARD) begin
         fork
            forever begin
               `uvmx_rand_idle_with(card_ig_seq_item, card_ig_sequencer, {
                  ig_rdy == 0;
               })
            end
            forever begin
               `uvmx_rand_idle_with(card_eg_seq_item, card_eg_sequencer, {
                  eg_vld == 0;
               })
            end
         join
      end
      else begin
         `uvm_fatal("MSTREAM_IDLE_DRV_SEQ", $sformatf("Invalid cfg.drv_mode: %s", cfg.drv_mode.name()))
      end
      // pragma uvmx idle_drv_seq_idle end
   endtask

   // pragma uvmx idle_drv_seq_methods begin
   // pragma uvmx idle_drv_seq_methods end

endclass


`endif // __UVMA_MSTREAM_IDLE_DRV_SEQ_SV__
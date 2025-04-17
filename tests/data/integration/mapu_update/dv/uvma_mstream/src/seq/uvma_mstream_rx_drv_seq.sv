// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_RX_DRV_SEQ_SV__
`define __UVMA_MSTREAM_RX_DRV_SEQ_SV__


/**
 * Receiver: Drives rdy
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_rx_drv_seq_c extends uvma_mstream_base_seq_c;

   `uvm_object_utils(uvma_mstream_rx_drv_seq_c)
   `uvmx_drv_seq(uvma_mstream_rx_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_rx_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx rx_drv_seq_dox begin
   /**
    * TODO Implement uvma_mstream_rx_drv_seq_c::drive()
    */
   // pragma uvmx rx_drv_seq_dox end
   virtual task drive();
      // pragma uvmx rx_drv_seq_drive begin
      if (cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_HOST) begin
         drive_eg();
      end
      else if (cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_CARD) begin
         drive_ig();
      end
      else begin
         `uvm_fatal("MSTREAM_RX_DRV_SEQ", $sformatf("Invalid cfg.drv_mode: %s", cfg.drv_mode.name()))
      end
      // pragma uvmx rx_drv_seq_drive end
   endtask

   // pragma uvmx rx_drv_seq_methods begin
   /**
    * TODO Implement uvma_mstream_rx_drv_seq_c::drive_eg()
    */
   virtual task drive_eg();
      uvma_mstream_host_eg_seq_item_c  eg_seq_item;
      bit  within_transfer;
      forever begin
         within_transfer = 0;
         if (eg_seq_item != null) begin
            if (eg_seq_item.eg_vld === 1) begin
               within_transfer = 1;
            end
         end
         if (within_transfer) begin
            `uvmx_create_on(eg_seq_item, host_eg_sequencer)
            `uvmx_rand_send_drv_with(eg_seq_item, {
               eg_rdy == 1;
            })
         end
         else begin
            randcase
               cfg.rx_drv_ton_pct: begin
                  `uvmx_create_on(eg_seq_item, host_eg_sequencer)
                  `uvmx_rand_send_drv_with(eg_seq_item, {
                     eg_rdy == 1;
                  })
               end
               (100-cfg.rx_drv_ton_pct): begin
                  clk();
               end
            endcase
         end
      end
   endtask

   /**
    * TODO Implement uvma_mstream_rx_drv_seq_c::drive_ig()
    */
   virtual task drive_ig();
      uvma_mstream_card_ig_seq_item_c  ig_seq_item;
      bit  within_transfer;
      forever begin
         within_transfer = 0;
         if (ig_seq_item != null) begin
            if (ig_seq_item.ig_vld === 1) begin
               within_transfer = 1;
            end
         end
         if (within_transfer) begin
            `uvmx_create_on(ig_seq_item, card_ig_sequencer)
            `uvmx_rand_send_drv_with(ig_seq_item, {
               ig_rdy == 1;
            })
         end
         else begin
            randcase
               cfg.rx_drv_ton_pct: begin
                  `uvmx_create_on(ig_seq_item, card_ig_sequencer)
                  `uvmx_rand_send_drv_with(ig_seq_item, {
                     ig_rdy == 1;
                  })
               end
               (100-cfg.rx_drv_ton_pct): begin
                  clk();
               end
            endcase
         end
      end
   endtask
   // pragma uvmx rx_drv_seq_methods end

endclass


`endif // __UVMA_MSTREAM_RX_DRV_SEQ_SV__
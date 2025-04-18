// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_PKT_DRV_SEQ_SV__
`define __UVMA_MSTREAM_PKT_DRV_SEQ_SV__


/**
 * Packet: Drives packets in the active direction
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_pkt_drv_seq_c extends uvma_mstream_base_seq_c;

   `uvm_object_utils(uvma_mstream_pkt_drv_seq_c)
   `uvmx_drv_main_seq(uvma_mstream_pkt_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_pkt_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx pkt_drv_seq_drive_item_dox begin
   /**
    * TODO Implement uvma_mstream_pkt_drv_seq_c::drive()
    */
   // pragma uvmx pkt_drv_seq_drive_item_dox end
   task drive_item(bit async=0, ref uvma_mstream_pkt_seq_item_c seq_item);
      // pragma uvmx pkt_drv_seq_drive_item begin
      int unsigned row_count = 0;
      do begin
         randcase
            seq_item.ton_pct: begin
               drive_row(seq_item, row_count);
               row_count++;
            end
            (100-seq_item.ton_pct): begin
               clk();
            end
         endcase
      end while (row_count<3);
      // pragma uvmx pkt_drv_seq_drive_item end
   endtask

   // pragma uvmx pkt_drv_seq_methods begin
   /**
    * Drives a single matrix row into the DUT.
    */
   virtual task drive_row(uvma_mstream_pkt_seq_item_c seq_item, int unsigned row);
      uvma_mstream_host_ig_seq_item_c  host_ig_seq_item;
      uvma_mstream_card_eg_seq_item_c  card_eg_seq_item;
      if (cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_HOST) begin
         do begin
            `uvmx_create_on(host_ig_seq_item, host_ig_sequencer)
            host_ig_seq_item.from(seq_item);
            host_ig_seq_item.ig_vld = 1;
            host_ig_seq_item.ig_r0  = seq_item.matrix.geti(row, 0, cfg.data_width);
            host_ig_seq_item.ig_r1  = seq_item.matrix.geti(row, 1, cfg.data_width);
            host_ig_seq_item.ig_r2  = seq_item.matrix.geti(row, 2, cfg.data_width);
            `uvmx_send_drv(host_ig_seq_item)
         end while (host_ig_seq_item.ig_rdy !== 1);
      end
      else if (cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_CARD) begin
         do begin
            `uvmx_create_on(card_eg_seq_item, card_eg_sequencer)
            card_eg_seq_item.from(seq_item);
            card_eg_seq_item.eg_vld = 1;
            card_eg_seq_item.eg_r0  = seq_item.matrix.geti(row, 0, cfg.data_width);
            card_eg_seq_item.eg_r1  = seq_item.matrix.geti(row, 1, cfg.data_width);
            card_eg_seq_item.eg_r2  = seq_item.matrix.geti(row, 2, cfg.data_width);
            `uvmx_send_drv(card_eg_seq_item)
         end while (card_eg_seq_item.eg_rdy !== 1);
      end
      else begin
         `uvm_fatal("MSTREAM_PKT_DRV_SEQ", $sformatf("Invalid cfg.drv_mode: %s", cfg.drv_mode.name()))
      end
   endtask
   // pragma uvmx pkt_drv_seq_methods end

endclass


`endif // __UVMA_MSTREAM_PKT_DRV_SEQ_SV__
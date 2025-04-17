// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_AGENT_SV__
`define __UVMA_MSTREAM_AGENT_SV__


/**
 * Sequence-based UVM Agent capable of driving/monitoring the Matrix Stream Interface Interface (uvma_mstream_if).
 * @ingroup uvma_mstream_comps
 */
class uvma_mstream_agent_c extends uvmx_agent_c #(
   .T_VIF    (virtual uvma_mstream_if),
   .T_CFG    (uvma_mstream_cfg_c     ),
   .T_CNTXT  (uvma_mstream_cntxt_c   ),
   .T_SQR    (uvma_mstream_sqr_c     ),
   .T_DRV    (uvma_mstream_drv_c     ),
   .T_MON    (uvma_mstream_mon_c     ),
   .T_LOGGER (uvma_mstream_logger_c  )
);

   /// @name Ports
   /// @{
   uvm_analysis_port #(uvma_mstream_pkt_seq_item_c)  seq_item_ap; ///< Output port for 'Packet' Sequence Items
   uvm_analysis_port #(uvma_mstream_pkt_mon_trn_c)  ig_pkt_mon_trn_ap; ///< Ingress Packet: Ingress traffic
   uvm_analysis_port #(uvma_mstream_pkt_mon_trn_c)  eg_pkt_mon_trn_ap; ///< Egress Packet: Egress traffic
   uvm_analysis_port #(uvma_mstream_host_ig_seq_item_c)  host_ig_seq_item_ap; ///< Output port for HOST Ingress Sequence Items
   uvm_analysis_port #(uvma_mstream_card_ig_seq_item_c)  card_ig_seq_item_ap; ///< Output port for CARD Ingress Sequence Items
   uvm_analysis_port #(uvma_mstream_host_eg_seq_item_c)  host_eg_seq_item_ap; ///< Output port for HOST Egress Sequence Items
   uvm_analysis_port #(uvma_mstream_card_eg_seq_item_c)  card_eg_seq_item_ap; ///< Output port for CARD Egress Sequence Items
   uvm_analysis_port #(uvma_mstream_ig_mon_trn_c)  ig_mon_trn_ap; ///< Output port for Ingress Monitor Transactions
   uvm_analysis_port #(uvma_mstream_eg_mon_trn_c)  eg_mon_trn_ap; ///< Output port for Egress Monitor Transactions
   /// @}


   `uvm_component_utils(uvma_mstream_agent_c)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_agent", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Connects sequencer to driver's TLM ports.
    */
   virtual function void connect_drivers_sequencers();
      driver.host_ig_driver.seq_item_port.connect(sequencer.host_ig_sequencer.seq_item_export);
      driver.card_ig_driver.seq_item_port.connect(sequencer.card_ig_sequencer.seq_item_export);
      driver.host_eg_driver.seq_item_port.connect(sequencer.host_eg_sequencer.seq_item_export);
      driver.card_eg_driver.seq_item_port.connect(sequencer.card_eg_sequencer.seq_item_export);
   endfunction

   /**
    * Connects sequencer to monitor's TLM ports.
    */
   virtual function void connect_monitor_sequencer();
      monitor.ig_monitor.ap.connect(sequencer.ig_mon_trn_fifo.analysis_export);
      monitor.eg_monitor.ap.connect(sequencer.eg_mon_trn_fifo.analysis_export);
   endfunction

   /**
    * Connects top-level ports to lower-level components'.
    */
   virtual function void connect_ports();
      seq_item_ap = sequencer.ap;
      ig_pkt_mon_trn_ap = sequencer.ig_pkt_mon_trn_fifo.put_ap;
      eg_pkt_mon_trn_ap = sequencer.eg_pkt_mon_trn_fifo.put_ap;
      host_ig_seq_item_ap = sequencer.host_ig_sequencer.ap;
      card_ig_seq_item_ap = sequencer.card_ig_sequencer.ap;
      host_eg_seq_item_ap = sequencer.host_eg_sequencer.ap;
      card_eg_seq_item_ap = sequencer.card_eg_sequencer.ap;
      ig_mon_trn_ap = monitor.ig_monitor.ap;
      eg_mon_trn_ap = monitor.eg_monitor.ap;
   endfunction

   /**
    * Connects loggers to ports.
    */
   virtual function void connect_logger();
      seq_item_ap.connect(logger.seq_item_logger.analysis_export);
      ig_pkt_mon_trn_ap.connect(logger.ig_pkt_mon_trn_logger.analysis_export);
      eg_pkt_mon_trn_ap.connect(logger.eg_pkt_mon_trn_logger.analysis_export);
      host_ig_seq_item_ap.connect(logger.host_ig_seq_item_logger.analysis_export);
      card_ig_seq_item_ap.connect(logger.card_ig_seq_item_logger.analysis_export);
      host_eg_seq_item_ap.connect(logger.host_eg_seq_item_logger.analysis_export);
      card_eg_seq_item_ap.connect(logger.card_eg_seq_item_logger.analysis_export);
      ig_mon_trn_ap.connect(logger.ig_mon_trn_logger.analysis_export);
      eg_mon_trn_ap.connect(logger.eg_mon_trn_logger.analysis_export);
   endfunction

   /**
    * Starts internal Sequences for driving and monitoring.
    */
   virtual task start_sequences();
      // pragma uvmx agent_start_sequences begin
      uvma_mstream_ig_mon_seq_c  ig_mon_seq;
      uvma_mstream_eg_mon_seq_c  eg_mon_seq;
      uvma_mstream_idle_drv_seq_c  idle_drv_seq;
      uvma_mstream_pkt_drv_seq_c  pkt_drv_seq;
      uvma_mstream_rx_drv_seq_c  rx_drv_seq;
      `uvmx_agent_start_sequence(uvma_mstream_ig_mon_seq_c, ig_mon_seq)
      `uvmx_agent_start_sequence(uvma_mstream_eg_mon_seq_c, eg_mon_seq)
      if (cfg.is_active) begin
         `uvmx_agent_start_sequence(uvma_mstream_idle_drv_seq_c, idle_drv_seq)
         `uvmx_agent_start_sequence(uvma_mstream_pkt_drv_seq_c, pkt_drv_seq)
         `uvmx_agent_start_sequence(uvma_mstream_rx_drv_seq_c, rx_drv_seq)
      end
      // pragma uvmx agent_start_sequences end
   endtask

   // pragma uvmx agent_methods begin
   // pragma uvmx agent_methods end

endclass


`endif // __UVMA_MSTREAM_AGENT_SV__
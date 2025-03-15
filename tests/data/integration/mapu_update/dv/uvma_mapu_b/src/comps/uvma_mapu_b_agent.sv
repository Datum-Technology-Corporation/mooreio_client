// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_AGENT_SV__
`define __UVMA_MAPU_B_AGENT_SV__


/**
 * Sequence-based UVM Agent capable of driving/monitoring the Matrix APU Interface (uvma_mapu_b_if).
 * @ingroup uvma_mapu_b_comps
 */
class uvma_mapu_b_agent_c extends uvmx_block_sb_agent_c #(
   .T_VIF      (virtual uvma_mapu_b_if),
   .T_CFG      (uvma_mapu_b_cfg_c     ),
   .T_CNTXT    (uvma_mapu_b_cntxt_c   ),
   .T_SEQ_ITEM (uvma_mapu_b_seq_item_c),
   .T_SQR      (uvma_mapu_b_sqr_c     ),
   .T_DRV      (uvma_mapu_b_drv_c     ),
   .T_MON      (uvma_mapu_b_mon_c     ),
   .T_LOGGER   (uvma_mapu_b_logger_c  )
);

   /// @name Ports
   /// @{
   uvm_analysis_port #(uvma_mapu_b_mon_trn_c)  in_mon_trn_ap; ///< Output port for Input Monitor Transactions
   uvm_analysis_port #(uvma_mapu_b_mon_trn_c)  out_mon_trn_ap; ///< Output port for Output Monitor Transactions
   uvm_analysis_port #(uvma_mapu_b_dpi_seq_item_c)  dpi_seq_item_ap; ///< Output port for Data Plane Input Sequence Items
   uvm_analysis_port #(uvma_mapu_b_dpo_seq_item_c)  dpo_seq_item_ap; ///< Output port for Data Plane Output Sequence Items
   uvm_analysis_port #(uvma_mapu_b_cp_seq_item_c)  cp_seq_item_ap; ///< Output port for Control Plane Sequence Items
   uvm_analysis_port #(uvma_mapu_b_dpi_mon_trn_c)  dpi_mon_trn_ap; ///< Output port for Data Plane Input Monitor Transactions
   uvm_analysis_port #(uvma_mapu_b_dpo_mon_trn_c)  dpo_mon_trn_ap; ///< Output port for Data Plane Output Monitor Transactions
   uvm_analysis_port #(uvma_mapu_b_cp_mon_trn_c)  cp_mon_trn_ap; ///< Output port for Control Plane Monitor Transactions
   /// @}

   // pragma uvmx agent_fields begin
   // pragma uvmx agent_fields end


   `uvm_component_utils_begin(uvma_mapu_b_agent_c)
      // pragma uvmx agent_uvm_field_macros begin
      // pragma uvmx agent_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_agent", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx agent_constructor begin
      // pragma uvmx agent_constructor end
   endfunction

   /**
    * Connects sequencer to driver's TLM ports.
    */
   virtual function void connect_drivers_sequencers();
      driver.dpi_driver.seq_item_port.connect(sequencer.dpi_sequencer.seq_item_export);
      driver.dpo_driver.seq_item_port.connect(sequencer.dpo_sequencer.seq_item_export);
      driver.cp_driver.seq_item_port.connect(sequencer.cp_sequencer.seq_item_export);
      // pragma uvmx agent_connect_drivers_sequencers begin
      // pragma uvmx agent_connect_drivers_sequencers end
   endfunction

   /**
    * Connects sequencer to monitor's TLM ports.
    */
   virtual function void connect_monitor_sequencer();
      monitor.dpi_monitor.ap.connect(sequencer.dpi_mon_trn_fifo.analysis_export);
      monitor.dpo_monitor.ap.connect(sequencer.dpo_mon_trn_fifo.analysis_export);
      monitor.cp_monitor.ap.connect(sequencer.cp_mon_trn_fifo.analysis_export);
      // pragma uvmx agent_connect_monitor_sequencer begin
      // pragma uvmx agent_connect_monitor_sequencer end
   endfunction

   /**
    * Connects top-level ports to lower-level components'.
    */
   virtual function void connect_ports();
      in_mon_trn_ap = sequencer.in_mon_trn_fifo.put_ap;
      out_mon_trn_ap = sequencer.out_mon_trn_fifo.put_ap;
      dpi_seq_item_ap = sequencer.dpi_sequencer.ap;
      dpo_seq_item_ap = sequencer.dpo_sequencer.ap;
      cp_seq_item_ap = sequencer.cp_sequencer.ap;
      dpi_mon_trn_ap = monitor.dpi_monitor.ap;
      dpo_mon_trn_ap = monitor.dpo_monitor.ap;
      cp_mon_trn_ap = monitor.cp_monitor.ap;
      // pragma uvmx agent_connect_ports begin
      // pragma uvmx agent_connect_ports end
   endfunction

   /**
    * Connects loggers to ports.
    */
   virtual function void connect_logger();
      in_mon_trn_ap.connect(logger.in_mon_trn_logger.analysis_export);
      out_mon_trn_ap.connect(logger.out_mon_trn_logger.analysis_export);
      dpi_seq_item_ap.connect(logger.dpi_seq_item_logger.analysis_export);
      dpo_seq_item_ap.connect(logger.dpo_seq_item_logger.analysis_export);
      cp_seq_item_ap.connect(logger.cp_seq_item_logger.analysis_export);
      dpi_mon_trn_ap.connect(logger.dpi_mon_trn_logger.analysis_export);
      dpo_mon_trn_ap.connect(logger.dpo_mon_trn_logger.analysis_export);
      cp_mon_trn_ap.connect(logger.cp_mon_trn_logger.analysis_export);
      // pragma uvmx agent_connect_logger begin
      // pragma uvmx agent_connect_logger end
   endfunction

   /**
    * Starts internal Sequences for driving and monitoring.
    */
   virtual task start_sequences();
      if (cfg.is_active) begin
         start_sequence(cfg.idle_drv_seq_type, cntxt.idle_drv_seq);
         start_sequence(cfg.in_drv_seq_type, cntxt.in_drv_seq);
         start_sequence(cfg.out_drv_seq_type, cntxt.out_drv_seq);
      end
      // pragma uvmx agent_start_sequences begin
      // pragma uvmx agent_start_sequences end
   endtask

   // pragma uvmx agent_methods begin
   // pragma uvmx agent_methods end

endclass


`endif // __UVMA_MAPU_B_AGENT_SV__
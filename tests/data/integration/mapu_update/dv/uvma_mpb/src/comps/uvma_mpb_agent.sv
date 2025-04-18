// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_AGENT_SV__
`define __UVMA_MPB_AGENT_SV__


/**
 * Sequence-based UVM Agent capable of driving/monitoring the Matrix Peripheral Bus Interface (uvma_mpb_if).
 * @ingroup uvma_mpb_comps
 */
class uvma_mpb_agent_c extends uvmx_agent_c #(
   .T_VIF    (virtual uvma_mpb_if),
   .T_CFG    (uvma_mpb_cfg_c     ),
   .T_CNTXT  (uvma_mpb_cntxt_c   ),
   .T_SQR    (uvma_mpb_sqr_c     ),
   .T_DRV    (uvma_mpb_drv_c     ),
   .T_MON    (uvma_mpb_mon_c     ),
   .T_LOGGER (uvma_mpb_logger_c  )
);

   /// @name Ports
   /// @{
   uvm_analysis_port #(uvma_mpb_access_seq_item_c)  seq_item_ap; ///< Output port for 'Access' Sequence Items
   uvm_analysis_port #(uvma_mpb_access_mon_trn_c)  access_mon_trn_ap; ///< Access: Monitored traffic
   uvm_analysis_port #(uvma_mpb_main_p_seq_item_c)  main_p_seq_item_ap; ///< Output port for MAIN Parallel Sequence Items
   uvm_analysis_port #(uvma_mpb_sec_p_seq_item_c)  sec_p_seq_item_ap; ///< Output port for SEC Parallel Sequence Items
   uvm_analysis_port #(uvma_mpb_p_mon_trn_c)  p_mon_trn_ap; ///< Output port for Parallel Monitor Transactions
   /// @}


   `uvm_component_utils(uvma_mpb_agent_c)


   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_agent", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Connects sequencer to driver's TLM ports.
    */
   virtual function void connect_drivers_sequencers();
      driver.main_p_driver.seq_item_port.connect(sequencer.main_p_sequencer.seq_item_export);
      driver.sec_p_driver.seq_item_port.connect(sequencer.sec_p_sequencer.seq_item_export);
   endfunction

   /**
    * Connects sequencer to monitor's TLM ports.
    */
   virtual function void connect_monitor_sequencer();
      monitor.p_monitor.ap.connect(sequencer.p_mon_trn_fifo.analysis_export);
   endfunction

   /**
    * Connects top-level ports to lower-level components'.
    */
   virtual function void connect_ports();
      seq_item_ap = sequencer.ap;
      access_mon_trn_ap = sequencer.access_mon_trn_fifo.put_ap;
      main_p_seq_item_ap = sequencer.main_p_sequencer.ap;
      sec_p_seq_item_ap = sequencer.sec_p_sequencer.ap;
      p_mon_trn_ap = monitor.p_monitor.ap;
   endfunction

   /**
    * Connects loggers to ports.
    */
   virtual function void connect_logger();
      seq_item_ap.connect(logger.seq_item_logger.analysis_export);
      access_mon_trn_ap.connect(logger.access_mon_trn_logger.analysis_export);
      main_p_seq_item_ap.connect(logger.main_p_seq_item_logger.analysis_export);
      sec_p_seq_item_ap.connect(logger.sec_p_seq_item_logger.analysis_export);
      p_mon_trn_ap.connect(logger.p_mon_trn_logger.analysis_export);
   endfunction

   /**
    * Starts internal Sequences for driving and monitoring.
    */
   virtual task start_sequences();
      // pragma uvmx agent_start_sequences begin
      uvma_mpb_access_mon_seq_c  access_mon_seq;
      uvma_mpb_idle_drv_seq_c  idle_drv_seq;
      uvma_mpb_access_drv_seq_c  access_drv_seq;
      uvma_mpb_rsp_drv_seq_c  rsp_drv_seq;
      uvma_mpb_rsp_mem_seq_c  rsp_mem_seq;
      `uvmx_agent_start_sequence(uvma_mpb_access_mon_seq_c, access_mon_seq)
      if (cfg.is_active) begin
         `uvmx_agent_start_sequence(uvma_mpb_idle_drv_seq_c, idle_drv_seq)
         if (cfg.drv_mode == UVMA_MPB_DRV_MODE_MAIN) begin
            `uvmx_agent_start_sequence(uvma_mpb_access_drv_seq_c, access_drv_seq)
         end
         else if (cfg.drv_mode == UVMA_MPB_DRV_MODE_SEC) begin
            `uvmx_agent_start_sequence(uvma_mpb_rsp_drv_seq_c, rsp_drv_seq)
            `uvmx_agent_start_sequence(uvma_mpb_rsp_mem_seq_c, rsp_mem_seq)
         end
         else begin
            `uvm_fatal("MPB_AGENT", $sformatf("Invalid cfg.drv_mode: %s", cfg.drv_mode.name()))
         end
      end
      // pragma uvmx agent_start_sequences end
   endtask

   // pragma uvmx agent_methods begin
   // pragma uvmx agent_methods end

endclass


`endif // __UVMA_MPB_AGENT_SV__
// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_PRD_SV__
`define __UVME_MSTREAM_ST_PRD_SV__


/**
 * Component implementing TLM prediction/checking of Matrix Stream Interface Agent Self-Testing.
 * @ingroup uvme_mstream_st_comps
 */
class uvme_mstream_st_prd_c extends uvmx_agent_prd_c #(
   .T_CFG  (uvme_mstream_st_cfg_c  ),
   .T_CNTXT(uvme_mstream_st_cntxt_c)
);

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_seq_item_c)  agent_ig_fifo; ///< Agent Ingress Monitor Transactions to be processed.
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_seq_item_c)  agent_eg_fifo; ///< Agent Egress Monitor Transactions to be processed.
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_mon_trn_c)  e2e_ig_fifo; ///< Eng-to-End Ingress Monitor Transactions to be processed.
   uvm_tlm_analysis_fifo #(uvma_mstream_pkt_mon_trn_c)  e2e_eg_fifo; ///< Eng-to-End Egress Monitor Transactions to be processed.
   /// @}

   /// @name Ports
   /// @{
   uvm_analysis_port #(uvma_mstream_pkt_mon_trn_c)  agent_ig_ap; ///< Port producing predicted Agent Ingress Monitor Transactions.
   uvm_analysis_port #(uvma_mstream_pkt_mon_trn_c)  agent_eg_ap; ///< Port producing predicted Agent Egress Monitor Transactions.
   uvm_analysis_port #(uvma_mstream_pkt_mon_trn_c)  e2e_ig_ap; ///< Port producing predicted End-to-End Ingress Monitor Transactions.
   uvm_analysis_port #(uvma_mstream_pkt_mon_trn_c)  e2e_eg_ap; ///< Port producing predicted End-to-End Egress Monitor Transactions.
   /// @}

   // pragma uvmx prd_fields begin
   // pragma uvmx prd_fields end


   `uvm_component_utils_begin(uvme_mstream_st_prd_c)
      // pragma uvmx prd_uvm_field_macros begin
      // pragma uvmx prd_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mstream_st_prd", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      agent_ig_fifo = new("agent_ig_fifo", this);
      agent_eg_fifo = new("agent_eg_fifo", this);
      e2e_ig_fifo = new("e2e_ig_fifo", this);
      e2e_eg_fifo = new("e2e_eg_fifo", this);
      // pragma uvmx prd_create_fifos begin
      // pragma uvmx prd_create_fifos end
   endfunction

   /**
    * Creates TLM Ports.
    */
   virtual function void create_ports();
      agent_ig_ap = new("agent_ig_ap", this);
      agent_eg_ap = new("agent_eg_ap", this);
      e2e_ig_ap = new("e2e_ig_ap", this);
      e2e_eg_ap = new("e2e_eg_ap", this);
      // pragma uvmx prd_create_ports begin
      // pragma uvmx prd_create_ports end
   endfunction

   // pragma uvmx prd_predict_dox begin
   /**
    * TODO Implement uvme_mstream_st_prd_c::predict()
    */
   // pragma uvmx prd_predict_dox end
   virtual task predict();
      // pragma uvmx prd_predict begin
      uvma_mstream_pkt_seq_item_c  agent_ig_trn;
      uvma_mstream_pkt_seq_item_c  agent_eg_trn;
      uvma_mstream_pkt_mon_trn_c  e2e_ig_trn;
      uvma_mstream_pkt_mon_trn_c  e2e_eg_trn;
      fork
         forever begin
            uvma_mstream_pkt_mon_trn_c  out_trn;
            `uvmx_prd_get(agent_ig_fifo, agent_ig_trn)
            `uvmx_prd_create_trn(out_trn, uvma_mstream_pkt_mon_trn_c)
            out_trn.from(agent_ig_trn);
            out_trn.matrix.copy(agent_ig_trn.matrix);
            `uvmx_prd_send(agent_ig_ap, out_trn)
         end
         forever begin
            uvma_mstream_pkt_mon_trn_c  out_trn;
            `uvmx_prd_get(agent_eg_fifo, agent_eg_trn)
            `uvmx_prd_create_trn(out_trn, uvma_mstream_pkt_mon_trn_c)
            out_trn.from(agent_eg_trn);
            out_trn.matrix.copy(agent_eg_trn.matrix);
            `uvmx_prd_send(agent_eg_ap, out_trn)
         end
         forever begin
            uvma_mstream_pkt_mon_trn_c  out_trn;
            `uvmx_prd_get(e2e_ig_fifo, e2e_ig_trn)
            out_trn.copy(e2e_ig_trn);
            `uvmx_prd_send(e2e_ig_ap, out_trn)
         end
         forever begin
            uvma_mstream_pkt_mon_trn_c  out_trn;
            `uvmx_prd_get(e2e_eg_fifo, e2e_eg_trn)
            out_trn.copy(e2e_eg_trn);
            `uvmx_prd_send(e2e_eg_ap, out_trn)
         end
      join
      // pragma uvmx prd_predict end
   endtask

   // pragma uvmx prd_methods begin
   // pragma uvmx prd_methods end

endclass


`endif // __UVME_MSTREAM_ST_PRD_SV__
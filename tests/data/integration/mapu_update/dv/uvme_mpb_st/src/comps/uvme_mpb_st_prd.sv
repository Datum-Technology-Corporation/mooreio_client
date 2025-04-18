// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_PRD_SV__
`define __UVME_MPB_ST_PRD_SV__


/**
 * Component implementing TLM prediction/checking of Matrix Peripheral Bus Agent Self-Testing.
 * @ingroup uvme_mpb_st_comps
 */
class uvme_mpb_st_prd_c extends uvmx_agent_prd_c #(
   .T_CFG  (uvme_mpb_st_cfg_c  ),
   .T_CNTXT(uvme_mpb_st_cntxt_c)
);

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mpb_access_seq_item_c)  agent_m2s_fifo; ///< Agent Main-to-Secondary Monitor Transactions to be processed.
   uvm_tlm_analysis_fifo #(uvma_mpb_access_mon_trn_c)  e2e_fifo; ///< End-to-End Monitor Transactions to be processed.
   /// @}

   /// @name Ports
   /// @{
   uvm_analysis_port #(uvma_mpb_access_mon_trn_c)  agent_m2s_ap; ///< Port producing predicted Agent Main-to-Secondary Monitor Transactions.
   uvm_analysis_port #(uvma_mpb_access_mon_trn_c)  e2e_ap; ///< Port producing predicted End-to-End Monitor Transactions.
   /// @}

   // pragma uvmx prd_fields begin
   // pragma uvmx prd_fields end


   `uvm_component_utils_begin(uvme_mpb_st_prd_c)
      // pragma uvmx prd_uvm_field_macros begin
      // pragma uvmx prd_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_prd", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      agent_m2s_fifo = new("agent_m2s_fifo", this);
      e2e_fifo = new("e2e_fifo", this);
      // pragma uvmx prd_create_fifos begin
      // pragma uvmx prd_create_fifos end
   endfunction

   /**
    * Creates TLM Ports.
    */
   virtual function void create_ports();
      agent_m2s_ap = new("agent_m2s_ap", this);
      e2e_ap = new("e2e_ap", this);
      // pragma uvmx prd_create_ports begin
      // pragma uvmx prd_create_ports end
   endfunction

   // pragma uvmx prd_predict_dox begin
   /**
    * TODO Implement uvme_mpb_st_prd_c::predict()
    */
   // pragma uvmx prd_predict_dox end
   virtual task predict();
      // pragma uvmx prd_predict begin
      fork
         forever begin
            uvma_mpb_access_seq_item_c  in_trn;
            uvma_mpb_access_mon_trn_c  out_trn;
            `uvmx_prd_get(agent_m2s_fifo, in_trn)
            `uvmx_prd_create_trn(out_trn, uvma_mpb_access_mon_trn_c)
            out_trn.copy(in_trn);
            `uvmx_prd_send(agent_m2s_ap, out_trn)
         end
         forever begin
            uvma_mpb_access_mon_trn_c  in_trn;
            uvma_mpb_access_mon_trn_c  out_trn;
            `uvmx_prd_get(e2e_fifo, in_trn)
            `uvmx_prd_create_trn(out_trn, uvma_mpb_access_mon_trn_c)
            out_trn.copy(in_trn);
            `uvmx_prd_send(e2e_ap, out_trn)
         end
      join
      // pragma uvmx prd_predict end
   endtask

   // pragma uvmx prd_methods begin
   // pragma uvmx prd_methods end

endclass


`endif // __UVME_MPB_ST_PRD_SV__
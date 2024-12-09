// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_PRD_SV__
`define __UVME_MAPU_B_PRD_SV__


/**
 * Component implementing TLM scoreboard prediction of Matrix APU Block behavior.
 * @ingroup uvme_mapu_b_comps
 */
class uvme_mapu_b_prd_c extends uvmx_block_sb_prd_c #(
   .T_CFG  (uvme_mapu_b_cfg_c  ),
   .T_CNTXT(uvme_mapu_b_cntxt_c)
);

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mapu_b_mon_trn_c)  fifo; ///< Queue of monitor transactions
   /// @}

   /// @name Ports
   /// @{
   uvm_analysis_port #(uvma_mapu_b_mon_trn_c)  ap; ///< Port producing predicted data plane output transactions
   /// @}

   // pragma uvmx prd_fields begin
   // pragma uvmx prd_fields end


   `uvm_component_utils_begin(uvme_mapu_b_prd_c)
      // pragma uvmx prd_uvm_field_macros begin
      // pragma uvmx prd_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_prd", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx prd_constructor begin
      // pragma uvmx prd_constructor end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      fifo = new("fifo", this);
      // pragma uvmx prd_create_fifos begin
      // pragma uvmx prd_create_fifos end
   endfunction

   /**
    * Creates TLM Ports.
    */
   virtual function void create_ports();
      ap = new("ap", this);
      // pragma uvmx prd_create_ports begin
      // pragma uvmx prd_create_ports end
   endfunction

   /**
    * TODO Describe uvme_mapu_b_prd_c::predict()
    */
   virtual task predict();
      // pragma uvmx prd_predict begin
      uvma_mapu_b_mon_trn_c  in_trn, out_trn;
      `uvmx_prd_get(fifo, in_trn)
      out_trn.from(in_trn);
      // TODO Implement uvme_mapu_b_prd_c::predict()
      //      Ex: out_trn = uvma_mapu_b_mon_trn_c::type_id::create("out_trn");
      //          out_trn.dir_in = 0;
      //          out_trn.abc = in_trn.abc*2;
      `uvmx_prd_send(ap, out_trn)
      // pragma uvmx prd_predict end
   endtask

   // pragma uvmx prd_methods begin
   // pragma uvmx prd_methods end

endclass


`endif // __UVME_MAPU_B_PRD_SV__
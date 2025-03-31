// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_PRD_SV__
`define __UVME_MAPU_B_PRD_SV__


/**
 * Component implementing TLM scoreboard prediction of Matrix APU DUT behavior.
 * @ingroup uvme_mapu_b_comps
 */
class uvme_mapu_b_prd_c extends uvmx_block_sb_prd_c #(
   .T_CFG  (uvme_mapu_b_cfg_c  ),
   .T_CNTXT(uvme_mapu_b_cntxt_c)
);

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mapu_b_ig_mon_trn_c)  ig_fifo; ///< Ingress Monitor Transactions to be processed.
   /// @}

   /// @name Ports
   /// @{
   uvm_analysis_port #(uvma_mapu_b_eg_mon_trn_c)  eg_ap; ///< Port producing predicted Egress Monitor Transactions.
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
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      ig_fifo = new("ig_fifo", this);
      // pragma uvmx prd_create_fifos begin
      // pragma uvmx prd_create_fifos end
   endfunction

   /**
    * Creates TLM Ports.
    */
   virtual function void create_ports();
      eg_ap = new("eg_ap", this);
      // pragma uvmx prd_create_ports begin
      // pragma uvmx prd_create_ports end
   endfunction

   // pragma uvmx prd_predict_dox begin
   /**
    * TODO Implement uvme_mapu_b_prd_c::predict()
    */
   // pragma uvmx prd_predict_dox end
   virtual task predict();
      // pragma uvmx prd_predict begin
      uvma_mapu_b_ig_mon_trn_c  ig_a_trn, ig_b_trn;
      uvma_mapu_b_eg_mon_trn_c  eg_trn;
      bit overflow = 0;
      // 1.
      `uvmx_prd_get(ig_fifo, ig_a_trn)
      `uvmx_prd_get(ig_fifo, ig_b_trn)
      `uvmx_prd_create_trn(eg_trn, uvma_mapu_b_eg_mon_trn_c)
      eg_trn.from(ig_a_trn);
      eg_trn.from(ig_b_trn);
      // 2.
      case (ig_b_trn.op)
         UVMA_MAPU_B_OP_ADD : eg_trn.matrix = ig_a_trn.matrix.add     (ig_b_trn.matrix);
         UVMA_MAPU_B_OP_MULT: eg_trn.matrix = ig_a_trn.matrix.multiply(ig_b_trn.matrix);
         default: begin
            `uvm_error("MAPU_B_PRD", $sformatf("Invalid op '%s'. Dropping:\n%s", ig_b_trn.op.name(), ig_b_trn.sprint()))
            eg_trn.set_may_drop(1);
         end
      endcase
      // 3.
      if (!eg_trn.get_may_drop()) begin
         foreach (eg_trn.matrix.mi[ii]) begin
            foreach (eg_trn.matrix.mi[ii][jj]) begin
               if (cfg.data_width == 32) begin
                  if (eg_trn.matrix.mi[ii][jj] > 32'h7FFF_FFFF) begin
                     overflow = 1;
                  end
               end
               else if (cfg.data_width == 64) begin
                  if (eg_trn.matrix.mi[ii][jj] < 0) begin
                     overflow = 1;
                  end
               end
               if (overflow) begin
                  eg_trn.overflow = 1;
                  eg_trn.set_error(1);
                  cntxt.prd_overflow_count++;
                  break;
               end
            end
         end
         // 4.
         `uvmx_prd_send(eg_ap, eg_trn);
      end
      // pragma uvmx prd_predict end
   endtask

   // pragma uvmx prd_methods begin
   // pragma uvmx prd_methods end

endclass


`endif // __UVME_MAPU_B_PRD_SV__
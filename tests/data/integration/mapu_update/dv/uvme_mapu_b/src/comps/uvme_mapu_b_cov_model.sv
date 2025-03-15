// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_COV_MODEL_SV__
`define __UVME_MAPU_B_COV_MODEL_SV__


/**
 * Component encapsulating Matrix APU Block's functional coverage model.
 * @ingroup uvme_mapu_b_comps
 */
class uvme_mapu_b_cov_model_c extends uvmx_block_sb_env_cov_model_c #(
   .T_CFG  (uvme_mapu_b_cfg_c  ),
   .T_CNTXT(uvme_mapu_b_cntxt_c)
);

   /// @name Objects
   /// @{
   uvma_mapu_b_seq_item_c      seq_item    ; ///< Sequence Item being sampled.
   uvma_mapu_b_mon_trn_c       in_mon_trn  ; ///< Input Monitor Transaction being sampled.
   uvma_mapu_b_mon_trn_c       out_mon_trn ; ///< Output Monitor Transaction being sampled.
   uvma_mapu_b_dpi_seq_item_c   dpi_seq_item; ///< Data Plane Input Sequence Item being sampled.
   uvma_mapu_b_dpo_seq_item_c   dpo_seq_item; ///< Data Plane Output Sequence Item being sampled.
   uvma_mapu_b_cp_seq_item_c   cp_seq_item; ///< Control Plane Sequence Item being sampled.
   uvma_mapu_b_dpi_mon_trn_c    dpi_mon_trn; ///< Data Plane Input Monitor Transaction being sampled.
   uvma_mapu_b_dpo_mon_trn_c    dpo_mon_trn; ///< Data Plane Output Monitor Transaction being sampled.
   uvma_mapu_b_cp_mon_trn_c    cp_mon_trn; ///< Control Plane Monitor Transaction being sampled.
   /// @}

   /// @name FIFOs
   /// @{
   uvm_tlm_analysis_fifo #(uvma_mapu_b_seq_item_c    )  seq_item_fifo    ; ///< Input FIFO for Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_mon_trn_c     )  in_mon_trn_fifo  ; ///< Input FIFO for Input Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_mon_trn_c     )  out_mon_trn_fifo ; ///< Input FIFO for Output Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpi_seq_item_c)  dpi_seq_item_fifo; ///< Input FIFO for Data Plane Input Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpo_seq_item_c)  dpo_seq_item_fifo; ///< Input FIFO for Data Plane Output Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_cp_seq_item_c)  cp_seq_item_fifo; ///< Input FIFO for Control Plane Sequence Items.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpi_mon_trn_c)  dpi_mon_trn_fifo; ///< Input FIFO for Data Plane Input Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_dpo_mon_trn_c)  dpo_mon_trn_fifo; ///< Input FIFO for Data Plane Output Monitor Transactions.
   uvm_tlm_analysis_fifo #(uvma_mapu_b_cp_mon_trn_c)  cp_mon_trn_fifo; ///< Input FIFO for Control Plane Monitor Transactions.
   /// @}

   // pragma uvmx cov_model_fields begin
   // pragma uvmx cov_model_fields end


   `uvm_component_utils_begin(uvme_mapu_b_cov_model_c)
      // pragma uvmx cov_model_uvm_field_macros begin
      // pragma uvmx cov_model_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Environment configuration functional coverage.
    */
   covergroup mapu_b_cfg_cg;
      // pragma uvmx cov_model_cfg_cg begin
      data_width_cp : coverpoint cfg.data_width {
         bins valid[] = {32,64};
      }
      out_drv_ton_pct_cp : coverpoint cfg.agent_cfg.out_drv_ton_pct {
         bins valid[] = {[1:100]};
      }
      // pragma uvmx cov_model_cfg_cg end
   endgroup

   /**
    * Environment context functional coverage.
    */
   covergroup mapu_b_cntxt_cg;
      // pragma uvmx cov_model_cntxt_cg begin
      prd_overflow_count_cp : coverpoint cntxt.prd_overflow_count {
         bins at_least_one[] = {[1:$]};
      }
      // pragma uvmx cov_model_cntxt_cg end
   endgroup

   /**
    * Sequence Item functional coverage.
    */
   covergroup mapu_b_seq_item_cg;
      // pragma uvmx cov_model_seq_item_cg begin
      op_cp : coverpoint seq_item.op;
      coverpoint seq_item.ton_pct {
         bins valid[] = {[1:100]};
      }
      // pragma uvmx cov_model_seq_item_cg end
   endgroup

   /**
    * Input Monitor Transaction functional coverage.
    */
   covergroup mapu_b_in_mon_trn_cg;
      // pragma uvmx cov_model_in_mon_trn_cg begin
      // pragma uvmx cov_model_in_mon_trn_cg end
   endgroup

   /**
    * Output Monitor Transaction functional coverage.
    */
   covergroup mapu_b_out_mon_trn_cg;
      // pragma uvmx cov_model_out_mon_trn_cg begin
      overflow_cp : coverpoint out_mon_trn.overflow;
      // pragma uvmx cov_model_out_mon_trn_cg end
   endgroup

   /**
    * Data Plane Input Sequence Item functional coverage.
    */
   covergroup mapu_b_dpi_seq_item_cg;
      // pragma uvmx cov_model_dpi_seq_item_cg begin
      // pragma uvmx cov_model_dpi_seq_item_cg end
   endgroup
   /**
    * Data Plane Output Sequence Item functional coverage.
    */
   covergroup mapu_b_dpo_seq_item_cg;
      // pragma uvmx cov_model_dpo_seq_item_cg begin
      // pragma uvmx cov_model_dpo_seq_item_cg end
   endgroup
   /**
    * Control Plane Sequence Item functional coverage.
    */
   covergroup mapu_b_cp_seq_item_cg;
      // pragma uvmx cov_model_cp_seq_item_cg begin
      i_op_cp : coverpoint cp_seq_item.i_op;
      // pragma uvmx cov_model_cp_seq_item_cg end
   endgroup

   /**
    * Data Plane Input Monitor Transaction functional coverage.
    */
   covergroup mapu_b_dpi_mon_trn_cg;
      // pragma uvmx cov_model_dpi_mon_trn_cg begin
      // pragma uvmx cov_model_dpi_mon_trn_cg end
   endgroup
   /**
    * Data Plane Output Monitor Transaction functional coverage.
    */
   covergroup mapu_b_dpo_mon_trn_cg;
      // pragma uvmx cov_model_dpo_mon_trn_cg begin
      // pragma uvmx cov_model_dpo_mon_trn_cg end
   endgroup
   /**
    * Control Plane Monitor Transaction functional coverage.
    */
   covergroup mapu_b_cp_mon_trn_cg;
      // pragma uvmx cov_model_cp_mon_trn_cg begin
      o_of_cp : coverpoint cp_mon_trn.o_of;
      // pragma uvmx cov_model_cp_mon_trn_cg end
   endgroup

   // pragma uvmx cov_model_covergroups begin
   // pragma uvmx cov_model_covergroups end

   /**
    * Creates covergroups.
    */
   function new(string name="uvme_mapu_b_cov_model", uvm_component parent=null);
      super.new(name, parent);
      mapu_b_cfg_cg   = new();
      mapu_b_cntxt_cg = new();
      mapu_b_seq_item_cg     = new();
      mapu_b_in_mon_trn_cg   = new();
      mapu_b_out_mon_trn_cg  = new();
      mapu_b_dpi_seq_item_cg = new();
      mapu_b_dpo_seq_item_cg = new();
      mapu_b_cp_seq_item_cg = new();
      mapu_b_dpi_mon_trn_cg = new();
      mapu_b_dpo_mon_trn_cg = new();
      mapu_b_cp_mon_trn_cg = new();
      // pragma uvmx cov_model_constructor begin
      // pragma uvmx cov_model_constructor end
   endfunction

   /**
    * Creates TLM FIFOs.
    */
   virtual function void create_fifos();
      seq_item_fifo     = new("seq_item_fifo"    , this);
      in_mon_trn_fifo   = new("in_mon_trn_fifo"  , this);
      out_mon_trn_fifo  = new("out_mon_trn_fifo" , this);
      dpi_seq_item_fifo = new("dpi_seq_item_fifo", this);
      dpo_seq_item_fifo = new("dpo_seq_item_fifo", this);
      cp_seq_item_fifo = new("cp_seq_item_fifo", this);
      dpi_mon_trn_fifo = new("dpi_mon_trn_fifo", this);
      dpo_mon_trn_fifo = new("dpo_mon_trn_fifo", this);
      cp_mon_trn_fifo = new("cp_mon_trn_fifo", this);
      // pragma uvmx cov_model_create_fifos begin
      // pragma uvmx cov_model_create_fifos end
   endfunction

   /// @name Sampling functions
   /// @{
   virtual function void sample_cfg  (); mapu_b_cfg_cg  .sample(); endfunction
   virtual function void sample_cntxt(); mapu_b_cntxt_cg.sample(); endfunction
   virtual task sample_tlm();
      fork
         forever begin
            seq_item_fifo.get(seq_item);
            mapu_b_seq_item_cg.sample();
         end
         forever begin
            in_mon_trn_fifo.get(in_mon_trn);
            mapu_b_in_mon_trn_cg.sample();
         end
         forever begin
            out_mon_trn_fifo.get(out_mon_trn);
            mapu_b_out_mon_trn_cg.sample();
         end
         forever begin
            dpi_seq_item_fifo.get(dpi_seq_item);
            mapu_b_dpi_seq_item_cg.sample();
         end
         forever begin
            dpo_seq_item_fifo.get(dpo_seq_item);
            mapu_b_dpo_seq_item_cg.sample();
         end
         forever begin
            cp_seq_item_fifo.get(cp_seq_item);
            mapu_b_cp_seq_item_cg.sample();
         end
         forever begin
            dpi_mon_trn_fifo.get(dpi_mon_trn);
            mapu_b_dpi_mon_trn_cg.sample();
         end
         forever begin
            dpo_mon_trn_fifo.get(dpo_mon_trn);
            mapu_b_dpo_mon_trn_cg.sample();
         end
         forever begin
            cp_mon_trn_fifo.get(cp_mon_trn);
            mapu_b_cp_mon_trn_cg.sample();
         end
      join
   endtask
   /// @}

   // pragma uvmx cov_model_methods begin
   // pragma uvmx cov_model_methods end

endclass


`endif // __UVME_MAPU_B_COV_MODEL_SV__
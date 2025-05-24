// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_BASE_SEQ_SV__
`define __UVME_MPB_ST_BASE_SEQ_SV__


/**
 * Abstract Sequence from which all Matrix Peripheral Bus Agent Self-Test Environment Sequences extend.
 * @ingroup uvme_mpb_st_seq
 */
class uvme_mpb_st_base_seq_c extends uvmx_agent_env_seq_c #(
   .T_CFG  (uvme_mpb_st_cfg_c  ),
   .T_CNTXT(uvme_mpb_st_cntxt_c),
   .T_SQR  (uvme_mpb_st_sqr_c  )
);

   // pragma uvmx base_seq_fields begin
   // pragma uvmx base_seq_fields end


   `uvm_object_utils_begin(uvme_mpb_st_base_seq_c)
      // pragma uvmx base_seq_uvm_field_macros begin
      // pragma uvmx base_seq_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx base_seq_constraints begin
   // pragma uvmx base_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_base_seq");
      super.new(name);
   endfunction

   // pragma uvmx base_seq_methods begin
   // pragma uvmx base_seq_methods end

endclass


`endif // __UVME_MPB_ST_BASE_SEQ_SV__
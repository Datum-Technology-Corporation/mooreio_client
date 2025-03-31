// Copyright 2025 
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_TDEFS_SV__
`define __UVME_MAPU_B_TDEFS_SV__


/**
 * Scoreboard specialization for Egress.
 */
typedef uvmx_sb_simplex_c #(
   .T_EXP_TRN(uvma_mapu_b_eg_mon_trn_c),
   .T_ACT_TRN(uvma_mapu_b_eg_mon_trn_c)
) uvme_mapu_b_egress_sb_c;


// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVME_MAPU_B_TDEFS_SV__
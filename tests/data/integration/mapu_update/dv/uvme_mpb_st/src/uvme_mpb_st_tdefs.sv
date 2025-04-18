// Copyright 2025 
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_TDEFS_SV__
`define __UVME_MPB_ST_TDEFS_SV__


/**
 * Scoreboard specialization for Agent Main-to-Secondary.
 */
typedef uvmx_sb_simplex_c #(
   .T_EXP_TRN(uvma_mpb_access_mon_trn_c),
   .T_ACT_TRN(uvma_mpb_access_mon_trn_c)
) uvme_mpb_st_agent_m2s_sb_c;
/**
 * Scoreboard specialization for End-to-end.
 */
typedef uvmx_sb_simplex_c #(
   .T_EXP_TRN(uvma_mpb_access_mon_trn_c),
   .T_ACT_TRN(uvma_mpb_access_mon_trn_c)
) uvme_mpb_st_e2e_sb_c;


// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVME_MPB_ST_TDEFS_SV__
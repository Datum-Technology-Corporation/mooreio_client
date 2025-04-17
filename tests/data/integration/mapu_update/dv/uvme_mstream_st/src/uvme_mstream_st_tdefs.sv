// Copyright 2025 
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_TDEFS_SV__
`define __UVME_MSTREAM_ST_TDEFS_SV__


/**
 * Scoreboard specialization for Agent Ingress.
 */
typedef uvmx_sb_simplex_c #(
   .T_EXP_TRN(uvma_mstream_pkt_mon_trn_c),
   .T_ACT_TRN(uvma_mstream_pkt_mon_trn_c)
) uvme_mstream_st_agent_ig_sb_c;
/**
 * Scoreboard specialization for Agent Egress.
 */
typedef uvmx_sb_simplex_c #(
   .T_EXP_TRN(uvma_mstream_pkt_mon_trn_c),
   .T_ACT_TRN(uvma_mstream_pkt_mon_trn_c)
) uvme_mstream_st_agent_eg_sb_c;
/**
 * Scoreboard specialization for End-to-end Ingress.
 */
typedef uvmx_sb_simplex_c #(
   .T_EXP_TRN(uvma_mstream_pkt_mon_trn_c),
   .T_ACT_TRN(uvma_mstream_pkt_mon_trn_c)
) uvme_mstream_st_e2e_eg_sb_c;
/**
 * Scoreboard specialization for End-to-end Egress.
 */
typedef uvmx_sb_simplex_c #(
   .T_EXP_TRN(uvma_mstream_pkt_mon_trn_c),
   .T_ACT_TRN(uvma_mstream_pkt_mon_trn_c)
) uvme_mstream_st_e2e_ig_sb_c;


// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVME_MSTREAM_ST_TDEFS_SV__
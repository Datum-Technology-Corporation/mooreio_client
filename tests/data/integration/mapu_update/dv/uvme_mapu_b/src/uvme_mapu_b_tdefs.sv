// Copyright 2025 
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_TDEFS_SV__
`define __UVME_MAPU_B_TDEFS_SV__


/**
 * FSM state space for DUT.
 */
typedef enum {
   UVME_mapu_B_FSM_INIT ///< State out of reset
} uvme_mapu_b_fsm_enum;


/**
 * Scoreboard specialization for Data Plane Output Monitor Transactions.
 */
typedef uvmx_sb_simplex_c #(
   .T_ACT_TRN(uvma_mapu_b_mon_trn_c)
) uvme_mapu_b_sb_c;


// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVME_MAPU_B_TDEFS_SV__
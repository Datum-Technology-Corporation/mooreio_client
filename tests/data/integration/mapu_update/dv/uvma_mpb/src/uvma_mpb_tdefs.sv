// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_TDEFS_SV__
`define __UVMA_MPB_TDEFS_SV__


/**
 * Register predictor specialization.
 */
typedef uvmx_reg_predictor_c #(
   .T_MON_TRN (uvma_mpb_access_mon_trn_c),
   .T_SEQ_ITEM(uvma_mpb_access_seq_item_c)
) uvma_mpb_reg_predictor_c;

/**
 * Driving modes for uvma_mpb_agent_c when active.
 */
typedef enum {
   UVMA_MPB_DRV_MODE_MAIN, ///< Drives MAIN
   UVMA_MPB_DRV_MODE_SEC  ///< Drives SEC
} uvma_mpb_drv_mode_enum;

/**
 * Operation
 */
typedef enum bit {
   UVMA_MPB_OP_READ = 0, ///< Read
   UVMA_MPB_OP_WRITE = 1 ///< Write
} uvma_mpb_op_enum;

/// @name Logic vectors
/// @{
typedef logic  uvma_mpb_vld_t; ///< Data valid logic vector
typedef logic  uvma_mpb_rdy_t; ///< Data ready logic vector
typedef logic  uvma_mpb_wr_t; ///< Write logic vector
typedef logic [(`UVMA_MPB_DATA_WIDTH_MAX-1):0]  uvma_mpb_rdata_t; ///< Read Data logic vector
typedef logic [(`UVMA_MPB_DATA_WIDTH_MAX-1):0]  uvma_mpb_wdata_t; ///< Write Data logic vector
typedef logic [(`UVMA_MPB_ADDR_WIDTH_MAX-1):0]  uvma_mpb_addr_t; ///< Address logic vector
/// @}

// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVMA_MPB_TDEFS_SV__
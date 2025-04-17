// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_TDEFS_SV__
`define __UVMA_MSTREAM_TDEFS_SV__



/**
 * Driving modes for uvma_mstream_agent_c when active.
 */
typedef enum {
   UVMA_MSTREAM_DRV_MODE_HOST, ///< Drives HOST
   UVMA_MSTREAM_DRV_MODE_CARD  ///< Drives CARD
} uvma_mstream_drv_mode_enum;

/**
 * Direction
 */
typedef enum bit {
   UVMA_MSTREAM_DIR_IG = 0, ///< Ingress
   UVMA_MSTREAM_DIR_EG = 1 ///< Egress
} uvma_mstream_dir_enum;

/// @name Logic vectors
/// @{
typedef logic  uvma_mstream_ig_vld_t; ///< Ingress Valid logic vector
typedef logic  uvma_mstream_ig_rdy_t; ///< Ingress Ready logic vector
typedef logic [(`UVMA_MSTREAM_DATA_WIDTH_MAX-1):0]  uvma_mstream_ig_r0_t; ///< Ingress Data Row 0 logic vector
typedef logic [(`UVMA_MSTREAM_DATA_WIDTH_MAX-1):0]  uvma_mstream_ig_r1_t; ///< Ingress Data Row 1 logic vector
typedef logic [(`UVMA_MSTREAM_DATA_WIDTH_MAX-1):0]  uvma_mstream_ig_r2_t; ///< Ingress Data Row 2 logic vector
typedef logic  uvma_mstream_eg_vld_t; ///< Egress Valid logic vector
typedef logic  uvma_mstream_eg_rdy_t; ///< Egress Ready logic vector
typedef logic [(`UVMA_MSTREAM_DATA_WIDTH_MAX-1):0]  uvma_mstream_eg_r0_t; ///< Egress Data Row 0 logic vector
typedef logic [(`UVMA_MSTREAM_DATA_WIDTH_MAX-1):0]  uvma_mstream_eg_r1_t; ///< Egress Data Row 1 logic vector
typedef logic [(`UVMA_MSTREAM_DATA_WIDTH_MAX-1):0]  uvma_mstream_eg_r2_t; ///< Egress Data Row 2 logic vector
/// @}

// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVMA_MSTREAM_TDEFS_SV__
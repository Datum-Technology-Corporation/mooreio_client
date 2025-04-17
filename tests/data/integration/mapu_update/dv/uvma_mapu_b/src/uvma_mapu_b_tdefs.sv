// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_TDEFS_SV__
`define __UVMA_MAPU_B_TDEFS_SV__


/**
 * Operation
 */
typedef enum bit {
   UVMA_MAPU_B_OP_ADD = 0, ///< Addition
   UVMA_MAPU_B_OP_MULT = 1 ///< Multiplication
} uvma_mapu_b_op_enum;

/// @name Logic Vectors
/// @{
typedef logic  uvma_mapu_b_i_vld_t; ///< Input Valid logic vector
typedef logic  uvma_mapu_b_o_rdy_t; ///< Input data Ready logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r0_t; ///< Input Data Row 0 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r1_t; ///< Input Data Row 1 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r2_t; ///< Input Data Row 2 logic vector
typedef logic  uvma_mapu_b_o_vld_t; ///< Output Valid logic vector
typedef logic  uvma_mapu_b_i_rdy_t; ///< Output data Ready logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r0_t; ///< Output Data Row 0 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r1_t; ///< Output Data Row 1 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r2_t; ///< Output Data Row 2 logic vector
typedef logic  uvma_mapu_b_i_en_t; ///< Block enable logic vector
typedef logic  uvma_mapu_b_i_op_t; ///< Matrix Operation logic vector
typedef logic  uvma_mapu_b_o_of_t; ///< Overflow flag logic vector
/// @}

// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVMA_MAPU_B_TDEFS_SV__
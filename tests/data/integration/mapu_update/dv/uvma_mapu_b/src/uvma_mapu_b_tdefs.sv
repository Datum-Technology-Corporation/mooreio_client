// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_TDEFS_SV__
`define __UVMA_MAPU_B_TDEFS_SV__


/// @name Logic vectors
/// @{
typedef logic  uvma_mapu_b_i_vld_l_t; ///< Input Valid logic vector
typedef logic  uvma_mapu_b_o_rdy_l_t; ///< Input data Ready logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r0_l_t; ///< Input Data Row 0 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r1_l_t; ///< Input Data Row 1 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r2_l_t; ///< Input Data Row 2 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r3_l_t; ///< Input Data Row 3 logic vector
typedef logic  uvma_mapu_b_o_vld_l_t; ///< Output Valid logic vector
typedef logic  uvma_mapu_b_i_rdy_l_t; ///< Output data Ready logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r0_l_t; ///< Output Data Row 0 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r1_l_t; ///< Output Data Row 1 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r2_l_t; ///< Output Data Row 2 logic vector
typedef logic [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r3_l_t; ///< Output Data Row 3 logic vector
typedef logic  uvma_mapu_b_i_en_l_t; ///< Block enable logic vector
typedef logic  uvma_mapu_b_i_op_l_t; ///< Matrix Operation logic vector
typedef logic  uvma_mapu_b_o_of_l_t; ///< Overflow flag logic vector
/// @}

/// @name Bit vectors
/// @{
typedef bit  uvma_mapu_b_i_vld_b_t; ///< Input Valid bit vector
typedef bit  uvma_mapu_b_o_rdy_b_t; ///< Input data Ready bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r0_b_t; ///< Input Data Row 0 bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r1_b_t; ///< Input Data Row 1 bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r2_b_t; ///< Input Data Row 2 bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_i_r3_b_t; ///< Input Data Row 3 bit vector
typedef bit  uvma_mapu_b_o_vld_b_t; ///< Output Valid bit vector
typedef bit  uvma_mapu_b_i_rdy_b_t; ///< Output data Ready bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r0_b_t; ///< Output Data Row 0 bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r1_b_t; ///< Output Data Row 1 bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r2_b_t; ///< Output Data Row 2 bit vector
typedef bit [(`UVMA_MAPU_B_DATA_WIDTH_MAX-1):0]  uvma_mapu_b_o_r3_b_t; ///< Output Data Row 3 bit vector
typedef bit  uvma_mapu_b_i_en_b_t; ///< Block enable bit vector
typedef bit  uvma_mapu_b_i_op_b_t; ///< Matrix Operation bit vector
typedef bit  uvma_mapu_b_o_of_b_t; ///< Overflow flag bit vector
/// @}

// pragma uvmx tdefs begin
// pragma uvmx tdefs end


`endif // __UVMA_MAPU_B_TDEFS_SV__
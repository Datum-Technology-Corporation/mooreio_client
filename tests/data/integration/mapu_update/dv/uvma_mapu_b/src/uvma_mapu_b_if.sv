// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_IF_SV__
`define __UVMA_MAPU_B_IF_SV__


/**
 * Encapsulates all signals and clocking of Matrix APU Block interface.
 * Assertions must be captured within uvma_mapu_b_if_chkr.
 * @ingroup uvma_mapu_b_pkg
 */
interface uvma_mapu_b_if #(
   parameter int unsigned  DATA_WIDTH = `UVMA_MAPU_B_DATA_WIDTH_MAX
) (
   input  clk, ///< Clock: System clock
   input  reset_n ///< Reset: System reset
);

   /// @name Data Plane Input signals
   /// @{
   wire  i_vld; ///< Input Valid: Input data valid
   wire  o_rdy; ///< Input data Ready: Input data ready
   wire [(DATA_WIDTH-1):0]  i_r0; ///< Input Data Row 0: Input data row 0
   wire [(DATA_WIDTH-1):0]  i_r1; ///< Input Data Row 1: Input data row 1
   wire [(DATA_WIDTH-1):0]  i_r2; ///< Input Data Row 2: Input data row 2
   /// @}

   /// @name Data Plane Output signals
   /// @{
   wire  o_vld; ///< Output Valid: Output data valid
   wire  i_rdy; ///< Output data Ready: Output data ready
   wire [(DATA_WIDTH-1):0]  o_r0; ///< Output Data Row 0: Output data row 0
   wire [(DATA_WIDTH-1):0]  o_r1; ///< Output Data Row 1: Output data row 1
   wire [(DATA_WIDTH-1):0]  o_r2; ///< Output Data Row 2: Output data row 2
   /// @}

   /// @name Control Plane signals
   /// @{
   wire  i_en; ///< Block enable: Block enable
   wire  i_op; ///< Matrix Operation: 0: Add, 1: Multiply
   wire  o_of; ///< Overflow flag
   /// @}


   /// @name Used by uvma_mapu_b_dpi_mon_c
   /// @{
   clocking dpi_mon_cb @(posedge clk);
      input i_vld, o_rdy, i_r0, i_r1, i_r2;
   endclocking
   modport dpi_mon_mp (clocking dpi_mon_cb);
   /// @}

   /// @name Used by uvma_mapu_b_dpi_drv_c
   /// @{
   clocking dpi_drv_cb @(posedge clk);
      output i_vld, i_r0, i_r1, i_r2;
      input o_rdy;
   endclocking
   modport dpi_drv_mp (clocking dpi_drv_cb);
   /// @}
   /// @name Used by uvma_mapu_b_dpo_mon_c
   /// @{
   clocking dpo_mon_cb @(posedge clk);
      input o_vld, i_rdy, o_r0, o_r1, o_r2;
   endclocking
   modport dpo_mon_mp (clocking dpo_mon_cb);
   /// @}

   /// @name Used by uvma_mapu_b_dpo_drv_c
   /// @{
   clocking dpo_drv_cb @(posedge clk);
      output i_rdy;
      input o_vld, o_r0, o_r1, o_r2;
   endclocking
   modport dpo_drv_mp (clocking dpo_drv_cb);
   /// @}
   /// @name Used by uvma_mapu_b_cp_mon_c
   /// @{
   clocking cp_mon_cb @(posedge clk);
      input i_en, i_op, o_of;
   endclocking
   modport cp_mon_mp (clocking cp_mon_cb);
   /// @}

   /// @name Used by uvma_mapu_b_cp_drv_c
   /// @{
   clocking cp_drv_cb @(posedge clk);
      output i_en, i_op;
      input o_of;
   endclocking
   modport cp_drv_mp (clocking cp_drv_cb);
   /// @}


   /**
    * Sets default values for input signals.
    */
   initial begin
      dpi_drv_mp.dpi_drv_cb.i_vld <= 0;
      dpi_drv_mp.dpi_drv_cb.i_r0 <= 0;
      dpi_drv_mp.dpi_drv_cb.i_r1 <= 0;
      dpi_drv_mp.dpi_drv_cb.i_r2 <= 0;
      dpo_drv_mp.dpo_drv_cb.i_rdy <= 0;
      cp_drv_mp.cp_drv_cb.i_en <= 0;
      cp_drv_mp.cp_drv_cb.i_op <= 0;
   end


   // pragma uvmx interface begin
   // pragma uvmx interface end

endinterface


`endif // __UVMA_MAPU_B_IF_SV__
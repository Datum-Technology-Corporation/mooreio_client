// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_IF_SV__
`define __UVMA_MSTREAM_IF_SV__


/**
 * Encapsulates all signals and clocking of Matrix Stream Interface Agent interface.
 * Assertions must be captured within uvma_mstream_if_chkr.
 * @ingroup uvma_mstream_pkg
 */
interface uvma_mstream_if #(
   parameter int unsigned DATA_WIDTH = `UVMA_MSTREAM_DATA_WIDTH_MAX
) (
   input  sys_clk, ///< System: System clock
   input  reset_n ///< Reset: System reset
);

   /// @name Ingress signals
   /// @{
   wire  ig_vld; ///< Ingress Valid: Ingress data valid
   wire  ig_rdy; ///< Ingress Ready: Ingress receiver ready
   wire [(DATA_WIDTH-1):0]  ig_r0; ///< Ingress Data Row 0: Ingress data row 0
   wire [(DATA_WIDTH-1):0]  ig_r1; ///< Ingress Data Row 1: Ingress data row 1
   wire [(DATA_WIDTH-1):0]  ig_r2; ///< Ingress Data Row 2: Ingress data row 2
   /// @}
   /// @name Egress signals
   /// @{
   wire  eg_vld; ///< Egress Valid: Egress data valid
   wire  eg_rdy; ///< Egress Ready: Egress receiver ready
   wire [(DATA_WIDTH-1):0]  eg_r0; ///< Egress Data Row 0: Egress data row 0
   wire [(DATA_WIDTH-1):0]  eg_r1; ///< Egress Data Row 1: Egress data row 1
   wire [(DATA_WIDTH-1):0]  eg_r2; ///< Egress Data Row 2: Egress data row 2
   /// @}


   /// @name Used by uvma_mstream_ig_mon_c
   /// @{
   clocking ig_mon_cb @(posedge sys_clk);
      input ig_vld, ig_rdy, ig_r0, ig_r1, ig_r2;
   endclocking
   modport ig_mon_mp (clocking ig_mon_cb);
   /// @}

   /// @name Used by uvma_mstream_host_ig_drv_c
   /// @{
   clocking host_ig_drv_cb @(posedge sys_clk);
      output ig_vld, ig_r0, ig_r1, ig_r2;
      input ig_rdy;
   endclocking
   modport host_ig_drv_mp (clocking host_ig_drv_cb);
   /// @}

   /// @name Used by uvma_mstream_card_ig_drv_c
   /// @{
   clocking card_ig_drv_cb @(posedge sys_clk);
      output ig_rdy;
      input ig_vld, ig_r0, ig_r1, ig_r2;
   endclocking
   modport card_ig_drv_mp (clocking card_ig_drv_cb);
   /// @}
   /// @name Used by uvma_mstream_eg_mon_c
   /// @{
   clocking eg_mon_cb @(posedge sys_clk);
      input eg_vld, eg_rdy, eg_r0, eg_r1, eg_r2;
   endclocking
   modport eg_mon_mp (clocking eg_mon_cb);
   /// @}

   /// @name Used by uvma_mstream_host_eg_drv_c
   /// @{
   clocking host_eg_drv_cb @(posedge sys_clk);
      output eg_rdy;
      input eg_vld, eg_r0, eg_r1, eg_r2;
   endclocking
   modport host_eg_drv_mp (clocking host_eg_drv_cb);
   /// @}

   /// @name Used by uvma_mstream_card_eg_drv_c
   /// @{
   clocking card_eg_drv_cb @(posedge sys_clk);
      output eg_vld, eg_r0, eg_r1, eg_r2;
      input eg_rdy;
   endclocking
   modport card_eg_drv_mp (clocking card_eg_drv_cb);
   /// @}


   /// @name Accessors
   /// @{
   `uvmx_if_reset(reset_n)
   `uvmx_if_cb(ig_mon_mp, ig_mon_cb)
   `uvmx_if_cb(host_ig_drv_mp, host_ig_drv_cb)
   `uvmx_if_cb(card_ig_drv_mp, card_ig_drv_cb)
   `uvmx_if_cb(eg_mon_mp, eg_mon_cb)
   `uvmx_if_cb(host_eg_drv_mp, host_eg_drv_cb)
   `uvmx_if_cb(card_eg_drv_mp, card_eg_drv_cb)
   `uvmx_if_signal_out(ig_vld, , ig_mon_mp.ig_mon_cb, host_ig_drv_mp.host_ig_drv_cb)
   `uvmx_if_signal_out(ig_r0,  [(DATA_WIDTH-1):0], ig_mon_mp.ig_mon_cb, host_ig_drv_mp.host_ig_drv_cb)
   `uvmx_if_signal_out(ig_r1,  [(DATA_WIDTH-1):0], ig_mon_mp.ig_mon_cb, host_ig_drv_mp.host_ig_drv_cb)
   `uvmx_if_signal_out(ig_r2,  [(DATA_WIDTH-1):0], ig_mon_mp.ig_mon_cb, host_ig_drv_mp.host_ig_drv_cb)
   `uvmx_if_signal_out(eg_rdy, , eg_mon_mp.eg_mon_cb, host_eg_drv_mp.host_eg_drv_cb)
   `uvmx_if_signal_out(ig_rdy, , ig_mon_mp.ig_mon_cb, card_ig_drv_mp.card_ig_drv_cb)
   `uvmx_if_signal_out(eg_vld, , eg_mon_mp.eg_mon_cb, card_eg_drv_mp.card_eg_drv_cb)
   `uvmx_if_signal_out(eg_r0,  [(DATA_WIDTH-1):0], eg_mon_mp.eg_mon_cb, card_eg_drv_mp.card_eg_drv_cb)
   `uvmx_if_signal_out(eg_r1,  [(DATA_WIDTH-1):0], eg_mon_mp.eg_mon_cb, card_eg_drv_mp.card_eg_drv_cb)
   `uvmx_if_signal_out(eg_r2,  [(DATA_WIDTH-1):0], eg_mon_mp.eg_mon_cb, card_eg_drv_mp.card_eg_drv_cb)
   /// @}


   // pragma uvmx interface begin
   // pragma uvmx interface end

endinterface


`endif // __UVMA_MSTREAM_IF_SV__
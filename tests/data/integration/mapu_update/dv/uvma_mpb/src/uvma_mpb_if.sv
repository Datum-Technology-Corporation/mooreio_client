// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_IF_SV__
`define __UVMA_MPB_IF_SV__


/**
 * Encapsulates all signals and clocking of Matrix Peripheral Bus Agent interface.
 * Assertions must be captured within uvma_mpb_if_chkr.
 * @ingroup uvma_mpb_pkg
 */
interface uvma_mpb_if #(
   parameter int unsigned DATA_WIDTH = `UVMA_MPB_DATA_WIDTH_MAX,
   parameter int unsigned ADDR_WIDTH = `UVMA_MPB_ADDR_WIDTH_MAX
) (
   input  clk, ///< Clock: System clock
   input  reset_n ///< Reset: System reset
);

   /// @name Parallel signals
   /// @{
   wire  vld; ///< Data valid: Data is valid
   wire  rdy; ///< Data ready: Data is ready
   wire  wr; ///< Write: Read/Write bit
   wire [(DATA_WIDTH-1):0]  rdata; ///< Read Data: Read Data bus
   wire [(DATA_WIDTH-1):0]  wdata; ///< Write Data: Write Data bus
   wire [(ADDR_WIDTH-1):0]  addr; ///< Address: Address bus
   /// @}


   /// @name Used by uvma_mpb_p_mon_c
   /// @{
   clocking p_mon_cb @(posedge clk);
      input vld, rdy, wr, rdata, wdata, addr;
   endclocking
   modport p_mon_mp (clocking p_mon_cb);
   /// @}

   /// @name Used by uvma_mpb_main_p_drv_c
   /// @{
   clocking main_p_drv_cb @(posedge clk);
      output vld, wr, wdata, addr;
      input rdy, rdata;
   endclocking
   modport main_p_drv_mp (clocking main_p_drv_cb);
   /// @}

   /// @name Used by uvma_mpb_sec_p_drv_c
   /// @{
   clocking sec_p_drv_cb @(posedge clk);
      output rdy, rdata;
      input vld, wr, wdata, addr;
   endclocking
   modport sec_p_drv_mp (clocking sec_p_drv_cb);
   /// @}


   /// @name Accessors
   /// @{
   `uvmx_if_reset(reset_n)
   `uvmx_if_cb(p_mon_mp, p_mon_cb)
   `uvmx_if_cb(main_p_drv_mp, main_p_drv_cb)
   `uvmx_if_cb(sec_p_drv_mp, sec_p_drv_cb)
   `uvmx_if_signal_out(vld, , p_mon_mp.p_mon_cb, main_p_drv_mp.main_p_drv_cb)
   `uvmx_if_signal_out(wr, , p_mon_mp.p_mon_cb, main_p_drv_mp.main_p_drv_cb)
   `uvmx_if_signal_out(wdata,  [(DATA_WIDTH-1):0], p_mon_mp.p_mon_cb, main_p_drv_mp.main_p_drv_cb)
   `uvmx_if_signal_out(addr,  [(ADDR_WIDTH-1):0], p_mon_mp.p_mon_cb, main_p_drv_mp.main_p_drv_cb)
   `uvmx_if_signal_out(rdy, , p_mon_mp.p_mon_cb, sec_p_drv_mp.sec_p_drv_cb)
   `uvmx_if_signal_out(rdata,  [(DATA_WIDTH-1):0], p_mon_mp.p_mon_cb, sec_p_drv_mp.sec_p_drv_cb)
   /// @}


   // pragma uvmx interface begin
   // pragma uvmx interface end

endinterface


`endif // __UVMA_MPB_IF_SV__
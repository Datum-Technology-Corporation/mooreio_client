module tb();
   logic  clk, reset_n, tdi, tms, tdo, bootsel_i, stm_i, slow_clk_o;
   logic [47:0]  io_in_i, io_out_o, io_oe_o;
   logic [47:0][5:0]  pad_cfg_o;

   core_v_mcu #(
      //.USE_CORES(1)
   ) dut (
      .jtag_tdi_i(tdi),
      .jtag_tms_i(tms),
      .jtag_tdo_o(tdo),
      .bootsel_i(bootsel_i),
      .stm_i(stm_i),
      .io_in_i(io_in_i),
      .io_out_o(io_out_o),
      .pad_cfg_o(pad_cfg_o),
      .io_oe_o(io_oe_o),
      //.slow_clk_o(slow_clk_o),
      .ref_clk_i(clk),
      .jtag_tck_i(clk),
      .rstn_i(reset_n),
      .jtag_trst_i(reset_n)
   );
endmodule
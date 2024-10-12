module def_ss_tb();
  import def_ss_tb_pkg::*;

  logic       clk, rst_n;
  wire [7:0]  data_0, data_1;

  def_ss_top  dut(
    .clk     (clk   ),
    .rst_n   (rst_n ),
    .o_data_0(data_0),
    .o_data_1(data_1)
  );

  initial begin
    clk = 0;
    forever begin
      #(5ns) clk = ~clk;
    end
  end

  initial begin
    rst_n = 1;
    #(100ns) rst_n = 0;
    #(100ns) rst_n = 1;
  end

  initial begin
    `uvm_info("TB", "Test starting", UVM_NONE)
    uvm_top.run_test();
  end

  final begin
    `uvm_info("TB", "Test finished", UVM_NONE)
  end
endmodule
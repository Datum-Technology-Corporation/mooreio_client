module def_ss_top(
  input            clk ,
  input          rst_n ,
  output [7:0] o_data_0,
  output [7:0] o_data_1
);
    abc_block_top  block_instance_0(
      .clk   (clk     ),
      .rst_n (rst_n   ),
      .o_data(o_data_0)
    );
    abc_block_top  block_instance_1(
      .clk   (clk     ),
      .rst_n (rst_n   ),
      .o_data(o_data_1)
    );
endmodule

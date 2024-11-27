module def_ss_top #(
  parameter DATA_WIDTH=8
) (
  input    clk,
  input  rst_n,
  output [(DATA_WIDTH-1):0] o_data_0,
  output [(DATA_WIDTH-1):0] o_data_1
);
    abc_block_top #(
      .DATA_WIDTH(DATA_WIDTH)
    )  block_instance_0(
      .clk   (clk     ),
      .rst_n (rst_n   ),
      .o_data(o_data_0)
    );
    abc_block_top #(
      .DATA_WIDTH(DATA_WIDTH)
    )  block_instance_1(
      .clk   (clk     ),
      .rst_n (rst_n   ),
      .o_data(o_data_1)
    );
endmodule

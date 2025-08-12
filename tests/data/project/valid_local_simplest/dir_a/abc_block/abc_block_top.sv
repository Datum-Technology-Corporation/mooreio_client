module abc_block_top #(
  parameter DATA_WIDTH=8
) (
  input   clk,
  input rst_n,
  output [(DATA_WIDTH-1):0] o_data
);
  logic [(DATA_WIDTH-1):0]  data;
  assign o_data = data;

  always@(posedge clk) begin
    if (rst_n === 0) begin
      data <= 0;
    end
    else begin
      `ifdef ABC_BLOCK_ENABLED
        data <= $urandom();
      `endif
    end
  end
endmodule

module abc_block_top(
  input          clk ,
  input        rst_n ,
  output [7:0] o_data
);
  logic [7:0]  data;
  assign o_data = data;

  always@(posedge clk) begin
    if (rst_n === 0) begin
      data <= 0;
    end
    else begin
      data <= $urandom();
    end
  end
endmodule

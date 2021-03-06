module my_pll(clk_in, sel, clk_out);

input clk_in;
input [1:0]sel;
output clk_out;
reg clk_out;
reg [31:0] counter_max;
reg [31:0] counter;

initial begin
	clk_out=1'b0;
	counter=25000000;
end

always@(sel) begin
	case(sel)
		1: counter_max=5000000;
		2: counter_max=12500000;
		3: counter_max=25000000;
		default
	endcase
end

always@(posedge clk_in) begin
	if(counter==0) begin
		counter=counter_max;
		clk_out=1'b1;
	end else begin
		clk_out=1'b0;
		counter=counter-1;
	end
	
end

endmodule

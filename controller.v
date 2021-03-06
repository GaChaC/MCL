module controller (clk,sw,ctrl,p1_btn,p2_btn,position,outside,winner,
	speed,direction,halt,rstball,ball,p1_score,p2_score,p1_deuce,p2_deuce);

input clk;
input [9:0]sw;
input p1_btn,p2_btn,ctrl;
input [9:0]position;
input outside,winner;

output reg [1:0]speed;
output reg direction;
output reg [15:0]p1_score,p2_score;
output reg p1_deuce,p2_deuce;
output reg halt;
output reg ball;
output reg rstball;

reg [4:0]p1_zone;
reg [9:5]p2_zone;

reg sel;
reg p1_rdy,p2_rdy;
reg [1:0]p1_power,p2_power;

integer p1_idle,p2_idle;
integer p1_idx,p2_idx;

parameter counter_max=50000000;

initial begin
	p1_rdy=1;
	p2_rdy=1;
	halt=1;
	direction=0;
	ball=1;
	p1_score=0;
	p2_score=0;
	p1_deuce=0;
	p2_deuce=0;
end

always@(sel)begin
	case(sel)
		0: speed=p2_power;
		1: speed=p1_power;
	endcase
end

reg trigger;

always@(posedge clk) begin
	if(outside) begin
		halt=1;
		resball=1;
		if(winner==1)brgin
			ball=1;
			direction=0;
			case(p1_score)
				0: p1_score=15;
				15: p1_score=30;
				30: p1_score=30;
				40: begin
					if(p2_deuce==40)begin
						if(p2_deuce)
							p2_deuce=0;
						else if(p1_deuce)
							p1_score=45;
						else
							p1_deuce=1;
					end else begin
						p1_score = 45;
					end
				end
			endcase
		end else if(winner==0)begin
				ball=0;
			direction=1;
		case(p2_score)
			0: p2_score=15;
			15: p2_score=30;
			30: p2_score=40;
			40: begin
				if(p1_score==40)begin
					if(p1_deuce)
						p1_deuce=0;
					else if(p2_deuce)
						p2_score=45;
					else
						p2_deuce=1;
				end else begin
					p2_score=45;
				end
			end
		endcase
	end
end else begin
	rstball=0;
	if(p1_score == 45 || p2_score==45)begin
		if(ctrl)begin
			p1_score=0;
			p2_score=0;
			direction=0;
			ball=1;
			rstball=1;
			p1_deuce=0;
			p2_deuce=0;
		end
	end
end
			
endmodule



//////////////////////
/*
lost 4
*/
////////////////////////


	if(p2_rdy) begin
		if(p2_btn) begin
			p2_rdy=0;
			p2_idle=counter_max;
			p2_power=0;
			for(p2_idx=5;p2_idx<=9;p2_idx=p2_idx+1) begin
				p2_zone[p2_idx]=0;
				if(p2_power<3) begin
					if(sw[p2_idx])begin
						p2_zone[p2_idx]=1;
						p2_power=p2_power+1;
					end
				end
			end
			
			for(p2_idx=5;p2_idx<=9;p2_idx=p2_idx+1) begin
				if(position[p2_idx]==1 && p2_zone[p2_idx]==1) begin
					direction = 1;
					sel=0;
					halt=0;
				end
			end
		end
	end	else begin
		if(p2_idle==0) begin
			p2_rdy=1;
		end else begin
			p2_idle=p2_idle-1;
		end
	end

end

endmodule

`timescale 1ns / 1ps
// for ECE1788 assignment 3
module multiplier(in1,in2,out);
	// set parameters
	parameter input_width = 4;
	parameter output_width = 8;
	// input and output signals
	input [input_width-1:0] in1;
	input [input_width-1:0] in2;
	output [output_width-1:0] out;
	
	wire bit_mult_res [input_width-1:0][input_width-1:0];
	wire sum [input_width:1][input_width-2:0];
	wire carry [input_width-1:1][input_width-1:0];
	wire carry_chain [input_width-1:1];	// final level carry chain

	// multiplied result of each input bit pairs(and)
	genvar ge, gf;
	generate
		for(ge = 0; ge < input_width; ge = ge + 1) begin
			for(gf = 0; gf < input_width; gf = gf + 1) begin
				assign bit_mult_res[ge][gf] = in1[ge] & in2[gf];
			end
		end
	endgenerate
	
	// generate half adders and full adders
	genvar gi, gj;
	generate
		for(gi = 0; gi < input_width - 1; gi = gi + 1) begin
			half_adder hadder_r_1 (bit_mult_res[0][gi+1],
								  	bit_mult_res[1][gi],
                                 	sum[1][gi],
								  	carry[1][gi]  );
			for(gj = 2; gj < input_width; gj = gj + 1) begin
				full_adder fadder_r_middle ((gi==input_width-2)?bit_mult_res[gj-1][gi+1]:sum[gj-1][gi+1],
								  	   		bit_mult_res[gj][gi],
									   		carry[gj-1][gi],
                                  	   		sum[gj][gi],
								  	   		carry[gj][gi]  );
			end
		end
		for(gi = 1; gi < input_width - 1; gi = gi + 1) begin
			full_adder fadder_r_bottom ((gi==input_width-2)?bit_mult_res[input_width-1][gi+1]:sum[input_width-1][gi+1],
								  	   	carry_chain[gi],
									   	carry[input_width-1][gi],
                                  	   	sum[input_width][gi],
								  	   	carry_chain[gi+1]  );
		end
	endgenerate
	// bottom-right half adder
	half_adder hadder_br (sum[input_width-1][1],
							carry[input_width-1][0],
                            sum[input_width][0],
							carry_chain[1] );
	
	// assign output
	genvar gk;
	generate
		assign out[output_width-1] = carry_chain[input_width-1];
		for(gk = 0; gk < input_width - 1; gk = gk + 1) begin
			assign out[gk+1] = sum[gk+1][0];
			assign out[output_width-gk-2] = sum[input_width][input_width-2-gk];
		end
 		assign out[0] = bit_mult_res[0][0];
	endgenerate

endmodule

// half adder submodule 
module half_adder(in1, in2, sum, carry);
	input in1, in2;
	output sum, carry;
	
	assign sum = in1 ^ in2;
	assign carry = in1 & in2;
endmodule

// full adder submodule
module full_adder(in1, in2, in3, sum, carry);
	input in1 , in2, in3;
	output sum, carry;
	
	wire in1XORin2;

	assign in1XORin2 = in1 ^ in2;
	assign sum = in1XORin2 ^ in3;
	assign carry = ((in1 & in2) | (in3 &in1XORin2));
endmodule


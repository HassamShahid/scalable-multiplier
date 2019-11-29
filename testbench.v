`timescale 1ns/1ps
module testbench;

	reg [3:0] X, Y; 
	wire [7:0] P;
	
	multiplier DUT (X,Y,P);
	
	parameter FALSE = 0;
	parameter TRUE = 1;
	reg [4:0] i, j;
	reg passed;
	
	initial	begin : init
			passed = TRUE;
			for (i=0; i<16; i=i+1) begin 
				for (j=0; j<16; j=j+1) begin 
					X <= i;
					Y <= j;
					#25; //long simulation time step (25ns)
					if (P != i*j) begin
						passed = FALSE;
						$display("Test Failed for %d x %d", i, j);
					end
					else begin
						//$display("Test Passed for %d x %d", i, j);
					end
				end
			end
			if (passed)
				$display("Test Completed without Errors! :)");
			else
				$display("Test Completed WITH Errors! :(");	
		end

endmodule
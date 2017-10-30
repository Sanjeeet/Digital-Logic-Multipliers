/* This is a top level module that connects the switches and the 7-segment hex displays
 * to your multiplier.
 */
module lab2(SW, HEX0, HEX1, HEX2, HEX3, LEDR);
	input [15:0] SW;
	output [15:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;	

	wire [7:0] M;
	wire [7:0] Q;
	wire [15:0] result;
	wire cout;
	
	
	/* Connect switches to the multiplier. */
	assign M = SW[7:0];
	assign Q = SW[15:8];

	/* Your multiplier circuit goes here. */
	PartialProduct (M, Q, cout, result);
	
	assign LEDR = result;
	
	/* Multiplication result goes to HEX displays. */
	hex_digits h0(result[3:0], HEX0);
	hex_digits h1(result[7:4], HEX1);
	hex_digits h2(result[11:8], HEX2);
	hex_digits h3(result[15:12], HEX3);
	
endmodule

module PartialProduct (M, Q, cout, sum);
	input [7:0] M, Q;
	
	output [15:0] sum;
	output cout;
	
	wire [15:0] P0, P1, P2, P3, P4, P5, P6, P7, P8;
	wire [15:0] C0, C1, C2, C3, C4, C5, C6, C7, C8;
	
	genvar i;
	generate
		// for the 1st row
		for (i = 0; i <= 7; i = i+1)
			begin: row0
				FA (M[i], Q[0], 0, 0, C0[i], P0[i]);
			end
			
		// for the 2nd row
		for (i = 0; i <= 6; i = i+1)
			begin: row1
				FA (M[i], Q[1], P0[i+1], C0[i], C1[i], P1[i]);
			end
				FA (M[7], Q[1], 0, C0[7], C1[7], P1[7]); //last carry out for each row
				
		// for the 3rd row
		for (i = 0; i <= 6; i = i+1)
			begin: row2
				FA (M[i], Q[2], P1[i+1], C1[i], C2[i], P2[i]);
			end
				FA (M[7], Q[2], 0, C1[7], C2[7], P2[7]); //last carry out for each row
		
		// for the 4th row
		for (i = 0; i <= 6; i = i+1)
			begin: row3
				FA (M[i], Q[3], P2[i+1], C2[i], C3[i], P3[i]);
			end
				FA (M[7], Q[3], 0, C2[7], C3[7], P3[7]); //last carry out for each row
			
		// for the 5th row	
		for (i = 0; i <= 6; i = i+1)
			begin: row4
				FA (M[i], Q[4], P3[i+1], C3[i], C4[i], P4[i]);
			end
				FA (M[7], Q[4], 0, C3[7], C4[7], P4[7]); //last carry out for each row
			
		// for the 6th row	
		for (i = 0; i <= 6; i = i+1)
			begin: row5
				FA (M[i], Q[5], P4[i+1], C4[i], C5[i], P5[i]);
			end
				FA (M[7], Q[5], 0, C4[7], C5[7], P5[7]); //last carry out for each row
			
		// for the 7th row	
		for (i = 0; i <= 6; i = i+1)
			begin: row6
				FA (M[i], Q[6], P5[i+1], C5[i], C6[i], P6[i]);
			end
				FA (M[7], Q[6], 0, C5[7], C6[7], P6[7]);//last carry out for each row
		
		// for the 8th row
		for (i = 0; i <= 6; i = i+1)
			begin: row7
				FA (M[i], Q[7], P6[i+1], C6[i], C7[i], P7[i]);
			end
				FA (M[7], Q[7], 0, C6[7], C7[7], P7[7]); //last carry out for each row
	
		// for the last row to get the final answer
		RFA (P7[1], C7[0], 0, C8[0], P8[0]);
		
		for (i = 1; i <= 6; i = i+1)
			begin: row8 // Ripple Full adder to add last row (Fast Adder)
				RFA (P7[i+1], C7[i], C8[i-1], C8[i], P8[i]);
			end
				RFA (0, C7[7], C8[7], C8[7], P8[7]); //last carry out for each row
	
	endgenerate

	assign sum = {C8[0], P8[6:0], P7[0], P6[0], P5[0], P4[0], P3[0], P2[0], P1[0], P0[0]};
		
endmodule

module FA (Mi, Qi, Pi, cin, cout, psum);
	input Mi, Qi, Pi, cin;
	output cout, psum;

	wire mul;
	assign mul = Mi&Qi;
	
	assign psum = Pi ^ cin ^ mul;
	assign cout = (Pi & mul) | (mul & cin) | (Pi & cin);

endmodule

module RFA (Ai, Bi, cin, cout, p);
	input Ai, Bi, cin;
	output cout, p;
	
	assign p = Ai ^ Bi ^ cin;
	assign cout = (Ai & Bi) | (Bi & cin) | (Ai & cin);

endmodule
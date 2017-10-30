module array_multiplier(SW, HEX0, HEX1, HEX2, HEX3);
	input [15:0] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3; 

	wire [7:0] M;
	wire [7:0] Q;
	wire [15:0] result;
 
	// Connect switches to the multiplier.
	assign M = SW[7:0];
	assign Q = SW[15:8];
 
	// Your multiplier circuit goes here. 
	columns c(M,Q,result);
 
	// Multiplication result goes to HEX displays. 
	hex_digits h0(result[3:0], HEX0);
	hex_digits h1(result[7:4], HEX1);
	hex_digits h2(result[11:8], HEX2);
	hex_digits h3(result[15:12], HEX3);
 
endmodule

// Create instances of rows
module columns(M,Q,P);
	input [7:0] M,Q;
	output [15:0] P;
	wire [7:0] plus, minus;
	wire [8:0] boothIN;
	assign boothIN[8:1] = Q[7:0];
	assign boothIN[0] = 0;

	generate
		genvar i;
		for (i=0; i<8; i=i+1)
		begin:PartialProduct
			wire [9:0] Pin_out;
			BE boothEncoder(boothIN[i],boothIN[i+1],plus[i],minus[i]);
			if (i==0)
				row mr(0,Pin_out,plus[i],minus[i],M);
			else if (i==1)
				row mr( {PartialProduct[0].Pin_out[9],~PartialProduct[0].Pin_out[9],PartialProduct[0].Pin_out[7:1]},Pin_out,plus[i],minus[i],M);
			else 
				row mr(PartialProduct[i-1].Pin_out[9:1],Pin_out,plus[i],minus[i],M);
			assign P[i] = Pin_out[0];
		end
	endgenerate
	
	assign P[15:8] = PartialProduct[7].Pin_out[9:1];
	
endmodule

// Create a single row of Multipliers
module row (Pin,Pout,plus,minus,M);
	input [8:0] Pin;
	output [9:0] Pout;
	input plus,minus;
	input [7:0] M;
	wire [7:0] SignExt;
	wire [7:-1] no;
	wire [8:0] Carry;
	wire twos;

	generate
		genvar i;
		for (i=0; i<8; i=i+1)
		begin:col
			X multiply(Pin[i], M[i], plus, minus, Carry[i], Carry[i+1], SignExt[i], Pout[i]);
			assign no[i] = no[i-1] & SignExt[i];
		end
	endgenerate

	assign Carry[0] = minus;
	// Sign extension, is the ones sign (flip only if all ones and we are negating)
	assign twos = SignExt[7] ^ (minus & no[6]);
	FA fullAdder(~twos, Carry[8], Pin[8], Pout[9], Pout[8]);
endmodule

// Full Adder
module FA(A,B,CI,CO, SUM);
	input A,B,CI;
	output SUM, CO;
	assign SUM = CI^(A^B);
	assign CO = (~(A^B)&B)|((A^B)&CI);
endmodule

// Multiplier Cell
module X(Pin, M, plus, minus, Cin, Cout, SignExt, Pout);	
	input Pin, M, plus, minus, Cin;
	output Cout, Pout, SignExt;
	assign SignExt = (plus & M) | (minus & ~M);
	FA add(Pin,SignExt,Cin,Cout,Pout);
endmodule

// Booth Encoder
module BE(Q0,Q1,plus,minus);
	input Q0,Q1;
	output plus,minus;
	assign plus = Q0&(~Q1);
	assign minus = Q1&(~Q0);
endmodule

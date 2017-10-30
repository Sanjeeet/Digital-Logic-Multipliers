module wallace_tree_multiplier(SW, HEX0, HEX1, HEX2, HEX3);
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
	wallace_multiplier c(result, M, Q);
 
	// Multiplication result goes to HEX displays. 
	hex_digits h0(result[3:0], HEX0);
	hex_digits h1(result[7:4], HEX1);
	hex_digits h2(result[11:8], HEX2);
	hex_digits h3(result[15:12], HEX3);
 
endmodule

module HALF_ADDER(output sum, carry, input a, b);

assign   sum = a ^ b  ;
assign carry = (a & b);
						
endmodule 

module FULL_ADDER(output sum, carry, input a, b, cin);

assign   sum = a ^ b ^ cin ;
assign carry = (a & b) | (b & cin) | (cin & a);
						
endmodule

module wallace_multiplier(output reg [15:0] product, input [7:0] multiplicand, multiplier);

integer i, j ;
wire [63:0] s ,c ;                  // -- the signals which will carry the intermediate values 
reg p [7:0][7:0];                  //                            -- array which stores the partial products


always@(multiplier, multiplicand)
begin

// creating the partial products.

		for (i = 0; i <= 7; i = i + 1)
				for (j = 0; j <= 7; j = j + 1)
							p[j][i] <= multiplicand[j] & multiplier[i];	
			
end	
//1st row

HALF_ADDER ha_11 ( .sum(s[0]), .carry(c[0]), .a(p[1][0]), .b( p[0][1])                 ); 
FULL_ADDER fa_11 ( .sum(s[1]), .carry(c[1]), .a(p[2][0]), .b( p[1][1]), .cin( p[0][2]) );
FULL_ADDER fa_12 ( .sum(s[2]), .carry(c[2]), .a(p[3][0]), .b( p[2][1]), .cin( p[1][2]) );
FULL_ADDER fa_13 ( .sum(s[3]), .carry(c[3]), .a(p[4][0]), .b( p[3][1]), .cin( p[2][2]) );
FULL_ADDER fa_14 ( .sum(s[4]), .carry(c[4]), .a(p[5][0]), .b( p[4][1]), .cin( p[3][2]) );
FULL_ADDER fa_15 ( .sum(s[5]), .carry(c[5]), .a(p[6][0]), .b( p[5][1]), .cin( p[4][2]) );
FULL_ADDER fa_16 ( .sum(s[6]), .carry(c[6]), .a(p[7][0]), .b( p[6][1]), .cin( p[5][2]) ); 
HALF_ADDER ha_12 ( .sum(s[7]), .carry(c[7]),              .a( p[7][1]), .b  ( p[6][2]) );

// 2nd row
HALF_ADDER ha_21 ( .sum( s[8] ), .carry( c[8 ]), .a( p[1][3]), .b( p[0][4])                 ); 
FULL_ADDER fa_21 ( .sum( s[9] ), .carry( c[9 ]), .a( p[2][3]), .b( p[1][4]), .cin( p[0][5]) );
FULL_ADDER fa_22 ( .sum( s[10]), .carry( c[10]), .a( p[3][3]), .b( p[2][4]), .cin( p[1][5]) );
FULL_ADDER fa_23 ( .sum( s[11]), .carry( c[11]), .a( p[4][3]), .b( p[3][4]), .cin( p[2][5]) );
FULL_ADDER fa_24 ( .sum( s[12]), .carry( c[12]), .a( p[5][3]), .b( p[4][4]), .cin( p[3][5]) );
FULL_ADDER fa_25 ( .sum( s[13]), .carry( c[13]), .a( p[6][3]), .b( p[5][4]), .cin( p[4][5]) );
FULL_ADDER fa_26 ( .sum( s[14]), .carry( c[14]), .a( p[7][3]), .b( p[6][4]), .cin( p[5][5]) ); 
HALF_ADDER ha_22 ( .sum( s[15]), .carry( c[15]),               .a( p[7][4]), .b  ( p[6][5]) );

// 3rd row
HALF_ADDER ha_31 ( .sum( s[16]), .carry( c[16]), .a( c[0])   , .b ( s[1])                     ); 
FULL_ADDER fa_31 ( .sum( s[17]), .carry( c[17]), .a( c[1])   , .b ( s[2])   , .cin ( p[0][3]) );
FULL_ADDER fa_32 ( .sum( s[18]), .carry( c[18]), .a( c[2])   , .b ( s[3])   , .cin ( s[8] )   );
FULL_ADDER fa_33 ( .sum( s[19]), .carry( c[19]), .a( c[3])   , .b ( s[4])   , .cin ( s[9] )   );
FULL_ADDER fa_34 ( .sum( s[20]), .carry( c[20]), .a( c[4])   , .b ( s[5])   , .cin ( s[10])   );
FULL_ADDER fa_35 ( .sum( s[21]), .carry( c[21]), .a( c[5])   , .b ( s[6])   , .cin ( s[11])   );
FULL_ADDER fa_36 ( .sum( s[22]), .carry( c[22]), .a( c[6])   , .b ( s[7])   , .cin ( s[12])   ); 
FULL_ADDER fa_37 ( .sum( s[23]), .carry( c[23]), .a( c[7])   , .b ( p[7][2]), .cin ( s[13])   );


// 4th row
HALF_ADDER ha_41 ( .sum( s[24]), .carry( c[24]), .a( c[9] )  , .b( p[0][6])                 ); 
FULL_ADDER fa_41 ( .sum( s[25]), .carry( c[25]), .a( c[10])  , .b( p[1][6]), .cin( p[0][7]) );
FULL_ADDER fa_42 ( .sum( s[26]), .carry( c[26]), .a( c[11])  , .b( p[2][6]), .cin( p[1][7]) );
FULL_ADDER fa_43 ( .sum( s[27]), .carry( c[27]), .a( c[12])  , .b( p[3][6]), .cin( p[2][7]) );
FULL_ADDER fa_44 ( .sum( s[28]), .carry( c[28]), .a( c[13])  , .b( p[4][6]), .cin( p[3][7]) );
FULL_ADDER fa_45 ( .sum( s[29]), .carry( c[29]), .a( c[14])  , .b( p[5][6]), .cin( p[4][7]) );
FULL_ADDER fa_46 ( .sum( s[30]), .carry( c[30]), .a( c[15])  , .b( p[6][6]), .cin( p[5][7]) ); 
HALF_ADDER fa_47 ( .sum( s[31]), .carry( c[31]),               .a( p[7][6]), .b  ( p[6][7]) );

//5th row
HALF_ADDER ha_51 ( .sum( s[32]), .carry( c[32]), .a( s[17])  , .b( c[16])                   ); 
HALF_ADDER fa_51 ( .sum( s[33]), .carry( c[33]), .a( s[18])  , .b( c[17])                   ); 
FULL_ADDER fa_52 ( .sum( s[34]), .carry( c[34]), .a( s[19])  , .b( c[18]), .cin( c[8] )     ); 
FULL_ADDER fa_53 ( .sum( s[35]), .carry( c[35]), .a( s[20])  , .b( c[19]), .cin( s[24])     ); 
FULL_ADDER fa_54 ( .sum( s[36]), .carry( c[36]), .a( s[21])  , .b( c[20]), .cin( s[25])     ); 
FULL_ADDER fa_55 ( .sum( s[37]), .carry( c[37]), .a( s[22])  , .b( c[21]), .cin( s[26])     ); 
FULL_ADDER fa_56 ( .sum( s[38]), .carry( c[38]), .a( s[23])  , .b( c[22]), .cin( s[27])     ); 
FULL_ADDER fa_57 ( .sum( s[39]), .carry( c[39]), .a( s[14])  , .b( c[23]), .cin( s[28])     ); 
HALF_ADDER ha_52 ( .sum( s[40]), .carry( c[40]), .a( s[15])  ,             .b  ( s[29])     ); 
HALF_ADDER ha_53 ( .sum( s[41]), .carry( c[41]), .a( p[7][5]),             .b  ( s[30])     ); 

// 6th row
HALF_ADDER ha_61 ( .sum( s[42]), .carry( c[42]), .a( s[33])  , .b( c[32])                   );
HALF_ADDER ha_62 ( .sum( s[43]), .carry( c[43]), .a( s[34])  , .b( c[33])                   );
HALF_ADDER ha_63 ( .sum( s[44]), .carry( c[44]), .a( s[35])  , .b( c[34])                   );
FULL_ADDER fa_61 ( .sum( s[45]), .carry( c[45]), .a( s[36])  , .b( c[35]), .cin( c[24])     ); 
FULL_ADDER fa_62 ( .sum( s[46]), .carry( c[46]), .a( s[37])  , .b( c[36]), .cin( c[25])     ); 
FULL_ADDER fa_63 ( .sum( s[47]), .carry( c[47]), .a( s[38])  , .b( c[37]), .cin( c[26])     ); 
FULL_ADDER fa_64 ( .sum( s[48]), .carry( c[48]), .a( s[39])  , .b( c[38]), .cin( c[27])     ); 
FULL_ADDER fa_65 ( .sum( s[49]), .carry( c[49]), .a( s[40])  , .b( c[39]), .cin( c[28])     ); 
FULL_ADDER fa_66 ( .sum( s[50]), .carry( c[50]), .a( s[41])  , .b( c[40]), .cin( c[29])     ); 
FULL_ADDER fa_67 ( .sum( s[51]), .carry( c[51]), .a( s[31])  , .b( c[41]), .cin( c[30])     ); 
HALF_ADDER ha_64 ( .sum( s[52]), .carry( c[52]), .a( p[7][7]),             .b  ( c[31])     );

//7th row

HALF_ADDER ha_71 ( .sum( s[53]), .carry( c[53]), .a( s[43])  , .b( c[42])                  );
FULL_ADDER fa_71 ( .sum( s[54]), .carry( c[54]), .a( s[44])  , .b( c[43]), .cin ( c[53])   );
FULL_ADDER fa_72 ( .sum( s[55]), .carry( c[55]), .a( s[45])  , .b( c[44]), .cin ( c[54])   );
FULL_ADDER fa_73 ( .sum( s[56]), .carry( c[56]), .a( s[46])  , .b( c[45]), .cin ( c[55])   );
FULL_ADDER fa_74 ( .sum( s[57]), .carry( c[57]), .a( s[47])  , .b( c[46]), .cin ( c[56])   );
FULL_ADDER fa_75 ( .sum( s[58]), .carry( c[58]), .a( s[48])  , .b( c[47]), .cin ( c[57])   );
FULL_ADDER fa_76 ( .sum( s[59]), .carry( c[59]), .a( s[49])  , .b( c[48]), .cin ( c[58])   );
FULL_ADDER fa_77 ( .sum( s[60]), .carry( c[60]), .a( s[50])  , .b( c[49]), .cin ( c[59])   );
FULL_ADDER fa_78 ( .sum( s[61]), .carry( c[61]), .a( s[51])  , .b( c[50]), .cin ( c[60])   );
FULL_ADDER fa_79 ( .sum( s[62]), .carry( c[62]), .a( s[52])  , .b( c[51]), .cin ( c[61])   );
HALF_ADDER ha_72 ( .sum( s[63]), .carry( c[63]),               .a( c[52]), .b   ( c[62])   );
 
assign product = {s[63 : 53],s[42],s[32],s[16],s[0],p[0][0]};

endmodule  

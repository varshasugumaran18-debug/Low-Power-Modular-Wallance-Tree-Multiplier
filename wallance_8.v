module counter7_3_optimized_v(
    input  in0, in1, in2, in3, in4, in5, in6,
    output out0, out1, out2
);

// -----------------------------
// Stage 1: First group of 3 bits
// -----------------------------

wire s1, c1;

assign s1 = in0 ^ in1 ^ in2;           
assign c1 = (in0 & in1) |
            (in1 & in2) |
            (in0 & in2);                

// -----------------------------
// Stage 2: Second group of 3 bits
// -----------------------------

wire s2, c2;

assign s2 = in3 ^ in4 ^ in5;           
assign c2 = (in3 & in4) |
            (in4 & in5) |
            (in3 & in5);                

// -----------------------------
// Stage 3: Combine both groups + last bit
// -----------------------------

wire s3, c3;

assign s3 = s1 ^ s2 ^ in6;                 
assign c3 = (s1 & s2) |
            (s2 & in6) |
            (s1 & in6);                    

// -----------------------------
// Final output construction
// -----------------------------

assign out0 = s3;                           // LSB
assign out1 = c1 ^ c2 ^ c3;                 // Middle bit
assign out2 = (c1 & c2) |
              (c2 & c3) |
              (c1 & c3);                    // MSB

endmodule








module COMP42_no_cout_v(
    input a,b,c,d,cin,
    output sum, carry
);

wire s1, c1, c2;

assign s1 = a ^ b ^ c;
assign c1 = (a & b) | (b & c) | (a & c);

assign sum = s1 ^ d ^ cin;
assign c2  = (s1 & d) | (d & cin) | (s1 & cin);

assign carry = c1 | c2;

endmodule




module HA_v (
    input  a,
    input  b,
    output sum,
    output carry
);

assign sum   = a ^ b;   // XOR for sum
assign carry = a & b;   // AND for carry

endmodule



module FA_v (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);

assign sum  = a ^ b ^ cin;   // 3-input XOR
assign cout = (a & b) | 
              (b & cin) | 
              (a & cin);     // Majority function

endmodule

module rca_16_v (
    input  [15:0] A,
    input  [15:0] B,
    output [15:0] SUM,
    output Cout
);

wire [16:0] C;      // Carry chain
assign C[0] = 1'b0; // Initial carry = 0

genvar i;
generate
    for(i = 0; i < 16; i = i + 1) begin : RCA_BLOCK
        
        FA_v FA_inst (
            .a   (A[i]),
            .b   (B[i]),
            .cin (C[i]),
            .sum (SUM[i]),
            .cout(C[i+1])   
        );

    end
endgenerate

assign Cout = C[16];  // Final carry output

endmodule




module wallace_8x8_v (A, B, P);

input  [7:0] A;
input  [7:0] B;
output [15:0] P;

wire P00,P01,P02,P03,P04,P05,P06,P07;
wire P10,P11,P12,P13,P14,P15,P16,P17;
wire P20,P21,P22,P23,P24,P25,P26,P27;
wire P30,P31,P32,P33,P34,P35,P36,P37;
wire P40,P41,P42,P43,P44,P45,P46,P47;
wire P50,P51,P52,P53,P54,P55,P56,P57;
wire P60,P61,P62,P63,P64,P65,P66,P67;
wire P70,P71,P72,P73,P74,P75,P76,P77;
wire S16,S17,S18,S19,S20,S21,S22,S23,S24,S25,S26,S27,S28;
wire C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28;
wire x1,x2,x3;

// Row 0
assign P00 = A[0] & B[0];
assign P01 = A[0] & B[1];
assign P02 = A[0] & B[2];
assign P03 = A[0] & B[3];
assign P04 = A[0] & B[4];
assign P05 = A[0] & B[5];
assign P06 = A[0] & B[6];
assign P07 = A[0] & B[7];

// Row 1
assign P10 = A[1] & B[0];
assign P11 = A[1] & B[1];
assign P12 = A[1] & B[2];
assign P13 = A[1] & B[3];
assign P14 = A[1] & B[4];
assign P15 = A[1] & B[5];
assign P16 = A[1] & B[6];
assign P17 = A[1] & B[7];

// Row 2
assign P20 = A[2] & B[0];
assign P21 = A[2] & B[1];
assign P22 = A[2] & B[2];
assign P23 = A[2] & B[3];
assign P24 = A[2] & B[4];
assign P25 = A[2] & B[5];
assign P26 = A[2] & B[6];
assign P27 = A[2] & B[7];

// Row 3
assign P30 = A[3] & B[0];
assign P31 = A[3] & B[1];
assign P32 = A[3] & B[2];
assign P33 = A[3] & B[3];
assign P34 = A[3] & B[4];
assign P35 = A[3] & B[5];
assign P36 = A[3] & B[6];
assign P37 = A[3] & B[7];

// Row 4
assign P40 = A[4] & B[0];
assign P41 = A[4] & B[1];
assign P42 = A[4] & B[2];
assign P43 = A[4] & B[3];
assign P44 = A[4] & B[4];
assign P45 = A[4] & B[5];
assign P46 = A[4] & B[6];
assign P47 = A[4] & B[7];

// Row 5
assign P50 = A[5] & B[0];
assign P51 = A[5] & B[1];
assign P52 = A[5] & B[2];
assign P53 = A[5] & B[3];
assign P54 = A[5] & B[4];
assign P55 = A[5] & B[5];
assign P56 = A[5] & B[6];
assign P57 = A[5] & B[7];

// Row 6
assign P60 = A[6] & B[0];
assign P61 = A[6] & B[1];
assign P62 = A[6] & B[2];
assign P63 = A[6] & B[3];
assign P64 = A[6] & B[4];
assign P65 = A[6] & B[5];
assign P66 = A[6] & B[6];
assign P67 = A[6] & B[7];

// Row 7
assign P70 = A[7] & B[0];
assign P71 = A[7] & B[1];
assign P72 = A[7] & B[2];
assign P73 = A[7] & B[3];
assign P74 = A[7] & B[4];
assign P75 = A[7] & B[5];
assign P76 = A[7] & B[6];
assign P77 = A[7] & B[7];

// additional wires
wire S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15;
wire C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15;

// Stage 1

HA h1 (P01, P10, S1, C1);

FA_v f1 (P02, P11, P20, S2, C2);
COMP42_no_cout_v Cp1 (P03, P12, P21, P30, 1'b0, S3, C3);
COMP42_no_cout_v Cp2 (P40,P13, P22, P31, 1'b0, S4, C4);
COMP42_no_cout_v Cp3 (P50,P41,P23,P32, 1'b0, S5, C5);
HA_v h11(P14,P05,S6,C6);
counter7_3_optimized_v C01 (P06, P15, P24, P33, P42, P51, P60, S7, C7, x1);
counter7_3_optimized_v C02 (P70,P16,P25,P34, P43, P52, P61, S8, C8, x2);
counter7_3_optimized_v C03 (P17, P26, P35, P44, P53, P62, P71, S9, C9, x3);
COMP42_no_cout_v Cp4 (P27, P36, P45, P54, 1'b0, S10, C10);
HA_v h3 (P36,P27,S11,C11);
COMP42_no_cout_v Cp5 (P73,P46,P55, P64, 1'b0, S12,C12);
COMP42_no_cout_v Cp6 (P47, P56, P65, P74, 1'b0, S13, C13);

FA_v f2 (P57, P66, P75, S14, C14);

HA_v h4 (P67, P76, S15, C15);



// Stage 2

// direct assignments
assign P[0] = P00;
assign P[1] = S1;

HA_v h5 (S2, C1, S16, C16);

HA_v h6 (S3, C2, S17, C17);

FA_v f3 (S4, C3, P04,S18,C18);

FA_v f4 (S5, C4, S6, S19, C19);

FA_v f5 (S7, C5, C6, S20, C20);

COMP42_no_cout_v Cp7 (S8, C7, P07,x1,1'b0,S21, C21);

FA_v f6 (S9, C8, x2, S22, C22);

COMP42_no_cout_v Cp8 (S10, C9, S11, x3, 1'b0, S23, C23);

COMP42_no_cout_v Cp9 (S12, P37,C11,C10, 1'b0, S24, C24);

HA_v h7 (S13, C12, S25, C25);

HA_v h8 (S14, C13, S26, C26);

HA_v h9 (S15, C14, S27, C27);

HA_v h10 (P77, C15, S28, C28);


wire [15:0] SUM_ROW;
wire [15:0] CARRY_ROW;
wire cout;

// Form sum row
assign SUM_ROW = {1'b0,S28,S27,S26,S25,S24,S23,S22,S21,
                  S20,S19,S18,S17,S16,S1,P00};

// Form shifted carry row
assign CARRY_ROW = {C28,C27,C26,C25,C24,C23,C22,C21,
                    C20,C19,C18,C17,C16,1'b0,1'b0,1'b0};

// Final RC
rca_16_v FINAL_ADDER (
    .A   (SUM_ROW),
    .B   (CARRY_ROW),
    .SUM (P),.Cout(cout)
);
endmodule




`timescale 1ns/1ps

module tb_multiplier;

    reg  [7:0] A;
    reg  [7:0] B;
    wire [15:0] P;

    // Instantiate your multiplier module
    wallace_8x8_v uut (
        .A(A),
        .B(B),
        .P(P)
    );

    integer i, j;

    initial begin
        $display("Time\tA\tB\tExpected\tActual");

        // Test multiple positive values
        for (i = 0; i <= 20; i = i + 1) begin
            for (j = 0; j <= 20; j = j + 1) begin
                A = i;
                B = j;
                #10;

                if (P == (A * B))
                    $display("%0t\t%d\t%d\t%d\t\t%d  PASS", 
                              $time, A, B, (A*B), P);
                else
                    $display("%0t\t%d\t%d\t%d\t\t%d  FAIL", 
                              $time, A, B, (A*B), P);
            end
        end

        $display("Simulation Finished");
        $stop;
    end

endmodule
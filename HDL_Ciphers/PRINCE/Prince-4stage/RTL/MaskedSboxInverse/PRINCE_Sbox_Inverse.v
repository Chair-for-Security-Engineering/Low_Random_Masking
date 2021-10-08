/*
* -----------------------------------------------------------------
* AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
* DOCUMENT: "Cryptanalysis of Efficient Masked Ciphers: Applications to Low Latency" (TCHES 2022, Issue 1)
* -----------------------------------------------------------------
*
* Copyright (c) 2021, Aein Rezaei Shahmirzadi
*
* All rights reserved.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Please see LICENSE and README for license and further instructions.
*/

module PRINCE_Sbox_Inverse(
		input clk,
		input [3:0] in1,
		input [3:0] in2,
		input [3:0] in3,

		input [6*7-1:0] r,
		input [3:0] klmn_in1,
		input [5:0] klmn_in2,
		output [5:0] klmn_out1,

		output  [3:0] out1,
		output  [3:0] out2,
		output  [3:0] out3 );
	

	 
		  
	//wire [6*7-1:0] r = 0;
	 wire [1:0] rc = 0;
	 
	 reg [3:0] in1_reg;
	 reg [3:0] in2_reg;
	 reg [3:0] in3_reg;
	 
	 
	 wire [3:0] klmn_in3 = 0;
	 wire [3:0] Q294_1_out1;
	 wire [3:0] Q294_1_out2;
	 wire [3:0] Q294_1_out3;
	 
	 wire [3:0] M1_out1;
	 wire [3:0] M1_out2;
	 wire [3:0] M1_out3;
	 
	 wire [3:0] Q294_2_out1;
	 wire [3:0] Q294_2_out2;
	 wire [3:0] Q294_2_out3;
	 
	 wire [3:0] M2_out1;
	 wire [3:0] M2_out2;
	 wire [3:0] M2_out3;
	 
	 reg [3:0] M2_out1_reg;
	 reg [3:0] M2_out2_reg;
	 reg [3:0] M2_out3_reg;
	 
	 wire [3:0] Q294_3_out1;
	 wire [3:0] Q294_3_out2;
	 wire [3:0] Q294_3_out3;
	 
	 reg [3:0] Q294_3_out1_reg;
	 reg [3:0] Q294_3_out2_reg;
	 reg [3:0] Q294_3_out3_reg;
	 
	 //----------------------
	 
	always @(posedge clk) begin
	
		in1_reg <= in1;
		in2_reg <= in2;
		in3_reg <= in3;
	
	end
	 
	 Q294Ain_2order Q294_inst1 (
    .clk(clk), 
    .in1(in1_reg), 
    .in2(in2_reg), 
    .in3(in3_reg), 
    .r(r[11:0]), 
    .rc(8'h0), 
	 .klmn(klmn_in1),
    .out1(Q294_1_out1), 
    .out2(Q294_1_out2), 
    .out3(Q294_1_out3) );
	 
	assign klmn_out1 = {Q294_1_out2[1:0], Q294_1_out1};
	
	
	M1AffC M1Affine1 (Q294_1_out1, M1_out1);
	M1Aff M1Affine2 (Q294_1_out2, M1_out2);
	M1Aff M1Affine3 (Q294_1_out3, M1_out3);
	
	Am2Q294_2order Q294_inst2 (
    .clk(clk), 
    .in1(M1_out1), 
    .in2(M1_out2), 
    .in3(M1_out3), 
    .r(r[12*2-1:12]), 
    .rc(rc), 
	.klmn(klmn_in2[3:0]),
	.r_s(klmn_in2[5:4]),
    .out1(Q294_2_out1), 
    .out2(Q294_2_out2), 
    .out3(Q294_2_out3)
    );
	 
	
	AoutQ294_2order Q294_inst3 (
    .clk(clk), 
    .in1(Q294_2_out1), 
    .in2(Q294_2_out2), 
    .in3(Q294_2_out3), 
    .r(r[6*3 + 12*2-1:12*2]), 
	 .klmn(klmn_in3),
    .out1(Q294_3_out1), 
    .out2(Q294_3_out2), 
    .out3(Q294_3_out3)
    );
	 
	
	assign out1 = Q294_3_out1;
	assign out2 = Q294_3_out2;
	assign out3 = Q294_3_out3;

endmodule

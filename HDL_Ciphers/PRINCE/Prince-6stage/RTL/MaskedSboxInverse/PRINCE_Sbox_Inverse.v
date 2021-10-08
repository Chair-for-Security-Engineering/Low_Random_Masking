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
 (* SILVER = "clock" *) input clk,
  (* SILVER = "[3:0]_0" *) input [3:0] in1,
  (* SILVER = "[3:0]_1" *) input [3:0] in2,
  (* SILVER = "[3:0]_2" *) input [3:0] in3,
  
  (* SILVER = "refresh" *) input [37:0] r,

  (* SILVER = "[3:0]_0" *) output  [3:0] out1,
  (* SILVER = "[3:0]_1" *) output  [3:0] out2,
  (* SILVER = "[3:0]_2" *) output  [3:0] out3
    );
	 
	 wire [3:0] InAff_out1;
	 wire [3:0] InAff_out2;
	 wire [3:0] InAff_out3;
	 
	 reg [3:0] InAff_out1_reg;
	 reg [3:0] InAff_out2_reg;
	 reg [3:0] InAff_out3_reg;
	 
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
	 
	 reg [3:0] M1_out1_reg;
	 reg [3:0] M1_out2_reg;
	 reg [3:0] M1_out3_reg;
	 
	 wire [3:0] Q294_3_out1;
	 wire [3:0] Q294_3_out2;
	 wire [3:0] Q294_3_out3;
	 
	 reg [3:0] Q294_3_out1_reg;
	 reg [3:0] Q294_3_out2_reg;
	 reg [3:0] Q294_3_out3_reg;
	 
	 //----------------------
	 
	 InAffC InputAffine1 (in1, InAff_out1);
	 InAff InputAffine2 (in2, InAff_out2);
	 InAff InputAffine3 (in3, InAff_out3);
	 
	 always @(posedge clk) begin
		InAff_out1_reg <= InAff_out1;
		InAff_out2_reg <= InAff_out2;
		InAff_out3_reg <= InAff_out3;
		
		M1_out1_reg		<= M1_out1;
		M1_out2_reg		<= M1_out2;
		M1_out3_reg		<= M1_out3;
		
		M2_out1_reg		<= M2_out1;
		M2_out2_reg		<= M2_out2;
		M2_out3_reg		<= M2_out3;
	 end
	 
	 Q294_2order Q294_inst1 (
    .clk(clk), 
    .in1(InAff_out1_reg), 
    .in2(InAff_out2_reg), 
    .in3(InAff_out3_reg), 
    .r({r[36], r[11:0]}), 
    .out1(Q294_1_out1), 
    .out2(Q294_1_out2), 
    .out3(Q294_1_out3)
    );

	M1AffC M1Affine1 (Q294_1_out1, M1_out1);
	M1Aff M1Affine2 (Q294_1_out2, M1_out2);
	M1Aff M1Affine3 (Q294_1_out3, M1_out3);
	
	Q294_2order Q294_inst2 (
    .clk(clk), 
    .in1(M1_out1_reg), 
    .in2(M1_out2_reg), 
    .in3(M1_out3_reg), 
    .r({r[37], r[12*2-1:12]}), 
    .out1(Q294_2_out1), 
    .out2(Q294_2_out2), 
    .out3(Q294_2_out3)
    );
	 
	M2AffC M2Affine1 (Q294_2_out1, M2_out1);
	M2Aff M2Affine2 (Q294_2_out2, M2_out2);
	M2Aff M2Affine3 (Q294_2_out3, M2_out3);
	
	Q294_2order Q294_inst3 (
    .clk(clk), 
    .in1(M2_out1_reg), 
    .in2(M2_out2_reg), 
    .in3(M2_out3_reg), 
    .r({1'b0, r[12*3-1:24]}), 
    .out1(Q294_3_out1), 
    .out2(Q294_3_out2), 
    .out3(Q294_3_out3)
    );
	 
	OutAffC OutputAffine1 (Q294_3_out1, out1);
	OutAff OutputAffine2  (Q294_3_out2, out2);
	OutAff OutputAffine3  (Q294_3_out3, out3);
	
//	assign out1 = M2_out1;
//	assign out2 = M2_out2;
//	assign out3 = M2_out3;

endmodule

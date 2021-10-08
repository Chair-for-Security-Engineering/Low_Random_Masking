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

module FourSboxes(
	input clk,
	input [4*4-1:0] in1,
	input [4*4-1:0] in2,
	input [4*4-1:0] in3,
	input [4*42-1:0] r,
	output  [4*4-1:0] out1,
	output  [4*4-1:0] out2,
	output  [4*4-1:0] out3 );
	 

	 
	 wire [5:0] S1_klmn_out1;
	 wire [5:0] S2_klmn_out1;
	 wire [5:0] S3_klmn_out1;
	 wire [5:0] S4_klmn_out1;


	 

	 
	 PRINCE_Sbox_Inverse S1 (
    .clk(clk), 
    .in1(in1[3:0]), 
    .in2(in2[3:0]), 
    .in3(in3[3:0]), 
	 .r(r[41:0]),
    .klmn_in1(in1[7:4]), 
    .klmn_in2(S3_klmn_out1), 
    .klmn_out1(S1_klmn_out1), 
    .out1(out1[3:0]), 
    .out2(out2[3:0]), 
    .out3(out3[3:0])
    );
	 
	 PRINCE_Sbox_Inverse S2 (
    .clk(clk), 
    .in1(in1[7:4]), 
    .in2(in2[7:4]), 
    .in3(in3[7:4]), 
	 .r(r[42*2-1:42*1]),
    .klmn_in1(in1[11:8]), 
    .klmn_in2(S4_klmn_out1), 
    .klmn_out1(S2_klmn_out1), 
    .out1(out1[7:4]), 
    .out2(out2[7:4]), 
    .out3(out3[7:4])
    );
	 
	 PRINCE_Sbox_Inverse S3 (
    .clk(clk), 
    .in1(in1[11:8]), 
    .in2(in2[11:8]), 
    .in3(in3[11:8]), 
    .r(r[42*3-1:42*2]),
	 .klmn_in1(in1[15:12]), 
    .klmn_in2(S1_klmn_out1), 
    .klmn_out1(S3_klmn_out1), 
    .out1(out1[11:8]), 
    .out2(out2[11:8]), 
    .out3(out3[11:8])
    );
		
		
	PRINCE_Sbox_Inverse S4 (
    .clk(clk), 
    .in1(in1[15:12]), 
    .in2(in2[15:12]), 
    .in3(in3[15:12]), 
    .r(r[42*4-1:42*3]),
	 .klmn_in1(in1[3:0]), 
    .klmn_in2(S2_klmn_out1), 
    .klmn_out1(S4_klmn_out1), 
    .out1(out1[15:12]), 
    .out2(out2[15:12]), 
    .out3(out3[15:12])
    );

endmodule

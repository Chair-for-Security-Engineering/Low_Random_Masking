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
module TwoSbox(
input clk,
input [7:0] in1,
input [7:0] in2,
input [7:0] in3,

input [89:0] r,

output  [7:0] out1,
output  [7:0] out2,
output  [7:0] out3
    );
	 
	 wire [5:0] rs1;
	 wire [5:0] rs2;
	 
	 
	 Midori_Sbox S1 (
    .clk(clk), 
    .in1(in1[3:0]), 
    .in2(in2[3:0]), 
    .in3(in3[3:0]), 
    .r(r[44:0]), 
    .rs_in(rs2), 
    .rs_out(rs1), 
    .out1(out1[3:0]), 
    .out2(out2[3:0]), 
    .out3(out3[3:0])
    );
	 
	 Midori_Sbox S2 (
    .clk(clk), 
    .in1(in1[7:4]), 
    .in2(in2[7:4]), 
    .in3(in3[7:4]), 
    .r(r[89 : 45]), 
	.rs_in(rs1), 
    .rs_out(rs2),  
    .out1(out1[7:4]), 
    .out2(out2[7:4]), 
    .out3(out3[7:4])
    );


endmodule

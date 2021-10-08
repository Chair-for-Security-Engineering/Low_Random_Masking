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
	(* SILVER = "clock" *) input clk,
  (* SILVER = "[3:0]_0" *) input [7:0] in1,
  (* SILVER = "[3:0]_1" *) input [7:0] in2,
  (* SILVER = "[3:0]_2" *) input [7:0] in3,
  
  (* SILVER = "refresh" *) input [63:0] r,

  (* SILVER = "[3:0]_0" *) output  [7:0] out1,
  (* SILVER = "[3:0]_1" *) output  [7:0] out2,
  (* SILVER = "[3:0]_2" *) output  [7:0] out3
    );
	 
	 wire [3:0] rs1;
	 wire [3:0] rs2;
	 
	 
	 SKINNY_Sbox S1 (
    .clk(clk), 
    .in1(in1[3:0]), 
    .in2(in2[3:0]), 
    .in3(in3[3:0]), 
    .r(r[23:0]), 
    .rc(r[55:48]),
	 .klmn(rs2), 
	 .klmn_out(rs1),
    .out1(out1[3:0]), 
    .out2(out2[3:0]), 
    .out3(out3[3:0])
    );
	 
	 SKINNY_Sbox S2 (
    .clk(clk), 
    .in1(in1[7:4]), 
    .in2(in2[7:4]), 
    .in3(in3[7:4]), 
    .r(r[47:24]),
	 .rc(r[63:56]),
	 .klmn(rs1), 
	 .klmn_out(rs2),
    .out1(out1[7:4]), 
    .out2(out2[7:4]), 
    .out3(out3[7:4])
    );


endmodule

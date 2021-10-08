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

`timescale 1ns / 1ps



module LED128_7shares_TB;

	// Inputs
	reg clk;
	reg rst;
	reg [63:0] Plaintext0;
	reg [63:0] Plaintext1;
	reg [63:0] Plaintext2;
	reg [127:0] Key0;
	reg [127:0] Key1;
	reg [127:0] Key2;
	reg [71:0] r;

	// Outputs
	wire [63:0] Ciphertext0;
	wire [63:0] Ciphertext1;
	wire [63:0] Ciphertext2;
	wire done;

	wire [63:0] In;
	wire [63:0] Out;
	
	assign In = Plaintext0 ^ Plaintext1 ^ Plaintext2;
	assign Out = Ciphertext0 ^ Ciphertext1 ^ Ciphertext2;
	
	// Instantiate the Unit Under Test (UUT)
	LED128Enc uut (
		.clk(clk), 
		.rst(rst), 
		.Plaintext0(Plaintext0), 
		.Plaintext1(Plaintext1), 
		.Plaintext2(Plaintext2), 
		.Key0(Key0), 
		.Key1(Key1), 
		.Key2(Key2), 
		.r(r), 
		.Ciphertext0(Ciphertext0), 
		.Ciphertext1(Ciphertext1), 
		.Ciphertext2(Ciphertext2), 
		.done(done)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		Plaintext0 = 64'h0123456789abcdef;
		Plaintext1 = 0;
		Plaintext2 = 0;
		Key0 = 128'h0123456789abcdef0123456789abcdef;
		Key1 = 0;
		Key2 = 0;
		r = 0;

		// Wait 100 ns for global reset to finish
		#10;
		Plaintext0 = 64'h3687416813565654;
		#10;
		Plaintext0 = 64'h0123456789abcdef;
		#10;
//		Plaintext0 = 64'h3687416813565654;
//		#10;
//		Plaintext0 = 64'h0123456789abcdef;
//		#10;
        rst = 0;
		// Add stimulus here
		@(posedge done) begin
			#5
			if(Out == 64'hD6B824587F014FC2) begin
				 $write("------------------PASS---------------\n");
			end
			else begin
				$write("\------------------FAIL---------------\n");
			end
			
			#10
			if(Out == 64'h1DA1C98A6A1B470E) begin
				 $write("------------------PASS---------------\n");
			end
			else begin
				$write("\------------------FAIL---------------\n");
			end
			#10
			if(Out == 64'hD6B824587F014FC2) begin
				 $write("------------------PASS---------------\n");
			end
			else begin
				$write("\------------------FAIL---------------\n");
			end
			
//			#10
//			if(Out == 64'h1DA1C98A6A1B470E) begin
//				 $write("------------------PASS---------------\n");
//			end
//			else begin
//				$write("\------------------FAIL---------------\n");
//			end
//			#10
//			if(Out == 64'hD6B824587F014FC2) begin
//				 $write("------------------PASS---------------\n");
//			end
//			else begin
//				$write("\------------------FAIL---------------\n");
//			end
			
		end
			$stop;
			
	end
      always #5 clk = ~clk;
endmodule


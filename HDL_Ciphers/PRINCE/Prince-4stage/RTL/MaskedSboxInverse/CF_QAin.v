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
module CF_QAin(
    input [2:0] a,
    input [2:0] b,
    input [2:0] c,
    input [2:0] d,
    input [5:0] r1,
    input [5:0] r2,
    input [3:0] rc,
    input [1:0] kl,
    input [1:0] mn,
    output q 
	 );
	 
	parameter num = 1;
	generate

		if(num== 0) begin
			assign q = a[1] ^ b[1] ^ (a[1] & d[1])	 						^ kl[0] ^ kl[1] ^ rc[0];
		end
		if(num== 1) begin
			assign q = a[2] ^ (a[2] & d[1]) 		^ r2[0] ^ r2[1] 		^ kl[0];
		end                                         
		if(num== 2) begin                           
			assign q = a[1] & d[2]					^ r2[1] ^ r2[2] 		^ kl[1];
		end
		
		if(num== 3) begin
			assign q = a[2] ^ b[2] ^ (a[2] & d[2]) 	 						^ kl[0] ^ kl[1] ^ rc[1];
		end		                                    
		if(num== 4) begin                           
			assign q = a[0] ^ (a[0] & d[2]) 		^ r2[2] ^ r2[3]			^ kl[0];
		end		                                                   
		if(num== 5) begin                                          
			assign q = a[2] & d[0]					^ r2[3] ^ r2[4]        	^ kl[1];
		end		   

		if(num== 6) begin
			assign q = a[0] ^ b[0] ^ (a[0] & d[0]) 	  ^ kl[0] ^ kl[1]	 ^ rc[0] ^ rc[1];
		end		                                                    
		if(num== 7) begin                                           
			assign q = a[0] & d[1]					^ r2[4] ^ r2[5] ^ kl[0];
		end		                                                    
		if(num== 8) begin                                           
			assign q = a[1] ^ (a[1] & d[0])			^ r2[5] ^ r2[0] ^ kl[1];
		end

		if(num==9+0) begin
			assign q = a[1] ^ (a[1] & c[1]) ^ (c[1] & d[1]) 					^ mn[0] ^ mn[1] ^ rc[2];
		end                                                                     
		if(num==9+1) begin                                                      
			assign q = c[2] ^ (c[2] & a[1]) ^ (c[2] & d[1]) 	^ r1[0] ^ r1[1] ^ mn[0];
		end                                                                     
		if(num==9+2) begin                                                      
			assign q = (c[1] & a[2]) ^ (c[1] & d[2]) 			^ r1[1] ^ r1[2] ^ mn[1];
		end
		
		if(num==9+3) begin
			assign q = a[2] ^ (c[2] & a[2]) ^ (c[2] & d[2]) 					^ mn[0] ^ mn[1] ^ rc[3];
		end		                                                                
		if(num==9+4) begin                                                      
			assign q = c[0] ^ (c[0] & a[2]) ^ (c[0] & d[2]) 	^ r1[2] ^ r1[3] ^ mn[0];
		end		                                                                
		if(num==9+5) begin                                                      
			assign q = (c[2] & a[0]) ^ (c[2] & d[0]) 			^ r1[3] ^ r1[4] ^ mn[1];
		end		   

		if(num==9+6) begin
			assign q = a[0] ^ (c[0] & a[0]) ^ (c[0] & d[0])						^ mn[0] ^ mn[1] ^ rc[2] ^ rc[3];
		end		                                                                
		if(num==9+7) begin                                                      
			assign q = (c[0] & a[1]) ^ (c[0] & d[1]) 			^ r1[4] ^ r1[5] ^ mn[0];
		end		                                                                
		if(num==9+8) begin                                                      
			assign q = c[1] ^ (c[1] & a[0]) ^ (c[1] & d[0]) 	^ r1[5] ^ r1[0] ^ mn[1];
		end	


	endgenerate

endmodule

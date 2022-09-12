--
-- -----------------------------------------------------------------
-- COMPANY : Ruhr University Bochum
-- AUTHOR  : Aein Rezaei Shahmirzadi (aein.rezaeishahmirzadi@rub.de)
-- DOCUMENT: "Cryptanalysis of Efficient Masked Ciphers: Applications to Low Latency" TCHES 2022, Issue 1
-- -----------------------------------------------------------------
--
-- Copyright c 2021, Aein Rezaei Shahmirzadi
--
-- All rights reserved.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- INCLUDING NEGLIGENCE OR OTHERWISE ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-- Please see LICENSE and README for license and further instructions.
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY substitutionCombined IS
		PORT ( state0_s1  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state0_s2  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state0_s3  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 
				 state1_s1  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state1_s2  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 state1_s3  : IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 r          : IN  STD_LOGIC_VECTOR (37 DOWNTO 0);
				 
				 sel			: IN STD_LOGIC;
				 clk			: IN STD_LOGIC;
				 
				 result0_s1 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result0_s2 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result0_s3 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 
				 result1_s1 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result1_s2 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0);
				 result1_s3 : OUT  STD_LOGIC_VECTOR (63 DOWNTO 0));
END substitutionCombined;

ARCHITECTURE behavioral OF substitutionCombined IS
	
type MyArray is array (15 downto 0) of std_logic_vector(37 downto 0);
signal Masks : MyArray;
	
BEGIN

	Masks(0)  <= r(37 downto 36) & r(24) 		   & r(35 downto 25)  & r(23 downto 0);
	Masks(1)  <= r(37 downto 36) & r(25 downto 24) & r(35 downto 26) & r(23 downto 0);	
	Masks(2)  <= r(37 downto 36) & r(26 downto 24) & r(35 downto 27) & r(23 downto 0);	
	Masks(3)  <= r(37 downto 36) & r(27 downto 24) & r(35 downto 28) & r(23 downto 0);	
	Masks(4)  <= r(37 downto 36) & r(28 downto 24) & r(35 downto 29) & r(23 downto 0);	
	Masks(5)  <= r(37 downto 36) & r(29 downto 24) & r(35 downto 30) & r(23 downto 0);	
	Masks(6)  <= r(37 downto 36) & r(30 downto 24) & r(35 downto 31) & r(23 downto 0);	
	Masks(7)  <= r(37 downto 36) & r(31 downto 24) & r(35 downto 32) & r(23 downto 0);	
	Masks(8)  <= r(37 downto 36) & r(32 downto 24) & r(35 downto 33) & r(23 downto 0);	
	Masks(9)  <= r(37 downto 36) & r(33 downto 24) & r(35 downto 34) & r(23 downto 0);	
	Masks(10) <= r(37 downto 36) & r(34 downto 24) & r(35) 			  & r(23 downto 0);	
	Masks(11) <= r(37 downto 36) & r(35 downto 24) & r(23 downto 0);	
	Masks(12) <= r(37 downto 36) & r(24) & r(25) & r(26) & r(27) & r(28) & r(29) & r(30) & r(31) & r(32) & r(33) & r(34) & r(35) & r(23 downto 0);	
	Masks(13) <= r(37 downto 36) & r(25) & r(26) & r(27) & r(28) & r(29) & r(30) & r(31) & r(32) & r(33) & r(34) & r(35) & r(24) & r(23 downto 0);	
	Masks(14) <= r(37 downto 36) & r(24) & r(26) & r(25) & r(27) & r(28) & r(30) & r(29) & r(31) & r(32) & r(34) & r(33) & r(35) & r(23 downto 0);	
	Masks(15) <= r(37 downto 36) & r(24) & r(27) & r(26) & r(29) & r(28) & r(25) & r(30) & r(33) & r(32) & r(35) & r(34) & r(31) & r(23 downto 0);	

	substition_PRINCE:
		FOR i IN 0 TO 15 GENERATE
			sBoxCombined_PRINCE: Entity work.sBoxCombined
				PORT MAP ( input0_s1  => state0_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  input0_s2  => state0_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  input0_s3  => state0_s3(((i+1) * 4 - 1) DOWNTO i*4),
							  
							  input1_s1  => state1_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  input1_s2  => state1_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  input1_s3  => state1_s3(((i+1) * 4 - 1) DOWNTO i*4),
							  r  => Masks(i),
							  
							  sel		 	 => sel,
							  clk		 	 => clk,
							  
							  output0_s1 => result0_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  output0_s2 => result0_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  output0_s3 => result0_s3(((i+1) * 4 - 1) DOWNTO i*4),
							  
							  output1_s1 => result1_s1(((i+1) * 4 - 1) DOWNTO i*4),
							  output1_s2 => result1_s2(((i+1) * 4 - 1) DOWNTO i*4),
							  output1_s3 => result1_s3(((i+1) * 4 - 1) DOWNTO i*4));
		END GENERATE;
		
END behavioral;


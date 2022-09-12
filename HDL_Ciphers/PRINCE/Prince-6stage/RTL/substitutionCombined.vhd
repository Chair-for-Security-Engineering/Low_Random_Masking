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
				 r          : IN  STD_LOGIC_VECTOR (187 DOWNTO 0);
				 
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
	
	COMPONENT FourSboxes
	PORT(
		clk : IN std_logic;
		in1 : IN std_logic_vector(15 downto 0);
		in2 : IN std_logic_vector(15 downto 0);
		in3 : IN std_logic_vector(15 downto 0);          
		r 	 : IN std_logic_vector(187 downto 0);          
		out1 : OUT std_logic_vector(15 downto 0);
		out2 : OUT std_logic_vector(15 downto 0);
		out3 : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	COMPONENT shuffle_Randomness
	PORT(
		r : IN std_logic_vector(187 downto 0);          
		Shuffle_r0 : OUT std_logic_vector(187 downto 0);
		Shuffle_r1 : OUT std_logic_vector(187 downto 0);
		Shuffle_r2 : OUT std_logic_vector(187 downto 0);
		Shuffle_r3 : OUT std_logic_vector(187 downto 0)
		);
	END COMPONENT;
	
	Signal InAffin_s1: STD_LOGIC_VECTOR (63 DOWNTO 0);
	Signal InAffin_s2: STD_LOGIC_VECTOR (63 DOWNTO 0);
	Signal InAffin_s3: STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	Signal SInvOut_s1: STD_LOGIC_VECTOR (63 DOWNTO 0);
	Signal SInvOut_s2: STD_LOGIC_VECTOR (63 DOWNTO 0);
	Signal SInvOut_s3: STD_LOGIC_VECTOR (63 DOWNTO 0);
	
	
	
	type MyArray is array (3 downto 0) of std_logic_vector(187 downto 0);
	signal Masks : MyArray;
	
BEGIN

	A_PRINCE:
	FOR i IN 0 TO 15 GENERATE
	
		A_Pass_inst_s1: ENTITY work.A_Pass
		Port Map (
			input0	=> state0_s1(((i+1) * 4 - 1) DOWNTO i*4),
			input1 	=> state1_s1(((i+1) * 4 - 1) DOWNTO i*4),
			sel		=> sel,
			output	=> InAffin_s1(((i+1) * 4 - 1) DOWNTO i*4));

		A_Pass_inst_s2: ENTITY work.A_PassC
		Port Map (
			input0	=> state0_s2(((i+1) * 4 - 1) DOWNTO i*4),
			input1 	=> state1_s2(((i+1) * 4 - 1) DOWNTO i*4),
			sel		=> sel,
			output	=> InAffin_s2(((i+1) * 4 - 1) DOWNTO i*4));

		A_Pass_inst_s3: ENTITY work.A_Pass
		Port Map (
			input0	=> state0_s3(((i+1) * 4 - 1) DOWNTO i*4),
			input1 	=> state1_s3(((i+1) * 4 - 1) DOWNTO i*4),
			sel		=> sel,
			output	=> InAffin_s3(((i+1) * 4 - 1) DOWNTO i*4));
			
	END GENERATE;


	Inst_shuffle_Randomness: shuffle_Randomness PORT MAP(
		r => r,
		Shuffle_r0 => Masks(0),
		Shuffle_r1 => Masks(1),
		Shuffle_r2 => Masks(2),
		Shuffle_r3 => Masks(3)
	);


	substition_PRINCE:
		FOR i IN 0 TO 3 GENERATE
		
		Inst_FourSboxes: FourSboxes 
		PORT MAP(
			clk => clk,
			in1 => InAffin_s1(((i+1) * 16 - 1) DOWNTO i*16),
			in2 => InAffin_s2(((i+1) * 16 - 1) DOWNTO i*16),
			in3 => InAffin_s3(((i+1) * 16 - 1) DOWNTO i*16),
			r	=> Masks(i),
			out1 => SInvOut_s1(((i+1) * 16 - 1) DOWNTO i*16),
			out2 => SInvOut_s2(((i+1) * 16 - 1) DOWNTO i*16),
			out3 => SInvOut_s3(((i+1) * 16 - 1) DOWNTO i*16) );

		END GENERATE;
		
		
	A2_PRINCE:
	FOR i IN 0 TO 15 GENERATE
	
		A_inst_s1: ENTITY work.Affine
		Port Map (
			input		=> SInvOut_s1(((i+1) * 4 - 1) DOWNTO i*4),
			output	=> result0_s1(((i+1) * 4 - 1) DOWNTO i*4) );

		A_inst_s2: ENTITY work.Affine
		Port Map (
			input		=> SInvOut_s2(((i+1) * 4 - 1) DOWNTO i*4),
			output	=> result0_s2(((i+1) * 4 - 1) DOWNTO i*4));

		A_inst_s3: ENTITY work.AffineC
		Port Map (
			input		=> SInvOut_s3(((i+1) * 4 - 1) DOWNTO i*4),
			output	=> result0_s3(((i+1) * 4 - 1) DOWNTO i*4));
			
	END GENERATE;
	
	
	result1_s1	<= SInvOut_s1;
	result1_s2	<= SInvOut_s2;
	result1_s3	<= SInvOut_s3;
		
END behavioral;


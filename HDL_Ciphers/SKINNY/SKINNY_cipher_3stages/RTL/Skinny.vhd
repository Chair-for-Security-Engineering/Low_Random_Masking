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


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- ENTITY
----------------------------------------------------------------------------------
ENTITY Skinny IS
   PORT ( CLK        : IN  STD_LOGIC;
   		 -- CONTROL PORTS --------------------------------
          RESET      : IN  STD_LOGIC;
			 FRESH 		: IN  STD_LOGIC_VECTOR (63 DOWNTO 0);
          DONE       : OUT STD_LOGIC;
   	    -- KEY PORT -------------------------------------
          KEY1       : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          KEY2       : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          KEY3       : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
   	    -- DATA PORTS -----------------------------------
          PLAINTEXT1 : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          PLAINTEXT2 : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          PLAINTEXT3 : IN  STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          CIPHERTEXT1: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          CIPHERTEXT2: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0);
          CIPHERTEXT3: OUT STD_LOGIC_VECTOR ((64 - 1) DOWNTO 0));
END Skinny;


-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF Skinny IS

	COMPONENT TwoSbox
	PORT(
		clk : IN std_logic;
		in1 : IN std_logic_vector(7 downto 0);
		in2 : IN std_logic_vector(7 downto 0);
		in3 : IN std_logic_vector(7 downto 0);
		r : IN std_logic_vector(63 downto 0);          
		out1 : OUT std_logic_vector(7 downto 0);
		out2 : OUT std_logic_vector(7 downto 0);
		out3 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	CONSTANT W : INTEGER := 4;

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL SUB_IN1 : STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_IN2 : STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_IN3 : STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_OUT1: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_OUT2: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL SUB_OUT3: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);

	SIGNAL ROUND_KEY1: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL ROUND_KEY2: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);
	SIGNAL ROUND_KEY3: STD_LOGIC_VECTOR((64 - 1) DOWNTO 0);

	SIGNAL ROUND_CST : STD_LOGIC_VECTOR(      5  DOWNTO 0);
	SIGNAL KEY_EN    : STD_LOGIC;
	
	type Sbox_in is array (7 downto 0) of std_logic_vector(7 downto 0);
	signal Sbox_in1 : Sbox_in;
	signal Sbox_in2 : Sbox_in;
	signal Sbox_in3 : Sbox_in;
	
	signal Sbox_out1 : Sbox_in;
	signal Sbox_out2 : Sbox_in;
	signal Sbox_out3 : Sbox_in;
	
	type MyArray is array (7 downto 0) of std_logic_vector(63 downto 0);
	signal Masks : MyArray;

BEGIN

	-- ROUND FUNCTION -------------------------------------------------------------
	RF1 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, ROUND_CST,       ROUND_KEY1, PLAINTEXT1, SUB_IN1, SUB_OUT1, CIPHERTEXT1);
	RF2 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, (others => '0'), ROUND_KEY2, PLAINTEXT2, SUB_IN2, SUB_OUT2, CIPHERTEXT2);
	RF3 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, (others => '0'), ROUND_KEY3, PLAINTEXT3, SUB_IN3, SUB_OUT3, CIPHERTEXT3);
	-------------------------------------------------------------------------------
	Masks(0)  <= FRESH(63 downto 48 ) & FRESH(7*5-1  downto 0) & FRESH(47 downto 7*5 );
	Masks(1)  <= FRESH(63 downto 48 ) & FRESH(1*5-1  downto 0) & FRESH(47 downto   5 );	
	Masks(2)  <= FRESH(63 downto 48 ) & FRESH(2*5-1  downto 0) & FRESH(47 downto 2*5 );	
	Masks(3)  <= FRESH(63 downto 48 ) & FRESH(3*5-1  downto 0) & FRESH(47 downto 3*5 );	
	Masks(4)  <= FRESH(63 downto 48 ) & FRESH(4*5-1  downto 0) & FRESH(47 downto 4*5 );	
	Masks(5)  <= FRESH(63 downto 48 ) & FRESH(5*5-1  downto 0) & FRESH(47 downto 5*5 );	
	Masks(6)  <= FRESH(63 downto 48 ) & FRESH(6*5-1  downto 0) & FRESH(47 downto 6*5 );	
	Masks(7)  <= FRESH;
	-- SUBSTITUTION ---------------------------------------------------------------
	
	Sbox_in1(0) <= SUB_IN1((16 * W - 1) DOWNTO (15 * W)) & SUB_IN1((12 * W - 1) DOWNTO (11 * W));
	Sbox_in1(1) <= SUB_IN1(( 8 * W - 1) DOWNTO ( 7 * W)) & SUB_IN1(( 4 * W - 1) DOWNTO ( 3 * W));
	Sbox_in1(2) <= SUB_IN1((15 * W - 1) DOWNTO (14 * W)) & SUB_IN1((11 * W - 1) DOWNTO (10 * W));
	Sbox_in1(3) <= SUB_IN1(( 7 * W - 1) DOWNTO ( 6 * W)) & SUB_IN1(( 3 * W - 1) DOWNTO ( 2 * W));
	Sbox_in1(4) <= SUB_IN1((14 * W - 1) DOWNTO (13 * W)) & SUB_IN1((10 * W - 1) DOWNTO ( 9 * W));
	Sbox_in1(5) <= SUB_IN1(( 6 * W - 1) DOWNTO ( 5 * W)) & SUB_IN1(( 2 * W - 1) DOWNTO ( 1 * W));
	Sbox_in1(6) <= SUB_IN1((13 * W - 1) DOWNTO (12 * W)) & SUB_IN1(( 9 * W - 1) DOWNTO ( 8 * W));
	Sbox_in1(7) <= SUB_IN1(( 5 * W - 1) DOWNTO ( 4 * W)) & SUB_IN1(( 1 * W - 1) DOWNTO ( 0 * W));
	
	Sbox_in2(0) <= SUB_IN2((16 * W - 1) DOWNTO (15 * W)) & SUB_IN2((12 * W - 1) DOWNTO (11 * W));
	Sbox_in2(1) <= SUB_IN2(( 8 * W - 1) DOWNTO ( 7 * W)) & SUB_IN2(( 4 * W - 1) DOWNTO ( 3 * W));
	Sbox_in2(2) <= SUB_IN2((15 * W - 1) DOWNTO (14 * W)) & SUB_IN2((11 * W - 1) DOWNTO (10 * W));
	Sbox_in2(3) <= SUB_IN2(( 7 * W - 1) DOWNTO ( 6 * W)) & SUB_IN2(( 3 * W - 1) DOWNTO ( 2 * W));
	Sbox_in2(4) <= SUB_IN2((14 * W - 1) DOWNTO (13 * W)) & SUB_IN2((10 * W - 1) DOWNTO ( 9 * W));
	Sbox_in2(5) <= SUB_IN2(( 6 * W - 1) DOWNTO ( 5 * W)) & SUB_IN2(( 2 * W - 1) DOWNTO ( 1 * W));
	Sbox_in2(6) <= SUB_IN2((13 * W - 1) DOWNTO (12 * W)) & SUB_IN2(( 9 * W - 1) DOWNTO ( 8 * W));
	Sbox_in2(7) <= SUB_IN2(( 5 * W - 1) DOWNTO ( 4 * W)) & SUB_IN2(( 1 * W - 1) DOWNTO ( 0 * W));
	
	Sbox_in3(0) <= SUB_IN3((16 * W - 1) DOWNTO (15 * W)) & SUB_IN3((12 * W - 1) DOWNTO (11 * W));
	Sbox_in3(1) <= SUB_IN3(( 8 * W - 1) DOWNTO ( 7 * W)) & SUB_IN3(( 4 * W - 1) DOWNTO ( 3 * W));
	Sbox_in3(2) <= SUB_IN3((15 * W - 1) DOWNTO (14 * W)) & SUB_IN3((11 * W - 1) DOWNTO (10 * W));
	Sbox_in3(3) <= SUB_IN3(( 7 * W - 1) DOWNTO ( 6 * W)) & SUB_IN3(( 3 * W - 1) DOWNTO ( 2 * W));
	Sbox_in3(4) <= SUB_IN3((14 * W - 1) DOWNTO (13 * W)) & SUB_IN3((10 * W - 1) DOWNTO ( 9 * W));
	Sbox_in3(5) <= SUB_IN3(( 6 * W - 1) DOWNTO ( 5 * W)) & SUB_IN3(( 2 * W - 1) DOWNTO ( 1 * W));
	Sbox_in3(6) <= SUB_IN3((13 * W - 1) DOWNTO (12 * W)) & SUB_IN3(( 9 * W - 1) DOWNTO ( 8 * W));
	Sbox_in3(7) <= SUB_IN3(( 5 * W - 1) DOWNTO ( 4 * W)) & SUB_IN3(( 1 * W - 1) DOWNTO ( 0 * W));
				   
				   
	SB : FOR I IN 0 TO 7 GENERATE
	
			Inst_SKINNY_Sbox: TwoSbox PORT MAP(
				clk 	=> CLK,
				in1 	=> Sbox_in1(I), 
				in2 	=> Sbox_in2(I), 
				in3 	=> Sbox_in3(I), 
				r		=> Masks(I), 
				out1	=> Sbox_out1(I),
				out2	=> Sbox_out2(I),
				out3	=> Sbox_out3(I));
	
	END GENERATE;
	
	
	SUB_OUT1((16 * W - 1) DOWNTO (15 * W)) <= Sbox_out1(0)(7 downto 4);
	SUB_OUT1((12 * W - 1) DOWNTO (11 * W)) <= Sbox_out1(0)(3 downto 0);
	SUB_OUT1((08 * W - 1) DOWNTO (07 * W)) <= Sbox_out1(1)(7 downto 4);
	SUB_OUT1((04 * W - 1) DOWNTO (03 * W)) <= Sbox_out1(1)(3 downto 0);
	SUB_OUT1((15 * W - 1) DOWNTO (14 * W)) <= Sbox_out1(2)(7 downto 4);
	SUB_OUT1((11 * W - 1) DOWNTO (10 * W)) <= Sbox_out1(2)(3 downto 0);
	SUB_OUT1((07 * W - 1) DOWNTO (06 * W)) <= Sbox_out1(3)(7 downto 4);
	SUB_OUT1((03 * W - 1) DOWNTO (02 * W)) <= Sbox_out1(3)(3 downto 0);
	SUB_OUT1((14 * W - 1) DOWNTO (13 * W)) <= Sbox_out1(4)(7 downto 4);
	SUB_OUT1((10 * W - 1) DOWNTO (09 * W)) <= Sbox_out1(4)(3 downto 0);
	SUB_OUT1((06 * W - 1) DOWNTO (05 * W)) <= Sbox_out1(5)(7 downto 4);
	SUB_OUT1((02 * W - 1) DOWNTO (01 * W)) <= Sbox_out1(5)(3 downto 0);
	SUB_OUT1((13 * W - 1) DOWNTO (12 * W)) <= Sbox_out1(6)(7 downto 4);
	SUB_OUT1((09 * W - 1) DOWNTO (08 * W)) <= Sbox_out1(6)(3 downto 0);
	SUB_OUT1(( 5 * W - 1) DOWNTO ( 4 * W)) <= Sbox_out1(7)(7 downto 4);
	SUB_OUT1(( 1 * W - 1) DOWNTO ( 0 * W)) <= Sbox_out1(7)(3 downto 0);
	
	SUB_OUT2((16 * W - 1) DOWNTO (15 * W)) <= Sbox_out2(0)(7 downto 4);
	SUB_OUT2((12 * W - 1) DOWNTO (11 * W)) <= Sbox_out2(0)(3 downto 0);
	SUB_OUT2((08 * W - 1) DOWNTO (07 * W)) <= Sbox_out2(1)(7 downto 4);
	SUB_OUT2((04 * W - 1) DOWNTO (03 * W)) <= Sbox_out2(1)(3 downto 0);
	SUB_OUT2((15 * W - 1) DOWNTO (14 * W)) <= Sbox_out2(2)(7 downto 4);
	SUB_OUT2((11 * W - 1) DOWNTO (10 * W)) <= Sbox_out2(2)(3 downto 0);
	SUB_OUT2((07 * W - 1) DOWNTO (06 * W)) <= Sbox_out2(3)(7 downto 4);
	SUB_OUT2((03 * W - 1) DOWNTO (02 * W)) <= Sbox_out2(3)(3 downto 0);
	SUB_OUT2((14 * W - 1) DOWNTO (13 * W)) <= Sbox_out2(4)(7 downto 4);
	SUB_OUT2((10 * W - 1) DOWNTO (09 * W)) <= Sbox_out2(4)(3 downto 0);
	SUB_OUT2((06 * W - 1) DOWNTO (05 * W)) <= Sbox_out2(5)(7 downto 4);
	SUB_OUT2((02 * W - 1) DOWNTO (01 * W)) <= Sbox_out2(5)(3 downto 0);
	SUB_OUT2((13 * W - 1) DOWNTO (12 * W)) <= Sbox_out2(6)(7 downto 4);
	SUB_OUT2((09 * W - 1) DOWNTO (08 * W)) <= Sbox_out2(6)(3 downto 0);
	SUB_OUT2(( 5 * W - 1) DOWNTO ( 4 * W)) <= Sbox_out2(7)(7 downto 4);
	SUB_OUT2(( 1 * W - 1) DOWNTO ( 0 * W)) <= Sbox_out2(7)(3 downto 0);
	
	SUB_OUT3((16 * W - 1) DOWNTO (15 * W)) <= Sbox_out3(0)(7 downto 4);
	SUB_OUT3((12 * W - 1) DOWNTO (11 * W)) <= Sbox_out3(0)(3 downto 0);
	SUB_OUT3((08 * W - 1) DOWNTO (07 * W)) <= Sbox_out3(1)(7 downto 4);
	SUB_OUT3((04 * W - 1) DOWNTO (03 * W)) <= Sbox_out3(1)(3 downto 0);
	SUB_OUT3((15 * W - 1) DOWNTO (14 * W)) <= Sbox_out3(2)(7 downto 4);
	SUB_OUT3((11 * W - 1) DOWNTO (10 * W)) <= Sbox_out3(2)(3 downto 0);
	SUB_OUT3((07 * W - 1) DOWNTO (06 * W)) <= Sbox_out3(3)(7 downto 4);
	SUB_OUT3((03 * W - 1) DOWNTO (02 * W)) <= Sbox_out3(3)(3 downto 0);
	SUB_OUT3((14 * W - 1) DOWNTO (13 * W)) <= Sbox_out3(4)(7 downto 4);
	SUB_OUT3((10 * W - 1) DOWNTO (09 * W)) <= Sbox_out3(4)(3 downto 0);
	SUB_OUT3((06 * W - 1) DOWNTO (05 * W)) <= Sbox_out3(5)(7 downto 4);
	SUB_OUT3((02 * W - 1) DOWNTO (01 * W)) <= Sbox_out3(5)(3 downto 0);
	SUB_OUT3((13 * W - 1) DOWNTO (12 * W)) <= Sbox_out3(6)(7 downto 4);
	SUB_OUT3((09 * W - 1) DOWNTO (08 * W)) <= Sbox_out3(6)(3 downto 0);
	SUB_OUT3(( 5 * W - 1) DOWNTO ( 4 * W)) <= Sbox_out3(7)(7 downto 4);
	SUB_OUT3(( 1 * W - 1) DOWNTO ( 0 * W)) <= Sbox_out3(7)(3 downto 0);

   -- KEY EXPANSION --------------------------------------------------------------
   KE1 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY1, ROUND_KEY1);
   KE2 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY2, ROUND_KEY2);
   KE3 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY3, ROUND_KEY3);
	-------------------------------------------------------------------------------

   -- CONTROL LOGIC --------------------------------------------------------------
   CL : ENTITY work.ControlLogic PORT MAP (CLK, RESET, KEY_EN, DONE, ROUND_CST);
	-------------------------------------------------------------------------------

END Structural;

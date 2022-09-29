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
			 FRESH 		: IN  STD_LOGIC_VECTOR (39 DOWNTO 0);
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

	COMPONENT SKINNY_Sbox
	PORT(
		clk : IN std_logic;
		in1 : IN std_logic_vector(3 downto 0);
		in2 : IN std_logic_vector(3 downto 0);
		in3 : IN std_logic_vector(3 downto 0);
		rc : IN std_logic_vector(7 downto 0);
		r : IN std_logic_vector(23 downto 0);          
		out1 : OUT std_logic_vector(3 downto 0);
		out2 : OUT std_logic_vector(3 downto 0);
		out3 : OUT std_logic_vector(3 downto 0)
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
type MyArray is array (15 downto 0) of std_logic_vector(23 downto 0);
	signal Masks : MyArray;
BEGIN

	-- ROUND FUNCTION -------------------------------------------------------------
	RF1 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, ROUND_CST,       ROUND_KEY1, PLAINTEXT1, SUB_IN1, SUB_OUT1, CIPHERTEXT1);
	RF2 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, (others => '0'), ROUND_KEY2, PLAINTEXT2, SUB_IN2, SUB_OUT2, CIPHERTEXT2);
	RF3 : ENTITY work.RoundFunction PORT MAP (CLK, RESET, (others => '0'), ROUND_KEY3, PLAINTEXT3, SUB_IN3, SUB_OUT3, CIPHERTEXT3);
	-------------------------------------------------------------------------------
	Masks(0)  <= FRESH(23 downto   0 );
	Masks(1)  <= FRESH(1*1-1  downto 0) &   FRESH(23 downto   1 );	
	Masks(2)  <= FRESH(2*1-1  downto 0) &   FRESH(23 downto 2*1 );	
	Masks(3)  <= FRESH(3*1-1  downto 0) &   FRESH(23 downto 3*1 );	
	Masks(4)  <= FRESH(4*1-1  downto 0) &   FRESH(23 downto 4*1 );	
	Masks(5)  <= FRESH(5*1-1  downto 0) &   FRESH(23 downto 5*1 );	
	Masks(6)  <= FRESH(6*1-1  downto 0) &   FRESH(23 downto 6*1 );	
	Masks(7)  <= FRESH(7*1-1  downto 0) &   FRESH(23 downto 7*1 );
	Masks(8 )  <= FRESH(8 *1-1  downto 0) & FRESH(23 downto 8 *1 );	
	Masks(9 )  <= FRESH(9 *1-1  downto 0) & FRESH(23 downto 9 *1 );	
	Masks(10)  <= FRESH(10*1-1  downto 0) & FRESH(23 downto 10*1 );	
	Masks(11)  <= FRESH(11*1-1  downto 0) & FRESH(23 downto 11*1 );	
	Masks(12)  <= FRESH(12*1-1  downto 0) & FRESH(23 downto 12*1 );	
	Masks(13)  <= FRESH(13*1-1  downto 0) & FRESH(23 downto 13*1 );	
	Masks(14)  <= FRESH(14*1-1  downto 0) & FRESH(23 downto 14*1 );
	Masks(15)  <= FRESH(15*1-1  downto 0) & FRESH(23 downto 15*1 );
	-- SUBSTITUTION ---------------------------------------------------------------
	SB : FOR I IN 0 TO 15 GENERATE
	
			Inst_SKINNY_Sbox: SKINNY_Sbox PORT MAP(
				clk 	=> CLK,
				in1 	=> SUB_IN1 ((W * (I + 1) - 1) DOWNTO (W * I)), 
				in2 	=> SUB_IN2 ((W * (I + 1) - 1) DOWNTO (W * I)), 
				in3 	=> SUB_IN3 ((W * (I + 1) - 1) DOWNTO (W * I)), 
				r		=> Masks(I), 
				rc		=> FRESH(31 + (i mod 2)*8 downto 24 + (i mod 2)*8), 
				out1	=> SUB_OUT1((W * (I + 1) - 1) DOWNTO (W * I)),
				out2	=> SUB_OUT2((W * (I + 1) - 1) DOWNTO (W * I)),
				out3	=> SUB_OUT3((W * (I + 1) - 1) DOWNTO (W * I)));
	
	END GENERATE;

   -- KEY EXPANSION --------------------------------------------------------------
   KE1 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY1, ROUND_KEY1);
   KE2 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY2, ROUND_KEY2);
   KE3 : ENTITY work.KeyExpansion PORT MAP (CLK, RESET, KEY_EN, KEY3, ROUND_KEY3);
	-------------------------------------------------------------------------------

   -- CONTROL LOGIC --------------------------------------------------------------
   CL : ENTITY work.ControlLogic PORT MAP (CLK, RESET, KEY_EN, DONE, ROUND_CST);
	-------------------------------------------------------------------------------

END Structural;

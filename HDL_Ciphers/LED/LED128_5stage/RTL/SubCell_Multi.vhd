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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SubCell_Multi is
GENERIC ( count : POSITIVE);
    Port ( clk:  IN  STD_LOGIC;
			  in0:  IN  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			  in1:  IN  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			  in2:  IN  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			  EN :  IN  STD_LOGIC;
			  r  :  IN  STD_LOGIC_VECTOR (23 DOWNTO 0);
			  out0  :  OUT  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			  out1  :  OUT  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0);
			  out2  :  OUT  STD_LOGIC_VECTOR (4*count-1 DOWNTO 0)
	 );
end SubCell_Multi;

architecture Behavioral of SubCell_Multi is
	COMPONENT Present_Sbox
	PORT(
		clk : IN std_logic;
		in1 : IN std_logic_vector(3 downto 0);
		in2 : IN std_logic_vector(3 downto 0);
		in3 : IN std_logic_vector(3 downto 0);
		r : IN std_logic_vector(23 downto 0);          
		EN : IN std_logic;          
		out1 : OUT std_logic_vector(3 downto 0);
		out2 : OUT std_logic_vector(3 downto 0);
		out3 : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
begin

	GEN :
	FOR i IN 0 TO count-1 GENERATE
	
		Inst_PRESENT_Sbox_3shares: Present_Sbox PORT MAP(
			clk => clk,
			in1 => in0((i+1)*4-1 downto i*4),
			in2 => in1((i+1)*4-1 downto i*4),
			in3 => in2((i+1)*4-1 downto i*4),
			r => r,
			EN => EN,
			out1 => out0((i+1)*4-1 downto i*4),
			out2 => out1((i+1)*4-1 downto i*4),
			out3 => out2((i+1)*4-1 downto i*4)
		);
			
	END GENERATE;
end Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  port (
    A : in std_logic_vector(31 downto 0);
    ALU_Control : in std_logic_vector(2 downto 0);
    ALU_Out : out std_logic_vector(31 downto 0);
    B : in std_logic_vector(31  downto 0);
    N : out std_logic;
    Z : out std_logic
  );
end entity; 

architecture RTL of ALU is
  signal ALU_Result : std_logic_vector(31 downto 0);   
  
begin
  ALU_Out <= ALU_Result;
  N <= ALU_Result(31);
  Z <= '1' when (ALU_Result=(ALU_Result'range=>'0')) else '0'; 
  process (ALU_Control, A, B)
  begin 
	  case ALU_Control is
		when "000" =>
			ALU_Result <= std_logic_vector(unsigned(A) + unsigned(B));
		when "001" =>
			ALU_Result <= std_logic_vector(unsigned(A) - unsigned(B));
		when "010" =>
			ALU_Result <= A and B;
		when "011" =>
			ALU_Result <= A or B;
		when "100" =>
			ALU_Result <= A nor B;
		when "101" =>
			case B(4 downto 0) is
			when "00001" => ALU_Result <= A(30 downto 0) & "0"; 
			when "00010" => ALU_Result <= A(29 downto 0) & "00"; 
			when "00011" => ALU_Result <= A(28 downto 0) & "000"; 
			when "00100" => ALU_Result <= A(27 downto 0) & "0000"; 
			when "00101" => ALU_Result <= A(26 downto 0) & "00000"; 
			when "00110" => ALU_Result <= A(25 downto 0) & "000000"; 
			when "00111" => ALU_Result <= A(24 downto 0) & "0000000"; 
			when "01000" => ALU_Result <= A(23 downto 0) & "00000000"; 
			when "01001" => ALU_Result <= A(22 downto 0) & "000000000"; 
			when "01010" => ALU_Result <= A(21 downto 0) & "0000000000"; 
			when "01011" => ALU_Result <= A(20 downto 0) & "00000000000"; 
			when "01100" => ALU_Result <= A(19 downto 0) & "000000000000"; 
			when "01101" => ALU_Result <= A(18 downto 0) & "0000000000000"; 
			when "01110" => ALU_Result <= A(17 downto 0) & "00000000000000"; 
			when "01111" => ALU_Result <= A(16 downto 0) & "000000000000000"; 
			when "10000" => ALU_Result <= A(15 downto 0) & "0000000000000000"; 
			when "10001" => ALU_Result <= A(14 downto 0) & "00000000000000000"; 
			when "10010" => ALU_Result <= A(13 downto 0) & "000000000000000000"; 
			when "10011" => ALU_Result <= A(12 downto 0) & "0000000000000000000"; 
			when "10100" => ALU_Result <= A(11 downto 0) & "00000000000000000000"; 
			when "10101" => ALU_Result <= A(10 downto 0) & "000000000000000000000"; 
			when "10110" => ALU_Result <= A( 9 downto 0) & "0000000000000000000000"; 
			when "10111" => ALU_Result <= A( 8 downto 0) & "00000000000000000000000"; 
			when "11000" => ALU_Result <= A( 7 downto 0) & "000000000000000000000000"; 
			when "11001" => ALU_Result <= A( 6 downto 0) & "0000000000000000000000000"; 
			when "11010" => ALU_Result <= A( 5 downto 0) & "00000000000000000000000000"; 
			when "11011" => ALU_Result <= A( 4 downto 0) & "000000000000000000000000000"; 
			when "11100" => ALU_Result <= A( 3 downto 0) & "0000000000000000000000000000"; 
			when "11101" => ALU_Result <= A( 2 downto 0) & "00000000000000000000000000000"; 
			when "11110" => ALU_Result <= A( 1 downto 0) & "000000000000000000000000000000"; 
			when "11111" => ALU_Result <= A( 0)		     & "0000000000000000000000000000000";
			when others  => ALU_Result <= A;
			end case;
		when others =>
			ALU_Result <= std_logic_vector(unsigned(A) + unsigned(B));
		end case;
	end process;
end architecture;


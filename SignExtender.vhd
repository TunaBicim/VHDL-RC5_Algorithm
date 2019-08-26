library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtender is
  port (
    In_sig : in std_logic_vector(15 downto 0);
    Out_sig : out std_logic_vector(31 downto 0)
  );
end entity; 

architecture RTL of SignExtender is
begin
	Out_sig <= std_logic_vector(resize(signed(In_sig),32));

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux2x1 is
  generic(DataW: integer:= 32);
  port (
    In0 : in std_logic_vector(DataW - 1  downto 0);
    In1 : in std_logic_vector(DataW - 1 downto 0);
    Out_sig : out std_logic_vector(DataW - 1 downto 0);
    Select_sig : in std_logic
  );
end entity; 

architecture RTL of Mux2x1 is
begin
  process (Select_sig, In1, In0) is
  begin
    if Select_sig = '1' then
      Out_sig <= In1;
    else
      Out_sig <= In0;
    end if;
  end process;
end architecture;


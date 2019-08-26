-- This VHDL was converted from Verilog using the
-- Icarus Verilog VHDL Code Generator 10.1 (stable) (v10_1_1)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
  port (
    PC_in : in std_logic_vector(31 downto 0);
    PC_out : out std_logic_vector(31 downto 0):= X"00000000";
    clock : in std_logic;
    reset : in std_logic
  );
end entity; 

architecture RTL of PC is
begin

  process (clock) is
  begin
    if rising_edge(clock) then
      if reset = '0' then
        PC_out <= X"00000000";
      else
        PC_out <= PC_in;
      end if;
    end if;
  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor_TB is
end Processor_TB;

architecture RTL of Processor_TB is

component Processor is
port (Clock : in std_logic;
      Reset :in std_logic
     );
end component;

signal Clock : std_logic := '0';
signal Reset : std_logic := '0';

constant CLK_PERIOD : time := 10 ns;

begin
   DUT : Processor port map (
            Clock => Clock,
            Reset => Reset
        );      

   Clk_process :process
   begin
        Clock <= '0';
        wait for CLK_PERIOD/2;  
        Clock <= '1';
        wait for CLK_PERIOD/2;  
   end process;
    
  Stimulus_process: process
   begin        
        Reset <='1';                    --then apply reset for 2 clock cycles.
        wait for CLK_PERIOD*2;
        reset <='0';                    --then pull down reset for 20 clock cycles.
        wait;
  end process;

end;
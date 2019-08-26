library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DM is
  port (
    addr : in std_logic_vector(31 downto 0);
    clk : in std_logic;
	reset : in std_logic;
    read_data : out std_logic_vector(31 downto 0);
    write_data : in std_logic_vector(31 downto 0);
    write_enable : in std_logic;
	backdoor: out std_logic_vector(63 downto 0);
	backdoor_in : in std_logic_vector(31 downto 0);
	backdoor_addr: in std_logic_vector(6 downto 0);
	backdoor_write: in std_logic
  );
end entity; 

architecture RTL of DM is
  type memory_Type is array (127 downto 0) of std_logic_vector(31 downto 0);
  signal memory : memory_Type:=memory_Type'(
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"9E3779B9",X"B7E15163", 
X"EEDBA521",X"6D8F4B15",X"91CEA910",X"01A55563",X"51B241BE",X"19465F91",X"65046380",X"F6CC1431", 
X"43192304",X"30D76B0A",X"AE162167",X"4DBFCA76",X"3B0A1D2B",X"61A78BB8",X"A7EFC249",X"36C03196",
X"DEDE871A",X"A7901C49",X"2799A4DD",X"4B792F99",X"713AD82D",X"D427686B",X"11A83A5D",X"3125065D",
X"F621ED22",X"513E1454",X"284B8303",X"70F83B8A",X"460C6085",X"46F8E8C5",X"1A37F7FB",X"9BBBD8C8"
);
begin    

    process (clk)
	   BEGIN                                                   
	    if rising_edge(clk) then
			if reset = '0' then 
				--memory <= (OTHERS => (OTHERS => '0'));
		    elsif (backdoor_write = '1') then
				memory(to_integer(unsigned(backdoor_addr))) <= backdoor_in;
			elsif (write_enable = '1') THEN 
				memory(to_integer(unsigned(addr(6 downto 0)))) <= write_data; 	
			end if;
			backdoor <= memory(31) & memory(30);
		end If;
	end process;
	read_data <= memory(to_integer(unsigned(addr(6 downto 0))));
end architecture;


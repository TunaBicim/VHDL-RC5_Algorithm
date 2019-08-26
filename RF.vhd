library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RF is
  port (
    clock : in std_logic;
	reset : in std_logic;
    read_addr1 : in std_logic_vector(4 downto 0);
    read_addr2 : in std_logic_vector(4 downto 0);
    read_data1 : out std_logic_vector(31 downto 0);
    read_data2 : out std_logic_vector(31 downto 0);
    write_addr : in std_logic_vector(4 downto 0);
    write_data : in std_logic_vector(31 downto 0);
    write_enable : in std_logic;
	backdoor: out std_logic_vector(159 downto 0);
	backdoor_in: in std_logic_vector(31 downto 0);
	backdoor_write: in std_logic
  );
end entity; 

architecture RTL of RF is
  type register_file_Type is array (31 downto 0) of std_logic_vector(31 downto 0);
  signal register_file : register_file_Type:=register_file_Type'(X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",
X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000",X"00000000"); 
begin
  
read_data1 <= register_file(to_integer(unsigned(read_addr1)));
read_data2 <= register_file(to_integer(unsigned(read_addr2)));

  process (clock) is
  begin
    if rising_edge(clock) then
		if reset = '0' then 
			register_file <= (OTHERS => (OTHERS => '0'));
	    elsif backdoor_write = '1' then
			register_file(18) <= backdoor_in;
		elsif write_enable = '1' then
			register_file(to_integer(unsigned(write_addr))) <= write_data;
		end if;
		backdoor <= register_file(10) & register_file(3) & register_file(2) & register_file(1) & register_file(0);
    end if;
  end process;
end architecture;


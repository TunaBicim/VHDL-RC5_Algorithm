library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IM is
  port (
    addr : in std_logic_vector(31 downto 0);
    read_data : out std_logic_vector(31 downto 0)
  );
end entity; 

architecture RTL of IM is
  type memory_Type is array (127 downto 0) of std_logic_vector(31 downto 0);
  signal memory : memory_Type:=memory_Type'(
X"30000005",X"23E1001E",X"23E0001F",X"2CDFFFEC",--7C        
X"04410000",X"04200000",X"04C60001",X"00821001",--78        
X"1CC40000",X"2C9FFFF9",X"04420001",X"289FFFFB",--74        
X"08A50001",X"14420001",X"03A22005",X"28BF0006",--70        
X"03C12805",X"00821007",X"00032005",X"00411005",--6C        
X"00001009",X"00211809",X"28C70013",X"07E7001A",--68        
X"07E60002",X"00410801",X"1FE20001",X"00400001",--64        
X"1FE20000",X"1FE1001E",X"1FE0001F",X"30000005",--60        
X"23E1001F",X"23E0001E",X"00220803",X"1FE20000",--5C        
X"00020003",X"1FE20001",X"2CDFFFEB",X"04410000",--58        
X"04200000",X"08E70001",X"00621007",X"00031805",--54        
X"00411005",X"00001009",X"00211809",X"2C9FFFF9",--50        
X"04000001",X"289FFFFB",X"08A50001",X"14000001",--4C        
X"03A02005",X"28BF0006",X"01052803",X"03C12805",--48        
X"00040003",X"1CE40000",X"28C70014",X"14DD001F",--44        
X"07E80020",X"07E70019",X"07E60001",X"1FE1001F",--40        
X"1FE0001E",X"00000000",X"30000005",X"2D87FFDF",--3C        
X"05EE0000",X"2DC60001",X"05510000",X"05CE0001",--38        
X"21CA0000",X"2FEBFFFA",X"096B0001",X"054A0001",--34        
X"2BE50001",X"154A0001",X"015D2805",X"2BEB0006",--30
X"023E5805",X"022A5001",X"02308801",X"1DCA0000",--2C
X"058C0001",X"01ED6803",X"2DED0002",X"05500000",--28
X"05AD0001",X"21AA0000",X"2FEBFFFA",X"096B0001",--24
X"054A0001",X"2BE50001",X"154A0001",X"015D2805",--20
X"07EB0003",X"01505001",X"02308001",X"1DAA0000",--1C
X"07F10000",X"07F00000",X"07E6001E",X"07E70003",--18
X"2DEEFFFC",X"05CE0001",X"00200001",X"21C00000",--14
X"1FE10021",X"1FE00020",X"07EE0000",X"07EF001A",--10
X"07EC0000",X"00000000",X"00000000",X"00000000",--0C
X"30000005",X"2A760034",X"2A750057",X"2A740006",--08
X"07F20000",X"06530000",X"2BF2FFFF",X"16BD001E",--04
X"07F40001",X"07F50002",X"07F60003",X"07FE001F" --00               
);                                                                                                                                          
begin                                                                                                                                     
 
  read_data <= memory(to_integer(unsigned(addr(6 downto 0))));                                                                              
  
end architecture;                                                                                                                     
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Processor is
  port (
	Clock : in std_logic;
	Reset : in std_logic;
	Ledout: out std_logic_vector(15 downto 0);
	SW: in std_logic_vector(15 downto 0);
    SSEG_CA: out  STD_LOGIC_VECTOR (7 downto 0);
    SSEG_AN: out  STD_LOGIC_VECTOR (7 downto 0);
	BTNC,BTND,BTNL,BTNR,BTNU: in std_logic
  );
end entity; 

architecture RTL of Processor is

signal Halt: std_logic;
signal MemtoReg :  std_logic;
signal MemWrite :  std_logic;
signal PCSrc :  std_logic;
signal ALUControl :  std_logic_vector(2 downto 0);
signal ALUSrc :  std_logic;
signal RegSrc :  std_logic;
signal RegWrite :  std_logic;
signal Jump: std_logic;
signal RegDst:  std_logic;
signal Flags :  std_logic_vector(1 downto 0);
signal Funct : std_logic_vector(5 downto 0);
signal Op :  std_logic_vector(5 downto 0);
signal Clock_in: std_logic; 
signal Clock_buf: std_logic;
signal Backdoor_DM: std_logic_vector(63 downto 0);
signal Backdoor_RF: std_logic_vector(159 downto 0);
signal Backdoor_RF_In: std_logic_vector(31 downto 0);
signal Backdoor_RF_Write: std_logic;
signal Backdoor_DM_In : std_logic_vector(31 downto 0);
signal Backdoor_DM_Addr: std_logic_vector(6 downto 0);
signal Backdoor_DM_Write: std_logic;
signal Clock_source: std_logic:= '0';
signal Data_In: std_logic_vector(31 downto 0);
signal SevSeg: std_logic_vector(31 downto 0);
signal PC_out_top: std_logic_vector(6 downto 0);

component SevenSeg_Top is
    Port ( 
           CLK 			: in  STD_LOGIC;
			HexVal 		: in STD_LOGIC_VECTOR(31 downto 0);
           SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN 		: out  STD_LOGIC_VECTOR (7 downto 0)
			);
end component;

component Datapath is
  port (
	Clock : in std_logic;
	MemtoReg : in std_logic;
	MemWrite : in std_logic;
	PCSrc : in std_logic;
    ALUControl : in std_logic_vector(2 downto 0);
    ALUSrc : in std_logic;
	RegWrite : in std_logic;
	Reset: in std_logic;
	Jump:	in std_logic;
    RegDst: in std_logic;
    Flags : out std_logic_vector(1 downto 0);
    Funct : out std_logic_vector(5 downto 0);
   	Op : out std_logic_vector(5 downto 0);
   	Backdoor_RF: out std_logic_vector(159 downto 0);
    Backdoor_DM: out std_logic_vector(63 downto 0);
	Backdoor_RF_In: in std_logic_vector(31 downto 0);
	Backdoor_RF_Write: in std_logic;
	Backdoor_DM_In : in std_logic_vector(31 downto 0);
	Backdoor_DM_Addr: in std_logic_vector(6 downto 0);
	Backdoor_DM_Write: in std_logic;
	PC_out_top: out std_logic_vector(6 downto 0)
  );
end component;

component Controller is 
  port (
    Clock : in std_logic;
	Op : in std_logic_vector(5 downto 0);
    Funct : in std_logic_vector(5 downto 0);
	Flags : in std_logic_vector(1 downto 0);
	MemtoReg : out std_logic;
	MemWrite : out std_logic;
	PCSrc: out std_logic;
	ALUControl : out std_logic_vector(2 downto 0);
    ALUSrc : out std_logic;
	RegDst: out std_logic;
	RegWrite : out std_logic;
	Jump: out std_logic;
	Halt: out std_logic
  );
end component;

begin 

process (BTND) is 
begin 
	if rising_edge(BTND) then 
		Clock_source <= not Clock_source; 
	end if;
end process;
process (Clock_in) is 
begin
	if rising_edge(Clock_in) then 
		Backdoor_RF_Write <= '0';
		Backdoor_DM_Write <= '0';
		if (BTNU = '1') then 
			if SW(14) = '1' then 
				if SW(15) = '1' then 
					Backdoor_RF_Write <= '1';
				else 
					case SW(2 downto 0) is
						when "000" =>  SevSeg <= Backdoor_RF(31 downto 0);
						when "001" =>  SevSeg <= Backdoor_RF(63 downto 32);
						when "010" =>  SevSeg <= Backdoor_RF(95 downto 64);
						when "011" =>  SevSeg <= Backdoor_RF(127 downto 96);
						when "100" =>  SevSeg <= Backdoor_RF(159 downto 128);
						when others => SevSeg <= Backdoor_RF(31 downto 0);
					end case;
				end if;
			elsif SW(14) = '0' then 
				if SW(15) = '1' then 
					Backdoor_DM_Write <= '1';
				else
					case SW(0) is
						when '0' =>  SevSeg <= Backdoor_DM(31 downto 0);
						when '1' =>  SevSeg <= Backdoor_DM(63 downto 32);
						when others => SevSeg <= Backdoor_DM(31 downto 0);
					end case;
				end if; 
			end if;
		elsif (BTNL = '1') then 
			Data_In(31 downto 16) <= SW;
			SevSeg <= Data_In;
		elsif (BTNR = '1') then 
			Data_In(15 downto 0) <= SW;
			SevSeg <= Data_In;
		end if;
	end if;
end process;
Backdoor_RF_In <= X"0000000" & SW(3 downto 0);
Backdoor_DM_In <= Data_In;
Backdoor_DM_Addr <= SW(6 downto 0);
Clock_buf <= ((not Clock_source)and Clock) or (Clock_source and BTNC); 		
Clock_in <= Clock_buf and (not Halt);
Ledout (7) <= BTNU;
Ledout (9) <= BTNR or BTNL;
Ledout (14) <= BTNC;
Ledout (13) <= Clock_in;
Ledout (12) <= Backdoor_RF_Write;
Ledout (11) <= Backdoor_DM_Write;
Ledout (10) <= Reset;
Ledout(15) <= Clock_source;
Ledout (8) <= BTND;
Ledout (6 downto 0) <= PC_out_top;
 
 DP : Datapath 
	port map (
		Clock => Clock_in,
		MemtoReg => MemtoReg,
		MemWrite => MemWrite,
		PCSrc => PCSrc,
		ALUControl => ALUControl,
		ALUSrc => ALUSrc,
		RegWrite => RegWrite,
		Reset => Reset,
		Jump =>	Jump,
		RegDst => RegDst,
		Flags => Flags,
		Funct => Funct,
		Op => Op,
		Backdoor_RF => Backdoor_RF,
        Backdoor_DM => Backdoor_DM,
		Backdoor_RF_In => Backdoor_RF_In,
        Backdoor_RF_Write => Backdoor_RF_Write,
		Backdoor_DM_In => Backdoor_DM_In,
		Backdoor_DM_Addr => Backdoor_DM_Addr,
		Backdoor_DM_Write => Backdoor_DM_Write,
		PC_out_top => PC_out_top
	);
 
 CN: Controller
	port map(
		Clock => Clock_in,
		MemtoReg => MemtoReg,
		MemWrite => MemWrite,
		PCSrc => PCSrc,
		ALUControl => ALUControl,
		ALUSrc => ALUSrc,
		RegWrite => RegWrite,
		Jump =>	Jump,
		RegDst => RegDst,
		Flags => Flags,
		Funct => Funct,
		Op => Op,
		Halt => Halt
	);
	
 SS: SevenSeg_Top 
    port map ( 
           CLK => Clock,
			HexVal => SevSeg,
           SSEG_CA => SSEG_CA,		   
           SSEG_AN => SSEG_AN	
			);

 
end architecture;
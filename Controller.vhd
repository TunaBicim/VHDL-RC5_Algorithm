library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller is
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
end entity; 

architecture RTL of Controller is    
 
begin
  process (Funct, Op, Flags) is
  begin
    MemtoReg <= '0';
	MemWrite <= '0';
    PCSrc <= '0';
	ALUControl <= "000";
	ALUSrc <= '0';
    RegDst <= '0';
    RegWrite <= '0';
	Jump <= '0';
	Halt <= '0';
    if Op = "000000" then
		MemtoReg <= '0';
		MemWrite <= '0';
		PCSrc <= '0';
		ALUSrc <= '0';
		RegDst <= '1';
		RegWrite <= '1';
		case Funct is
			when "000001" => ALUControl <= "000";
			when "000011" => ALUControl <= "001";
			when "000101" => ALUControl <= "010";
			when "000111" => ALUControl <= "011";
			when "001001" => ALUControl <= "100";
			when others => ALUControl <= "000";
		end case;
    elsif Op = "000001" then
        MemtoReg <= '0';
		MemWrite <= '0';
		PCSrc <= '0';
		ALUControl <= "000";
		ALUSrc <= '1';
		RegDst <= '0';
		RegWrite <= '1';
	elsif  Op = "000010" then
		MemtoReg <= '0';
		MemWrite <= '0';
		PCSrc <= '0';
		ALUControl <= "001";
		ALUSrc <= '1';
		RegDst <= '0';
		RegWrite <= '1';
	elsif  Op = "000011" then
		MemtoReg <= '0';
		MemWrite <= '0';
		PCSrc <= '0';
		ALUControl <= "010";
		ALUSrc <= '1';
		RegDst <= '0';
		RegWrite <= '1';
	elsif  Op = "000100" then
		MemtoReg <= '0';
		MemWrite <= '0';
		PCSrc <= '0';
		ALUControl <= "011";
		ALUSrc <= '1';
		RegDst <= '0';
		RegWrite <= '1';
	elsif  Op = "000101" then
		MemtoReg <= '0';
		MemWrite <= '0';
		PCSrc <= '0';
		ALUControl <= "101";
		ALUSrc <= '1';
		RegDst <= '0';
		RegWrite <= '1';
	elsif  Op = "000111" then
		MemtoReg <= '1';
		MemWrite <= '0';
		PCSrc <= '0';
		ALUControl <= "000";
		ALUSrc <= '1';
		RegDst <= '0';
		RegWrite <= '1';
	elsif  Op = "001000" then
		MemtoReg <= '0';
		MemWrite <= '1';
		PCSrc <= '0';
		ALUControl <= "000";
		ALUSrc <= '1';
		RegDst <= '0';
		RegWrite <= '0';
	elsif Op = "001001" then 
		MemtoReg <= '0';
		MemWrite <= '0';
		ALUControl <= "001";
		ALUSrc <= '0';
		RegDst <= '0';
		RegWrite <= '0';
		if Flags = "10" then 
			PCSrc <= '1';
		end if;
	elsif Op = "001010" then 
		MemtoReg <= '0';
		MemWrite <= '0';
		ALUControl <= "001";
		ALUSrc <= '0';
		RegDst <= '0';
		RegWrite <= '0';
		if Flags = "01" then 
			PCSrc <= '1';
		end if;
	elsif Op = "001011" then 
		MemtoReg <= '0';
		MemWrite <= '0';
		ALUControl <= "001";
		ALUSrc <= '0';
		RegDst <= '0';
		RegWrite <= '0';
		if Flags = "00" then 
			PCSrc <= '1';
		elsif Flags = "10" then 
			PCSrc <= '1';
		end if;
	elsif Op = "001100" then 
		Jump <= '1';
	elsif Op = "111111" then 
		Halt <= '1';
    end if;
  end process;
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath is
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
	Backdoor_RF_Write: in std_logic;
	Backdoor_RF_In: in std_logic_vector(31 downto 0);
	Backdoor_DM_In : in std_logic_vector(31 downto 0);
	Backdoor_DM_Addr: in std_logic_vector(6 downto 0);
	Backdoor_DM_Write: in std_logic;
	PC_out_top: out std_logic_vector(6 downto 0)
	
  );
end entity; 

architecture RTL of Datapath is
  signal ALUResult : std_logic_vector(31 downto 0);
  signal SignImm : std_logic_vector(31 downto 0);  
  signal Instr : std_logic_vector(31 downto 0);  
  signal PC_out: std_logic_vector(31 downto 0);  
  signal PCPlus4 : std_logic_vector(31 downto 0);  
  signal PCBranch : std_logic_vector(31 downto 0); 
  signal PC_in : std_logic_vector(31 downto 0);
  signal PC_val : std_logic_vector(31 downto 0);  
  signal SrcA : std_logic_vector(31 downto 0); 
  signal SrcB : std_logic_vector(31 downto 0);   
  signal ReadData : std_logic_vector(31 downto 0); 
  signal Result : std_logic_vector(31 downto 0);  
  signal WriteReg : std_logic_vector(4 downto 0);  
  signal Rd: std_logic_vector(4 downto 0);  
  signal Rt: std_logic_vector(4 downto 0);  
  signal Rs: std_logic_vector(4 downto 0);
  signal Z: std_logic;
  signal N: std_logic;
  signal WriteData: std_logic_vector(31 downto 0);
  signal ImmSrc: std_logic_vector(15 downto 0);
  signal PCBranchImm: std_logic_vector(31 downto 0);
  signal JumpAddr: std_logic_vector(31 downto 0);

  component ALU is
    port (
		A : in std_logic_vector(31 downto 0);
		ALU_Control : in std_logic_vector(2 downto 0);
		ALU_Out : out std_logic_vector(31 downto 0);
		B : in std_logic_vector(31  downto 0);
		N : out std_logic;
		Z : out std_logic
  );
  end component;
  
  component DM is
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
	end component; 
  
  component IM is
    port (
		addr : in std_logic_vector(31 downto 0);
		read_data : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component Adder is
    port (
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Result : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component Mux2x1 is
	generic(DataW: integer:= 32);
	port (
		In0 : in std_logic_vector(DataW - 1  downto 0);
		In1 : in std_logic_vector(DataW - 1 downto 0);
		Out_sig : out std_logic_vector(DataW - 1 downto 0);
		Select_sig : in std_logic
		);
  end component;
  
  component PC is
    port (
      PC_in : in std_logic_vector(31 downto 0);
      PC_out : out std_logic_vector(31 downto 0);
      clock : in std_logic;
      reset : in std_logic
    );
  end component;
  
  component RF is
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
		backdoor_in : in std_logic_vector(31 downto 0);
		backdoor_write: in std_logic
    );
  end component;
  
  component SignExtender is
    port (
		In_sig : in std_logic_vector(15 downto 0);
		Out_sig : out std_logic_vector(31 downto 0)
    );
  end component;

begin
  PC_out_top <= PC_out(6 downto 0);
  Op <= Instr(31 downto 26);
  Funct <= Instr(5 downto 0);
  Rd <= Instr(15 downto 11);
  Rt <= Instr(20 downto 16);
  Rs <= Instr(25 downto 21);
  ImmSrc <= Instr(15 downto 0);
  Flags <= N & Z;
  PCBranchImm <= SignImm(31 downto 0);
  JumpAddr <= "000000" & Instr(25 downto 0);
  
  ALU1: ALU
    port map (
      A => SrcA,
      ALU_Control => ALUControl,
      ALU_Out => ALUResult,
      B => SrcB,
      N => N,
      Z => Z
    );
	
  DataMemory: DM
    port map (
      addr => ALUResult,
      clk => Clock,
	  reset => Reset,
      read_data => ReadData,
      write_data => WriteData,
      write_enable => MemWrite,
	  backdoor => Backdoor_DM,
	  backdoor_in => Backdoor_DM_In,
	  backdoor_addr => Backdoor_DM_Addr,
	  backdoor_write => Backdoor_DM_Write
    );
  
  InstructionMemory: IM
    port map (
	  addr => PC_out,
      read_data => Instr
    );
  
  PC4: Adder
    port map (
      A => PC_out,
      B => X"00000001",
      Result => PCPlus4
    );

  PCMux: Mux2x1
	generic map(DataW => 32)
    port map (
      In0 => PCPlus4,
      In1 => PCBranch,
      Out_sig => PC_val,
      Select_sig => PCSrc
    );
	
	JumpMux: Mux2x1
	generic map(DataW => 32)
    port map (
      In0 => PC_val,
      In1 => JumpAddr,
      Out_sig => PC_in,
      Select_sig => Jump
    );
	
  ProgramCounter: PC
    port map (
      PC_in => PC_in,
      PC_out => PC_out,
      clock => Clock,
      reset => Reset
    );
  
   WriteRegMux: Mux2x1
	generic map(DataW => 5)
    port map (
      In0 => Rt,
      In1 => Rd,
      Out_sig => WriteReg,
      Select_sig => RegDst
    );
  
  RegisterFile: RF
    port map (
      clock => Clock,
	  reset => Reset, 
      read_addr1 => Rs,
      read_addr2 => Rt,
      read_data1 => SrcA,
      read_data2 => WriteData,
      write_addr => WriteReg,
      write_data => Result,
      write_enable => RegWrite,
      backdoor => Backdoor_RF,
	  backdoor_in => Backdoor_RF_In,
      backdoor_write => Backdoor_RF_Write
    );
  
  ResultMux: Mux2x1
	generic map(DataW => 32)
    port map (
      In0 => ALUResult,
      In1 => ReadData,
      Out_sig => Result,
      Select_sig => MemtoReg
    );

  SE1: SignExtender
    port map (
      In_sig => ImmSrc,
      Out_sig => SignImm
    );

	BranchAdder: Adder
		port map (
		A => PCBranchImm,
		B => PCPlus4,
		Result => PCBranch
	);
	
  SrcBMux: Mux2x1
    generic map(DataW => 32)
	port map (
      In0 => WriteData,
      In1 => SignImm,
      Out_sig => SrcB,
      Select_sig => ALUSrc
    );
	
end architecture;

DECODER:
LD R0 R31 31 /R0 = B   	X"1FE0001E" /R0 = A 
LD R1 R31 30 /R1 = A    X"1FE1001F"	/R1 = B 		
ADDI R6 R31 1 /R6 = 1   X"07E60001" /End of S array 
ADDI R7 R31 25 /R7 = 25 X"07E70019" /Start address of S since we are going backwards this time 
ADDI R8 R31 32          X"07E80020" /R8 = 32 which is used for calculating left rotate amount that corresponds to actual right rotates 
LSL R29 R6 30           X"14DD001F" /Obsolete done on main now.
BEQ  R6 R7 20           X"28C70014" /If it is the end of loop go to the end 
LD R4 R7 0              X"1CE40000" /Load S value 
SUB R0 R0 R4            X"00040003" /Subtract S from A or B 
AND R5 R1 R30           X"03C12805" /R30 has 1F which gives us rotation amount when anded with A or B
SUB R5 R8 R5            X"01052803" /Find left rotate number that corresponds to same right rotate 
BEQ R5 R31              X"28BF0006" /If rotation amount is 0 end rotation 
AND R4 R0 R29           X"03A02005" /R4 is used to check the MSB of the A or B 
LSL R0 R0 1             X"14000001" /Shift left once
SUBI R5 R5 1            X"08A50001" /Reduce rotation amount
BEQ R4 R31 -5           X"289FFFFB" /If there was no overflow return 
ADDI R0 R0 1            X"04000001" /Add 1 to fix rotation 
BNE R4 R31 -7           X"2C9FFFF9" /If there was an overflow return after adding the value 
NOR R3 R1 R1 /R3 = Bbar X"00211809" /Use nor as inverter to get Abar
NOR R2 R0 R0 /R2 = Abar X"00001009" /Use nor as inverter to get Bbar
AND R2 R2 R1            X"00411005" /B.Abar 
AND R3 R3 R0            X"00031805" /A.Bbar 
OR R2 R2 R3             X"00621007" /A.Bbar + B.Abar = A xor B      
SUBI R7 R7 1            X"08E70001" /Point to previous memory location 
ADDI R0 R1 0            X"04200000" /Move R1 to R0  
ADDI R1 R2 0            X"04410000" /Move R2 to R1 
BNE R6 R31              X"2CDFFFEB" /If the loop is not over return bac
LD R2 R31 1 			X"1FE20001" /Load S[1]
SUB R0 R0 R2 			X"00020003" /B = B - S[1]
LD R2 R31 0 			X"1FE20000" /Load S[0]
SUB R1 R1 R2            X"00220803" /A = A - S[0]
STR R0 R31 30           X"23E0001E" /Store A 
STR R1 R31 31			X"23E1001F" /Store B 

JMP   					X"30000005"
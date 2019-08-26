ENCODER:
LD R0 R31 31 		  		X"1FE0001F" /R0 = A 
LD R1 R31 30 		        X"1FE1001E" /R1 = B 
LD R2 R31 0 				X"1FE20000" /R2 = S[0]
ADD R0 R0 R2 				X"00400001" /Add S[0] to A
LD R2 R31 1 				X"1FE20001" /R2 = S[1]
ADD R1 R1 R2 				X"00410801" /Add S[1] to B
ADDI R6 R31 2 /R7 = 2       X"07E60002" /Start of i for loop
ADDI R7 R31 26 /R8 = 26     X"07E7001A" /End of i 
BEQ  R6 R7 19               X"28C70013" /End the loop if i reaches 26 
NOR R3 R1 R1 /R3 = Bbar     X"00211809" /Use nor as inverter to get Abar
NOR R2 R0 R0 /R2 = Abar     X"00001009" /Use nor as inverter to get Bbar
AND R2 R2 R1                X"00411005" /B.Abar 
AND R4 R3 R0                X"00032005" /A.Bbar 
OR R2 R2 R4                 X"00821007" /A.Bbar + B.Abar = A xor B
AND R5 R1 R30               X"03C12805" /R30 has 1F which gives us rotation amount when anded with A or B 
BEQ R5 R31 6                X"28BF0006" /If rotation amount is 0 end rotation 
AND R4 R2 R29               X"03A22005" /R4 is used to check the MSB of the A or B 
LSL R2 R2 1                 X"14420001" /Shift left once
SUBI R5 R5 1                X"08A50001" /Reduce rotation amount
BEQ R4 R31 -5               X"289FFFFB" /If there was no overflow return 
ADDI R2 R2 1                X"04420001" /Add 1 to fix rotation 
BNE R4 R31 -7               X"2C9FFFF9" /If there was an overflow return after adding the value 
LD R4 R6 0                  X"1CC40000" /Load S 
ADD  R2 R2 R4               X"00821001" /Add S to A or B 
ADDI R6 R6 1                X"04C60001" /Point to next memory location
ADDI R0 R1 0                X"04200000" /Move R1 to R0  
ADDI R1 R2 0                X"04410000" /Move R2 to R1 
BNE R6 R31 -20              X"2CDFFFEC" /If the loop is not over return back 
STR R0 R31 31               X"23E0001F" /After loop is over store A 
STR R1 R31 30				X"23E1001E" /Store B 


JMP 125  					X"30000005" 

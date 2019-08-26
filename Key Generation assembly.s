Key Generation:
/R31 contains the value 0
ADDI R12 R12 1     X"07EC0000" /Load 0 into maximum itreations 
ADDI R15 R31 26    X"07EF001A" /Array end address also used as User Key start address
ADDI R14 R31 0     X"07EE0000" /S array memory start address 
LD R0 R31 32       X"1FE00020" /Load Pw 
LD R1 R31 33       X"1FE10021" /Load Qw 
STR R0 R14 0       X"21C00000" /Store Pw to S[R14]
ADD R0 R0 R1       X"00200001" /Add Qw to S[R14-i]
ADDI R14 R14 1     X"05CE0001" /R14 += 1
BNE R14 R15 -4     X"2DEEFFFC" /If it is not the end of the array repeat from Store instruction
		
ADDI R7 R31 3      X"07E70003" /R7 is used as modulus value for j
ADDI R6 R31 30     X"07E6001E" /R6 Holds end address of user key
ADDI R16 R31 0 	   X"07F00000" /R16 Holds previous A value
ADDI R17 R31 0 	   X"07F10000" /R17 Holds previous B value
/R10 is used as a register to load S and L values loaded from memory
LD R10 R13 0       X"1DAA0000" /Load S[i]
ADD R16 R16 R17    X"02308001" /Add Aprev to Bprev
ADD R10 R10 R16    X"01505001" /Add Aprev and Bprev sum to S[i]
ADDI R11 R31 3     X"07EB0003" /R11 is used as a rotation amount register 
AND R5 R10 R29     X"015D2805" /R5 is used to check the MSB of the sum of S, A and B
LSL R10 R10 1      X"154A0001" /Shift left once
BEQ R5 R31 1       X"2BE50001" /If R5 is 1 there was a overflow, need to add 1 to fix rotation
ADDI R10 R10 1     X"054A0001" /Add 1 to fix rotation 
SUBI R11 R11 1     X"096B0001" /Reduce rotation amount 
BNE R11 R31 -6     X"2FEBFFFA" /If rotation amount is not 0 do rotate loop again
STR R10 R13 0      X"21AA0000" /After the rotation is over store S back to memory 
ADDI R13 R13 1     X"05AD0001" /Point to next location (increment i)
ADDI R16 R10 0     X"05500000" /Copy A to Aprev 
BNE R13 R15 2      X"2DED0002" /Check i mod t
SUB R13 R13 R15    X"01ED6803" /If i reached modulus value subtract that from i 
ADDI R12 R12 1     X"058C0001" /If i modulus value was reached one of 3 iterations that will be done is finished
LD R10 R14 0       X"1DCA0000" /Load L[j]
ADD R17 R17 R16    X"02308801" /Add Aprev and Bprev 
ADD R10 R10 R17    X"022A5001" /Add L[j] and Aprev and Bprev 
AND R11 R17 R30    X"023E5805" /R30 has 1F which gives us rotation amount when anded with Aprev + Bprev 
BEQ R11 R31 6	   X"2BEB0006" /If rotation amount is 0 end rotation 
AND R5 R10 R29     X"015D2805" /R5 is used to check the MSB of the sum of L, A and B
LSL R10 R10 1      X"154A0001" /Shift left once
BEQ R5 R31 1       X"2BE50001" /If R5 is 1 there was a overflow, need to add 1 to fix rotation
ADDI R10 R10 1     X"054A0001" /Add 1 to fix rotation 
SUBI R11 R11 1     X"096B0001" /Reduce rotation amount 
BNE R11 R31 -6     X"2FEBFFFA" /If rotation amount is not 0 do rotate loop again
STR R10 R14 0      X"21CA0000" /After the rotation is over store L back to memory
ADDI R14 R14 1     X"05CE0001" /Point to next location (increment j)
ADDI R17 R10 0     X"05510000" /Copy B to Bprev 
BNE R14 R6 1       X"2DC60001" /Check j mod c
ADDI R14 R15 0     X"05EE0000" /If j reached modulus value subtract c from j 
BNE R12 R7 -33     X"2D87FFDF" /If the loop is not done 78 times go back to start 

JMP 			   X"30000005"


.text
.global _start
.equ JTAG_UART_BASE, 0x10001000

.equ DATA_OFFSET, 0
.equ STATUS_OFFSET, 4
.equ WSPACE_MASK, 0xFFFF
.org 0
_start:
movia sp, 0x7FFFFC
movia r2, STR
call PrintString
movia r3, LIST
movia r5, N
ldw r5, 0(r5)
call DisplayByteList
call LowDigitByteList
call DisplayByteList

_end:
break

#-----------------------------------------------------------------------------------------

PrintString:
subi sp, sp, 12 #adjust stack pointer to accomodate any register needed
stw ra, 8(sp)   #Save return address because we call another subroutine
stw r4, 4(sp)   #Temporary register to hold the pointer
stw r3, 0(sp)   #it is the ch variable reading the byte at str_ptr address

ps_loop:
ldb r3, 0(r2) #read byte at str_ptr address
ps_if:
bne r3, r0, ps_end_if #Branches to the end of the if statement if this is not true
ps_then:
br ps_end_loop #Unconditional branch to the end of the loop
ps_end_if:
mov r4, r2 #move it temporarily to another register
mov r2, r3 #Plug in the value for the PrintChar subroutine
call PrintChar #call the subroutine to print the character
mov r2, r4 #Restore the value of register r2 from register r4
addi r2, r2, 1 #increment the string pointer
br ps_loop #branch back up into the loop
ps_end_loop:
ldw r3, 0(sp) #restore the original value of register r3
ldw r4, 4(sp) #restore the original value of register r4
ldw ra, 8(sp) #restore the original value of the return address
addi sp, sp, 12 #recover the space allocated for the stack
ret

#-----------------------------------------------------------------------------------------

PrintHexByte:
subi sp, sp, 12 #Allocate space on the stack
stw r4, 8(sp) #save register r4 as a temporary register
stw r3, 4(sp) #save register r3 as a temporary register
stw ra, 0(sp) #save the return address of this subroutine

srli r3, r2, 4 #Shift the bits in r2 right by 4 and save the result in r3
mov r4, r2 #Save the contents of register r2 into register r4
mov r2, r3 #Transfer the result from r3 into r2
call PrintHexDigit #call the PrintHexDigit function to print out the first bit in the hex digit

mov r2, r4 #Recover the value from register r4 into register r2
andi r3, r2, 0x0F #AND register r2 with 0x0F and save the result in register r3
mov r2, r3 #Now move the result from register r3 into register r2
call PrintHexDigit #call the PrintHexDigit to print out the second bit in the hex digit

ldw ra, 0(sp) #recover the changed register and re-adjust the stack pointer
ldw r3, 4(sp)
ldw r4, 8(sp)
addi sp, sp, 12
ret

#-----------------------------------------------------------------------------------------

PrintHexDigit:
subi sp, sp , 12 #Allocate the stack pointer to store any registers that are changing within the subroutine
stw r2, 8(sp)
stw r3, 4(sp)
stw ra, 0(sp)

mov r3, r2 #Move the hexdigit from r2 to r3

phd_if:
movi r2, 9 #Move the immediate value 9 into register r2
ble r3, r2, phd_else #Check if the hexdigit is indeed greater than 9
phd_then:
subi r2, r3, 10 #Subtract the hexdigit by 10 and save the result in register r2
addi r2, r2, 'A' #Add the hexdigit by 'A' and save the result in register r2
br phd_end_if
phd_else:
addi r2, r3, '0' #add hexdigit by '0' and save the result in register r2
phd_end_if:
call PrintChar #Call the PrintChar subroutine to print out the hexdigit

ldw r2, 8(sp) #Readjust the stack pointer to recover space allocated to the changed register in the subroutine
ldw r3, 4(sp)
ldw ra, 0(sp)
addi sp, sp , 12
ret

#-----------------------------------------------------------------------------------------

PrintChar:
subi sp, sp, 8 #adjust the stack pointer down to reserve space
stw r3,4(sp) #save value of register r3 so it can be a temp
stw r4,0(sp) #save value of register r4 so it can be a temp
movia r3, JTAG_UART_BASE #point to first memory-mapped I/O register
pc_loop:
ldwio r4, STATUS_OFFSET(r3) #read bits from status register
andhi r4, r4, WSPACE_MASK #mask off lower bits to isolate upper bits
beq r4, r0, pc_loop #if upper bits are zero, loop again
stwio r2, DATA_OFFSET(r3) #otherwise, write character to data register
ldw r3, 4(sp) #restore value of r3 from stack
ldw r4, 0(sp) #restore value of r4 from stack
addi sp, sp, 8 #readjust stack pointer up to deallocate space
ret #return to calling routine

DisplayByteList:
subi sp, sp, 16
stw ra, 12(sp)
stw r3, 8(sp) #list pointer
stw r4, 4(sp) #list element
stw r5, 0(sp) #n
dbl_loop:
ldbu r4, 0(r3)
movi r2, '{'
call PrintChar
mov r2, r4
call PrintHexByte
movi r2, '}'
call PrintChar
movi r2, ' '
call PrintChar
subi r5, r5, 1
addi r3, r3, 1
bgt r5, r0, dbl_loop
movi r2, '\n'
call PrintChar
ldw r5, 0(sp)
ldw r4, 4(sp)
ldw r3, 8(sp)
ldw ra, 12(sp)
addi sp, sp, 16
ret

LowDigitByteList:
	subi sp,sp,12
	stw r3, 8(sp)
	stw r4, 4(sp)
	stw r5, 0(sp)
ldbl_loop:
	ldbu r4, 0(r3)
	andi r4, r4, 0x0F
	stb  r4, 0(r3)
	addi r3, r3, 1
	subi r5, r5, 1
	bgt r5, r0, ldbl_loop
	
	ldw r3, 8(sp)
	ldw r4, 4(sp)
	ldw r5, 0(sp)
	addi sp,sp,12
	ret

	  .org 0x1000
N:	  .word 4
LIST: .byte 0x3C,0xB8,0xF2,0x7A
STR:  .asciz "Lab3\n"

.end
.equ JTAG_UART_BASE, 0x10001000
.equ DATA_OFFSET, 0
.equ STATUS_OFFSET, 4
.equ WSPACE_MASK, 0xFFFF
.equ CHAR_MASK, 0x00FF
.equ VALID_MASK, 0x8000
.equ STACK_ADDR, 0x7FFFFC

.text
.global _start
.org 0x0000

_start:
	
	movia sp, STACK_ADDR
	movia r2, START
	movia r3, LIST
	movia r4, SIZE
	ldw r4, 0(r4)
	movi r5, ' '
	mov r6, r0
	call printString

main_loop:
	call getChar
	call printChar
	stb r2, 0(r3)
if_blank:
	bne r2, r5, end_blank
then_blank:
	addi r6, r6, 1
	stw r6, COUNT(r0)
end_blank:
	addi r3, r3, 1
	subi r4, r4, 1
	bne r4, r0, main_loop

	movia r2, COUNTSTR
	call printString
	mov r2, r6
	call printHexDigit

	stw r6, COUNT(r0)

_end:
	break

# All accept arguments in r2

printChar:
	subi sp,sp, 8
	stw r3, 4(sp)
	stw r4, 0(sp)

	movia r3, JTAG_UART_BASE
pc_loop:
	ldwio r4, STATUS_OFFSET(r3)
	andhi r4, r4, WSPACE_MASK
	beq r4, r0, pc_loop

	stwio r2, DATA_OFFSET(r3)
	
	ldw r3, 4(sp)
	ldw r4, 0(sp)
	addi sp,sp, 8
	ret

getChar:
	subi sp,sp, 12
	stw r3, 8(sp)
	stw r4, 4(sp)
	stw r5, 0(sp)

	movia r3, JTAG_UART_BASE
gc_loop:
	ldwio r4, DATA_OFFSET(r3)
	andi r5, r4, VALID_MASK
	beq r5, r0, gc_loop
	andi r2, r4, CHAR_MASK

	ldw r3, 8(sp)
	ldw r4, 4(sp)
	ldw r5, 0(sp)
	addi sp,sp, 12
	ret
	
	

printString:
	subi sp,sp,16
	stw r5, 12(sp)
	stw r4, 8(sp)
	stw r2, 4(sp)
	stw ra, 0(sp)

ps_loop:
	ldb r5, 0(r2)
	beq r5, r0, ps_end
	mov r4, r2
	mov r2, r5
	call printChar
	mov r2, r4
	addi r2, r2, 1
	br ps_loop

ps_end:

	ldw r5, 12(sp)
	ldw r4, 8(sp)
	ldw r2, 4(sp)
	ldw ra, 0(sp)
	addi sp,sp, 16
	ret

printHexDigit:
	subi sp,sp, 12
	stw r3, 8(sp)
	stw r4, 4(sp)
	stw ra, 0(sp)

phd_if:
	movi r3, 9
	ble r2, r3, phd_else

phd_then: 
	subi r2, r2, 10
	addi r2, r2, 'A'
	br phd_end_if

phd_else:
	addi r2, r2, '0'

phd_end_if:
	call printChar

	ldw r3, 8(sp)
	ldw r4, 4(sp)
	ldw ra, 0(sp)
	addi sp,sp, 12
	ret


.org 0x1000
LIST: .skip 16
COUNT: .skip 4
SIZE: .word 15
START: .asciz "Enter 15 characters:\n"
COUNTSTR: .asciz "\n# of space chars. = "
.end

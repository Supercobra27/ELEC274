.equ	JTAG_UART_BASE,	0x10001000	# address of first JTAG UART register
.equ	DATA_OFFSET,	0		# address of JTAG UART data register
.equ	STATUS_OFFSET,	4		# offset of JTAG UART status register
.equ    WSPACE_MASK,	0xFFFF		# used in AND operation to check status

.text
.global _start
.org 0x0000

_start:
	movia	sp,0x7FFFFC		# initialize stack pointer
	movia 	r2,LIST1
	movia 	r3,LIST2
	movia 	r4,N
	movi	r16,8 # high_val
	ldw		r4,0(r4)
	call 	CheckLists
	stw 	r8,RESULT(r0)
	movi	r2,'\n'
	call 	PrintChar
	movia	r18,LIST1
	call 	SummarizeList
	movia 	r18,LIST2
	call 	SummarizeList
	
	
_end:
	break

CheckLists:
	subi	sp,sp,20
	stw 	r4,16(sp) # orig n
	stw		r5,12(sp) # list x element
	stw		r6,8(sp) # list y element
	stw		r7,4(sp) # count
	stw 	r17,0(sp) # list element sum
	
	movi 	r7,0
	
check_loop:
if:
	ldw 	r5,0(r2)
	ldw		r6,0(r3)
	add		r17,r5,r6
	bge		r17,r16,else
then:
	addi 	r7,r7,1
	br 		end_if
else:
	stw		r0,0(r2)
	stw		r16,0(r3)
end_if:
	addi	r2,r2,4
	addi 	r3,r3,4
	subi	r4,r4,1
	bgt		r4,r0,check_loop
	
	mov		r8,r7
	
	ldw 	r4,16(sp) # orig n
	ldw		r5,12(sp) # list x element
	ldw		r6,8(sp) # list y element
	ldw		r7,4(sp) # count
	ldw 	r17,0(sp) # list element sum
	addi	sp,sp,20
	ret
	
	
SummarizeList:
	subi 	sp,sp,16
	stw 	r4,12(sp) # N
	stw		r5,8(sp) # list element
	stw		r18,4(sp) # list on stack
	stw		ra,0(sp) # return address
	
	
summary_loop:
if_zero:
	ldw		r5,0(r18)
	bne		r5,r0,else_star
then_set:
	movi	r2,'0'
	call 	PrintChar
	br 		end_if_bad
else_star:
	movi	r2,'*'
	call	PrintChar
end_if_bad:
	addi	r18,r18,4
	subi	r4,r4,1

	bgt		r4,r0,summary_loop
	movi 	r2,'\n'
	call 	PrintChar
	ldw 	r4,12(sp) # N
	ldw		r5,8(sp) # list element
	ldw		r18,4(sp) # list on stack
	ldw		ra,0(sp) # ret address
	addi 	sp,sp,16
	ret
	
PrintChar:
	subi	sp, sp, 8		# adjust stack pointer down to reserve space
	stw	r3, 4(sp)		# save value of register r3 so it can be a temp
	stw	r4, 0(sp)		# save value of register r4 so it can be a temp
	movia	r3, JTAG_UART_BASE	# point to first memory-mapped I/O register
pc_loop:
	ldwio	r4, STATUS_OFFSET(r3)	# read bits from status register
	andhi	r4, r4, WSPACE_MASK	# mask off lower bits to isolate upper bits
	beq	r4, r0, pc_loop		# if upper bits are zero, loop again
	stwio	r2, DATA_OFFSET(r3)	# otherwise, write character to data register
	ldw	r3, 4(sp)		# restore value of r3 from stack
	ldw	r4, 0(sp)		# restore value of r4 from stack
	addi	sp, sp, 8		# readjust stack pointer of r4 from stack
	
	ret				# return to calling subroutine
	
		.org 0x1000
			
LIST1: 	.word 6, 5, 4 
LIST2: 	.word 5, 3, 1
N:		.word 3
RESULT:	.skip 4
	
	.end
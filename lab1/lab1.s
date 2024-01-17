.text
.global _start
.org 0x0000

_start:
	#load in constants
	ldw r2, F(r0)
	ldw r3, S(r0)
	ldw r4, K(r0)
	ldw r6, B(r0)
	ldw r7, C(r0)
	
	addi r2, r2, 3
	stw r2, W(r0)
	add r5, r2, r3
	sub r5, r5, r4
	stw r5, X(r0)
	sub r6, r5, r6
	mul r8, r6, r7
	stw r8, A(r0)

_end:
	br _end

	.org 0x1000
W:	.skip 4 #7
X:	.skip 4 #8
A:	.skip 4 #10
F:	.word 4
S:	.word 6
K:	.word 5
C:	.word 2
B:	.word 3

.end


.equ JTAG_ADD, 0x10001000   # Address of the JTAG UART register
.equ DATA, 0                # Data location for JTAG
.equ STATUS, 4              # Status offset for status location
.equ MASK, 0xFFFF           # Whitespace mask to isolate upper bits


# Hello World in Nios II ASM on DE0


.text
.global _start
.org 0x0000

_start:

    movia sp, 0x7FFFFC
    movia r6, Str
    call printStr


_end:
    break

printChar:
    subi sp, sp, 8
    stw r3, 0(sp)
    stw r4, 4(sp)

    movia r3, JTAG_ADD      # r3 <--- [JTAG_ADD]
poll:
    ldwio r4, STATUS(r3)    # r4 <--- [STATUS]+[JTAG_ADD]
    andhi r4, r4, MASK      # r4 AND 0xFFFF
    beq r4, r0, poll        # If == 0, repeat loop

    stwio r2, DATA(r3)      # Store value from IO

    ldw r3, 0(sp)
    ldw r4, 4(sp)
    addi sp, sp, 8

    ret

printStr:
    subi sp, sp, 8
    stw ra, 0(sp)

    movi r5, 13

cloop:

    ldw r2, 0(r6)
    call printChar

    addi r6,r6,4
    subi r5,r5,1

    bne r5, r0, cloop



    ldw ra, 0(sp)

    addi sp, sp, 8

    ret

.org 0x1000
# Str: .word 'H','e','l','l','o','\t','W','o','r','l','d','!'
Str: .word "Hello World!"
Size: .word 13

.end






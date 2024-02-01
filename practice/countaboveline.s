.text
.global _start
.org 0x0000

# Need to fix

countAboveLine:
        subi sp, sp, 24
        stw r7, 0(sp)           # Put SIZE value on the stack
        stw r16, 4(sp)          # Put register value on stack
        stw r17, 8(sp)          # Put register value on stack
        stw r18, 12(sp)         # Put register value on stack
        stw r19, 16(sp)         # Put register value on stack
        stw r20, 20(sp)         # Put register value on stack


check_loop:

        ldw r16, 0(r2)          # Get X_LIST[i]
        ldw r17, 0(r3)          # Get Y_LIST[i]

        ldw r18, 0(r4)          # Get SLOPE
        ldw r19, 0(r5)          # Get INTERCEPT THIS BROKE

        mul r20, r16, r18       # Do multiplication of X_LIST[i]*SLOPE
        add r20, r20, r19       # Do addition of r20+INTERCEPT

if:

        blt r17, r20, end_if    # If Y_LIST[i] > r20 (mx+b)

then:

        addi r6, r6, 1          # Increment COUNT

end_if:

        addi r2, r2, 4          # Shift X_LIST by 4
        addi r3, r3, 4          # Shift Y_LIST by 4
        subi r7, r7, 1          # Decrement Counter

        bgt r7, r0, check_loop  # Branch loop

        ldw r7, 0(sp)           # Put stack value in register
        ldw r16, 4(sp)          # Put stack value in register
        ldw r17, 8(sp)          # Put stack value in register
        ldw r18, 12(sp)         # Put stack value in register
        ldw r19, 16(sp)         # Put stack value in register
        ldw r20, 20(sp)         # Put stack value in register

        stw r6, 0(r6)           # Store in COUNT

        addi sp, sp, 24         # Reallocate Stack Memory
        ret

.org 0x1000

_start:

        movia sp, 0x7FFFFC      # Initialize Stack Pointer
        movia r2, X_LIST        # Initialize X_LIST
        movia r3, Y_LIST        # Initialize Y_LIST
        movia r4, SLOPE         # Initialize SLOPE
        movia r5, INTERCEPT     # Initialize INTERCEPT
        movia r7, SIZE          # Initialize SIZE
        movia r6, COUNT         # Initialize COUNT
        mov r6, r0              # Initialize COUNT Register to 0
        mov r16, r0             # Initialize Unused Register to 0
        mov r17, r0             # Initialize Unused Register to 0
        mov r18, r0             # Initialize Unused Register to 0
        mov r19, r0             # Initialize Unused Register to 0
        mov r20, r0             # Initialize Unused Register to 0

        ldw r4, 0(r4)           # Get value from Memory
        ldw r5, 0(r5)           # Get value from Memory
        ldw r7, 0(r7)           # Get value from Memory

        call countAboveLine     # Call Subroutine

_end:
        break

.org 0x2000

X_LIST:      .word 1,2,3        # X-Coord List
Y_LIST:      .word 7,-1,9       # Y-Coord List
SLOPE:       .word 2            # Slope
INTERCEPT:   .word 4            # Intercept
SIZE:        .word 3            # Size of list(s)
COUNT:       .skip 4            # Store points above here


.end
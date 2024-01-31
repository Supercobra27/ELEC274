.text
.global _start
.org 0x0000

_start:
    ldw r5, numItems(r0)    # load numItems from memory into register 1
    movi r2, list           # gets the first pointer to the list
    movi r3, 0              # holds the sum
LOOP:
    ldw r4, 0(r2)           # gets the next item from the list
    add r3,r3,r4            # adds to the sum
    subi r5, r5, 1          # subtract the counter
    addi r2, r2, 4          # increments the list
    bgt r5, r0, LOOP        # checks condition, if r5 > 0, branch to LOOP

    stw r3, sum(r0)         # store the final sum
_end: 
    br _end


# memory goes here

.org 0x1000

sum: .skip 4
numItems: .word 3
list: .word 1,2,3

.end

.text
.global _start
.org 0x0000

copyList:
    subi sp, sp, 12             # stack allocation
    stw r3, 0(sp)               # store r3 on stack (counter)
    stw r4, 4(sp)               # store r4 on stack (list reader)
    stw r6, 8(sp)               # store r6 on stack (positive counter)
    mov r6, r0                  # set pos. counter to zero (r0)

copy_loop:

if:

    ldw r4, 0(r2)               # load element from list into r4
    blt r4, r0, end_if          # branch if item is less than 0

then:

    stw r4, 0(r5)               # store item at r5 -> CLIST
    addi r6, r6, 1              # increment the pos. counter

end_if:

    addi r5, r5, 4              # move the CLIST along memory
    addi r2, r2, 4              # move the LIST along memory
    subi r3, r3, 1              # decrease the counter

    bgt r3, r0, copy_loop       # continue the loop if r3 (N) > 0

    stw r6, 0(r8)               # store the count in r8 -> COUNT

    ldw r3, 0(sp)               # load back r3 from stack
    ldw r4, 4(sp)               # load back r4 from stack
    ldw r6, 8(sp)               # load back r6 from stack
    addi sp, sp, 12             # realloc stack memory

    ret                         # return


_start:
    movia sp, 0x7FFFFC          # init stack pointer
    movia r2, LIST              # let r2 -> LIST
    movia r3, N                 # let r3 -> N
    movia r5, CLIST             # let r5 -> CLIST (copied list)
    movia r8, COUNT             # let r8 -> COUNT (count of positive numbers)
    ldw r3, 0(r3)               # load r3, with N's actual immediate value
    call copyList               # call copyList

_end:
    break

.org 0x1000
    LIST: .word 4,-5,15,-4,7    # list of numbers
    CLIST: .skip 20             # skips 4*N
    N: .word 5                  # Items in LIST
    COUNT: .skip 4              # Count of positive items

.end
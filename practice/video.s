.text
.global _start
.org 0x0000

CountGTorEQAvg:
    subi sp, sp, 12     # based on three registers changing we reserve the space
    stw r3, 8(sp)       # store r3, 8 bytes down, original count
    stw r5, 4(sp)       # store r5, 4 bytes down, list element
    stw r6, 0(sp)       # store r6 on top of the stack, count
    mov r6, r0          # move 0 into r6

count_loop:

if:
    ldw r5, 0(r2)       # get the first element of the list
    blt r5,r4, end_if
then:
    addi r6,r6, 1       # add 1 to the counter
end_if:
    addi r2,r2, 4       # advance the pointer
    subi r3,r3, 1       # decrement the counter
    bgt r3, r0, count_loop # go to loop if count > 0

    mov r2, r6          # transfer value to r2
    ldw r3, 8(sp)       # restore value to register
    ldw r5, 4(sp)       # restore value to register
    ldw r6, 0(sp)       # restore value to register
    addi sp,sp, 12      # reset stack pointer
    ret

# end of subroutine


CalcAvg:
    subi sp,sp, 12      # based on 3 register coming in
    stw r3, 8(sp)       # original number
    stw r4, 4(sp)       # list element
    stw r5, 0(sp)       # sum

    movi r5, 0          # set sum = 0        

sum_loop:
    ldw r4, 0(r2)       # read list[i]
    add r5, r5, r4      # sum list[i]
    addi r2, r2, 4      # increment list pointer
    subi r3, r3, 1      # decrement number
    bgt r3, r0, sum_loop

    ldw r3, 8(sp)       # get original size
    divu r2, r5, r3     # divide sum/n avg = r2

    ldw r3, 8(sp)
    ldw r4, 4(sp)
    ldw r5, 0(sp)
    addi sp, sp, 12
    ret

# end of subroutine


_start:
    movia sp, 0x7FFFFC
    movia r2, LIST
    movia r3, N
    ldw r3, 0(r3)
    call CalcAvg
    movia r3, AVG
    stw r2, 0(r3)

    # need to finish


_end:
    break

.org 0x1000
LIST: .word 2,4,7,10
N: .word 4
AVG: .skip 4


.end
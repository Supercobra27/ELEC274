.equ JTAG_ADD, 0x10001000   # Address of the JTAG UART register
.equ DATA, 0                # Data location for JTAG
.equ STATUS, 4              # Status offset for status location
.equ MASK, 0xFFFF           # Whitespace mask to isolate upper bits


# Basic JTAG UART Implementation


.text
.global _start
.org 0x0000

_start:
    movi r2, '*'            # Test character
    movia r3, JTAG_ADD      # r3 <--- [JTAG_ADD]
poll:
    ldwio r4, STATUS(r3)    # r4 <--- [STATUS]+[JTAG_ADD]
    andhi r4, r4, MASK      # r4 AND 0xFFFF
    beq r4, r0, poll        # If == 0, repeat loop

    stwio r2, DATA(r3)      # Store value from IO


_end:
    break
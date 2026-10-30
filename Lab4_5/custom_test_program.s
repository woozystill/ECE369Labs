# Custom ECE369A Lab 4/5 MIPS test program

.text
.globl main

main:
    addi $t0, $zero, 5                              # PC=0x0000  encoded=20080005
    nop                                             # PC=0x0004  encoded=00000000
    nop                                             # PC=0x0008  encoded=00000000
    nop                                             # PC=0x000C  encoded=00000000
    nop                                             # PC=0x0010  encoded=00000000
    nop                                             # PC=0x0014  encoded=00000000
    addi $t1, $zero, 10                             # PC=0x0018  encoded=2009000A
    nop                                             # PC=0x001C  encoded=00000000
    nop                                             # PC=0x0020  encoded=00000000
    nop                                             # PC=0x0024  encoded=00000000
    nop                                             # PC=0x0028  encoded=00000000
    nop                                             # PC=0x002C  encoded=00000000
    addi $t2, $zero, -3                             # PC=0x0030  encoded=200AFFFD
    nop                                             # PC=0x0034  encoded=00000000
    nop                                             # PC=0x0038  encoded=00000000
    nop                                             # PC=0x003C  encoded=00000000
    nop                                             # PC=0x0040  encoded=00000000
    nop                                             # PC=0x0044  encoded=00000000
    addi $t3, $zero, 42                             # PC=0x0048  encoded=200B002A
    nop                                             # PC=0x004C  encoded=00000000
    nop                                             # PC=0x0050  encoded=00000000
    nop                                             # PC=0x0054  encoded=00000000
    nop                                             # PC=0x0058  encoded=00000000
    nop                                             # PC=0x005C  encoded=00000000
    add $s0, $t0, $t1                               # PC=0x0060  encoded=01098020
    nop                                             # PC=0x0064  encoded=00000000
    nop                                             # PC=0x0068  encoded=00000000
    nop                                             # PC=0x006C  encoded=00000000
    nop                                             # PC=0x0070  encoded=00000000
    nop                                             # PC=0x0074  encoded=00000000
    sub $s1, $t1, $t0                               # PC=0x0078  encoded=01288822
    nop                                             # PC=0x007C  encoded=00000000
    nop                                             # PC=0x0080  encoded=00000000
    nop                                             # PC=0x0084  encoded=00000000
    nop                                             # PC=0x0088  encoded=00000000
    nop                                             # PC=0x008C  encoded=00000000
    mul $s2, $t0, $t1                               # PC=0x0090  encoded=71099002
    nop                                             # PC=0x0094  encoded=00000000
    nop                                             # PC=0x0098  encoded=00000000
    nop                                             # PC=0x009C  encoded=00000000
    nop                                             # PC=0x00A0  encoded=00000000
    nop                                             # PC=0x00A4  encoded=00000000
    and $s3, $t0, $t1                               # PC=0x00A8  encoded=01099824
    nop                                             # PC=0x00AC  encoded=00000000
    nop                                             # PC=0x00B0  encoded=00000000
    nop                                             # PC=0x00B4  encoded=00000000
    nop                                             # PC=0x00B8  encoded=00000000
    nop                                             # PC=0x00BC  encoded=00000000
    or $s4, $t0, $t1                                # PC=0x00C0  encoded=0109A025
    nop                                             # PC=0x00C4  encoded=00000000
    nop                                             # PC=0x00C8  encoded=00000000
    nop                                             # PC=0x00CC  encoded=00000000
    nop                                             # PC=0x00D0  encoded=00000000
    nop                                             # PC=0x00D4  encoded=00000000
    nor $s5, $t0, $t1                               # PC=0x00D8  encoded=0109A827
    nop                                             # PC=0x00DC  encoded=00000000
    nop                                             # PC=0x00E0  encoded=00000000
    nop                                             # PC=0x00E4  encoded=00000000
    nop                                             # PC=0x00E8  encoded=00000000
    nop                                             # PC=0x00EC  encoded=00000000
    xor $s6, $t0, $t1                               # PC=0x00F0  encoded=0109B026
    nop                                             # PC=0x00F4  encoded=00000000
    nop                                             # PC=0x00F8  encoded=00000000
    nop                                             # PC=0x00FC  encoded=00000000
    nop                                             # PC=0x0100  encoded=00000000
    nop                                             # PC=0x0104  encoded=00000000
    andi $a0, $t1, 6                                # PC=0x0108  encoded=31240006
    nop                                             # PC=0x010C  encoded=00000000
    nop                                             # PC=0x0110  encoded=00000000
    nop                                             # PC=0x0114  encoded=00000000
    nop                                             # PC=0x0118  encoded=00000000
    nop                                             # PC=0x011C  encoded=00000000
    ori $a1, $t0, 8                                 # PC=0x0120  encoded=35050008
    nop                                             # PC=0x0124  encoded=00000000
    nop                                             # PC=0x0128  encoded=00000000
    nop                                             # PC=0x012C  encoded=00000000
    nop                                             # PC=0x0130  encoded=00000000
    nop                                             # PC=0x0134  encoded=00000000
    xori $a2, $t0, 15                               # PC=0x0138  encoded=3906000F
    nop                                             # PC=0x013C  encoded=00000000
    nop                                             # PC=0x0140  encoded=00000000
    nop                                             # PC=0x0144  encoded=00000000
    nop                                             # PC=0x0148  encoded=00000000
    nop                                             # PC=0x014C  encoded=00000000
    sll $a3, $t0, 2                                 # PC=0x0150  encoded=00083880
    nop                                             # PC=0x0154  encoded=00000000
    nop                                             # PC=0x0158  encoded=00000000
    nop                                             # PC=0x015C  encoded=00000000
    nop                                             # PC=0x0160  encoded=00000000
    nop                                             # PC=0x0164  encoded=00000000
    srl $v0, $t1, 1                                 # PC=0x0168  encoded=00091042
    nop                                             # PC=0x016C  encoded=00000000
    nop                                             # PC=0x0170  encoded=00000000
    nop                                             # PC=0x0174  encoded=00000000
    nop                                             # PC=0x0178  encoded=00000000
    nop                                             # PC=0x017C  encoded=00000000
    slt $v1, $t0, $t1                               # PC=0x0180  encoded=0109182A
    nop                                             # PC=0x0184  encoded=00000000
    nop                                             # PC=0x0188  encoded=00000000
    nop                                             # PC=0x018C  encoded=00000000
    nop                                             # PC=0x0190  encoded=00000000
    nop                                             # PC=0x0194  encoded=00000000
    slti $k0, $t0, 6                                # PC=0x0198  encoded=291A0006
    nop                                             # PC=0x019C  encoded=00000000
    nop                                             # PC=0x01A0  encoded=00000000
    nop                                             # PC=0x01A4  encoded=00000000
    nop                                             # PC=0x01A8  encoded=00000000
    nop                                             # PC=0x01AC  encoded=00000000
    sw $t3, 0($zero)                                # PC=0x01B0  encoded=AC0B0000
    nop                                             # PC=0x01B4  encoded=00000000
    nop                                             # PC=0x01B8  encoded=00000000
    nop                                             # PC=0x01BC  encoded=00000000
    nop                                             # PC=0x01C0  encoded=00000000
    nop                                             # PC=0x01C4  encoded=00000000
    lw $k1, 0($zero)                                # PC=0x01C8  encoded=8C1B0000
    nop                                             # PC=0x01CC  encoded=00000000
    nop                                             # PC=0x01D0  encoded=00000000
    nop                                             # PC=0x01D4  encoded=00000000
    nop                                             # PC=0x01D8  encoded=00000000
    nop                                             # PC=0x01DC  encoded=00000000
    sb $t3, 4($zero)                                # PC=0x01E0  encoded=A00B0004
    nop                                             # PC=0x01E4  encoded=00000000
    nop                                             # PC=0x01E8  encoded=00000000
    nop                                             # PC=0x01EC  encoded=00000000
    nop                                             # PC=0x01F0  encoded=00000000
    nop                                             # PC=0x01F4  encoded=00000000
    lb $t4, 4($zero)                                # PC=0x01F8  encoded=800C0004
    nop                                             # PC=0x01FC  encoded=00000000
    nop                                             # PC=0x0200  encoded=00000000
    nop                                             # PC=0x0204  encoded=00000000
    nop                                             # PC=0x0208  encoded=00000000
    nop                                             # PC=0x020C  encoded=00000000
    sh $t3, 8($zero)                                # PC=0x0210  encoded=A40B0008
    nop                                             # PC=0x0214  encoded=00000000
    nop                                             # PC=0x0218  encoded=00000000
    nop                                             # PC=0x021C  encoded=00000000
    nop                                             # PC=0x0220  encoded=00000000
    nop                                             # PC=0x0224  encoded=00000000
    lh $t5, 8($zero)                                # PC=0x0228  encoded=840D0008
    nop                                             # PC=0x022C  encoded=00000000
    nop                                             # PC=0x0230  encoded=00000000
    nop                                             # PC=0x0234  encoded=00000000
    nop                                             # PC=0x0238  encoded=00000000
    nop                                             # PC=0x023C  encoded=00000000
    sb $t2, 12($zero)                               # PC=0x0240  encoded=A00A000C
    nop                                             # PC=0x0244  encoded=00000000
    nop                                             # PC=0x0248  encoded=00000000
    nop                                             # PC=0x024C  encoded=00000000
    nop                                             # PC=0x0250  encoded=00000000
    nop                                             # PC=0x0254  encoded=00000000
    lb $t6, 12($zero)                               # PC=0x0258  encoded=800E000C
    nop                                             # PC=0x025C  encoded=00000000
    nop                                             # PC=0x0260  encoded=00000000
    nop                                             # PC=0x0264  encoded=00000000
    nop                                             # PC=0x0268  encoded=00000000
    nop                                             # PC=0x026C  encoded=00000000
    sh $t2, 16($zero)                               # PC=0x0270  encoded=A40A0010
    nop                                             # PC=0x0274  encoded=00000000
    nop                                             # PC=0x0278  encoded=00000000
    nop                                             # PC=0x027C  encoded=00000000
    nop                                             # PC=0x0280  encoded=00000000
    nop                                             # PC=0x0284  encoded=00000000
    lh $t7, 16($zero)                               # PC=0x0288  encoded=840F0010
    nop                                             # PC=0x028C  encoded=00000000
    nop                                             # PC=0x0290  encoded=00000000
    nop                                             # PC=0x0294  encoded=00000000
    nop                                             # PC=0x0298  encoded=00000000
    nop                                             # PC=0x029C  encoded=00000000
    bgez $t0, after_bgez                            # PC=0x02A0  encoded=05010002
    nop                                             # PC=0x02A4  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x02A8  encoded=20170063
after_bgez:
    nop                                             # PC=0x02AC  encoded=00000000
    nop                                             # PC=0x02B0  encoded=00000000
    nop                                             # PC=0x02B4  encoded=00000000
    nop                                             # PC=0x02B8  encoded=00000000
    nop                                             # PC=0x02BC  encoded=00000000
    beq $t0, $t0, after_beq_equal                   # PC=0x02C0  encoded=11080002
    nop                                             # PC=0x02C4  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x02C8  encoded=20170063
after_beq_equal:
    nop                                             # PC=0x02CC  encoded=00000000
    nop                                             # PC=0x02D0  encoded=00000000
    nop                                             # PC=0x02D4  encoded=00000000
    nop                                             # PC=0x02D8  encoded=00000000
    nop                                             # PC=0x02DC  encoded=00000000
    bne $t0, $t1, after_bne                         # PC=0x02E0  encoded=15090002
    nop                                             # PC=0x02E4  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x02E8  encoded=20170063
after_bne:
    nop                                             # PC=0x02EC  encoded=00000000
    nop                                             # PC=0x02F0  encoded=00000000
    nop                                             # PC=0x02F4  encoded=00000000
    nop                                             # PC=0x02F8  encoded=00000000
    nop                                             # PC=0x02FC  encoded=00000000
    bgtz $t0, after_bgtz                            # PC=0x0300  encoded=1D000002
    nop                                             # PC=0x0304  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x0308  encoded=20170063
after_bgtz:
    nop                                             # PC=0x030C  encoded=00000000
    nop                                             # PC=0x0310  encoded=00000000
    nop                                             # PC=0x0314  encoded=00000000
    nop                                             # PC=0x0318  encoded=00000000
    nop                                             # PC=0x031C  encoded=00000000
    blez $t2, after_blez                            # PC=0x0320  encoded=19400002
    nop                                             # PC=0x0324  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x0328  encoded=20170063
after_blez:
    nop                                             # PC=0x032C  encoded=00000000
    nop                                             # PC=0x0330  encoded=00000000
    nop                                             # PC=0x0334  encoded=00000000
    nop                                             # PC=0x0338  encoded=00000000
    nop                                             # PC=0x033C  encoded=00000000
    bltz $t2, after_bltz                            # PC=0x0340  encoded=05400002
    nop                                             # PC=0x0344  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x0348  encoded=20170063
after_bltz:
    nop                                             # PC=0x034C  encoded=00000000
    nop                                             # PC=0x0350  encoded=00000000
    nop                                             # PC=0x0354  encoded=00000000
    nop                                             # PC=0x0358  encoded=00000000
    nop                                             # PC=0x035C  encoded=00000000
    beq $t0, $t1, after_beq_not_equal               # PC=0x0360  encoded=11090002
    nop                                             # PC=0x0364  encoded=00000000
    addi $s7, $zero, 17                             # PC=0x0368  encoded=20170011
after_beq_not_equal:
    nop                                             # PC=0x036C  encoded=00000000
    nop                                             # PC=0x0370  encoded=00000000
    nop                                             # PC=0x0374  encoded=00000000
    nop                                             # PC=0x0378  encoded=00000000
    nop                                             # PC=0x037C  encoded=00000000
    j after_jump                                    # PC=0x0380  encoded=080000E3
    nop                                             # PC=0x0384  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x0388  encoded=20170063
after_jump:
    nop                                             # PC=0x038C  encoded=00000000
    nop                                             # PC=0x0390  encoded=00000000
    nop                                             # PC=0x0394  encoded=00000000
    nop                                             # PC=0x0398  encoded=00000000
    nop                                             # PC=0x039C  encoded=00000000
    jal subroutine                                  # PC=0x03A0  encoded=0C0000F3
    nop                                             # PC=0x03A4  encoded=00000000
return_from_subroutine:
    addi $s7, $zero, 18                             # PC=0x03A8  encoded=20170012
    nop                                             # PC=0x03AC  encoded=00000000
    nop                                             # PC=0x03B0  encoded=00000000
    nop                                             # PC=0x03B4  encoded=00000000
    nop                                             # PC=0x03B8  encoded=00000000
    nop                                             # PC=0x03BC  encoded=00000000
    j after_subroutine                              # PC=0x03C0  encoded=080000FB
    nop                                             # PC=0x03C4  encoded=00000000
    addi $s7, $zero, 99                             # PC=0x03C8  encoded=20170063
subroutine:
    addi $s7, $zero, 19                             # PC=0x03CC  encoded=20170013
    nop                                             # PC=0x03D0  encoded=00000000
    nop                                             # PC=0x03D4  encoded=00000000
    nop                                             # PC=0x03D8  encoded=00000000
    nop                                             # PC=0x03DC  encoded=00000000
    nop                                             # PC=0x03E0  encoded=00000000
    jr $ra                                          # PC=0x03E4  encoded=03E00008
    nop                                             # PC=0x03E8  encoded=00000000
after_subroutine:
    nop                                             # PC=0x03EC  encoded=00000000
    nop                                             # PC=0x03F0  encoded=00000000
    nop                                             # PC=0x03F4  encoded=00000000
    nop                                             # PC=0x03F8  encoded=00000000
    nop                                             # PC=0x03FC  encoded=00000000
done:
    j done                                          # PC=0x0400  encoded=08000100

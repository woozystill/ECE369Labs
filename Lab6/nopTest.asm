#no nops, covers all 30 instructions
#take branches/jumps are followed by a bad instruction that cant run
loop:
  addi $t0, $zero, 5        #t0=5
  addi $t1, $t0, 3          #t1=8
  add  $t2, $t1, $t0        #t2=13
  sub  $t3, $t2, $t1        #t3=5
  mul  $t4, $t3, $t2        #t4=65
  ori  $s0, $zero, 4080     #s0=0x0ff0
  andi $s1, $s0, 255        #s1=0x00f0
  or   $s2, $s1, $t4        #s2=0x00f1
  xor  $s3, $s2, $s0        #s3=0x0f01
  nor  $s4, $s3, $s0        #s4=0xfffff00e
  xori $s5, $s4, 255        #s5=0xfffff0f1
  and  $s6, $s5, $s4        #s6=0xfffff000
  sll  $t5, $t4, 4          #t5=0x0410
  srl  $t6, $t5, 2          #t6=0x0104
  slt  $t7, $s4, $t0        #t7=1 (signed compare)
  slti $t8, $t7, 2          #t8=1
  addi $gp, $zero, 64       #gp=0x40
  sw   $s5, 0($gp)          #mem[0x40]=0xfffff0f1
  sh   $t5, 4($gp)          #mem[0x44] low half=0x0410
  sb   $s1, 6($gp)          #mem[0x44] byte2=0xf0
  lw   $a0, 4($gp)          #a0=0x00f00410
  lh   $a1, 0($gp)          #a1=0xfffff0f1
  lb   $a2, 6($gp)          #a2=0xfffffff0
  beq  $t0, $t3, c1         #take
  addi $k1, $zero, 2989     # bad
c1: bne  $t0, $t1, c2       #take
  addi $k1, $zero, 2989     # bad
c2: bltz $a1, c3            #take
  addi $k1, $zero, 2989     # bad
c3: blez $a2, c4            # take
  addi $k1, $zero, 2989     # bad
c4: bgez $t0, c5            # take
  addi $k1, $zero, 2989     # bad
c5: bgtz $t0, c6            # take
  addi $k1, $zero, 2989     # bad
c6: blez $t0, c7            #no take
  addi $v0, $zero, 1        #v0=1
c7: bne  $t0, $t3, c8       #no take
  addi $v1, $zero, 2        #v1=2
c8: bgez $s4, c9            #no take
  addi $a3, $zero, 3        #a3=3
c9: jal  fn                 #ra=PC+4
  addi $s0, $zero, 100      #s0=100 
  j    loop                 #back to PC=0
fn: jr   $ra                #return

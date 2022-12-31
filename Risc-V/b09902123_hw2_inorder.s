.globl __start

.rodata
  newline: .string " "
  str1: .string "wow"

.text
__start:
    # input n
    li a0, 5
    ecall
    mv s0, a0
    # input an array
    li a0, 9
    li a1, 1000
    ecall
    mv s1, a0 # the address of array

li t2, 0 # denote idx
addi t3, s0, 0 # denote the remain input

scan_loop:
    beq t3, x0, main # 輸入結束
    li a0, 5
    ecall
    mv t1, a0
    add t4, t2, s1
    sw t1, 0(t4)
    # beq x0, x0, print # check scan success
    addi t2, t2, 4
    addi t3 t3, -1
    beq x0, x0, scan_loop

main:
    li x5, 0 # set idx to 0
    jal x1, traverse
    beq x0, x0, exit

traverse:
    # leaf
    bge x5, s0, done
    # initiate stack
    addi sp, sp, -16
    sw x1, 0(sp) # store return address
    sw x5, 8(sp) # store the current value of n(index)
    # go to left (*2+1)
    slli x5, x5, 1
    addi x5, x5, 1
    jal x1, traverse
    
    lw x5, 8(sp) # load old n from stack
    # print current value
    jal x1, print
    # go to right (*2+2)
    slli x5, x5, 1
    addi x5, x5, 2
    jal x1, traverse
    # pop the stack
    lw x1, 0(sp)
    addi sp, sp, 16



done:
    jalr x0, 0(x1)

print:
    addi t4, x5, 0
    slli t4, t4, 2
    add t4, t4, s1
    li a0, 1
    lw t1, 0(t4) # address
    mv a1, t1
    ecall
    # newline
    li a0, 4
    la a1, newline
    ecall
    jalr x0, 0(x1)
    

exit:
    # Exit program(necessary)
    li a0, 10
    ecall
          
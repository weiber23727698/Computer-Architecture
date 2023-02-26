.globl __start

.text
__start:
    # input n
    li a0, 5
    ecall
    mv s0, a0

# TODO

li t1, 1

addi x10, s0, 0 # x10 store value of n
jal x1, fib
beq x0, x0, output

fib:
    # if n == 0 or 1
    beq x10, x0, base_case
    addi x5, x0, 1
    beq x10, x5, base_case
    # initiate stack
    addi sp, sp, -16
    sw x1, 0(sp) # store return address
    sw x10, 8(sp) # store the value of n
    # do recursive
    addi x10, x10, -1
    jal x1, fib # call fib(n-1)
    lw x5, 8(sp) # load old n from stack
    sw x10, 8(sp) # push fib(n-1) to the stack
    addi x10, x5, -2
    jal x1, fib # call fib(n-2)
    lw x5, 8(sp) # x5 = fib(n-1)
    add x10, x10, x5 # x10 = fib(n-1) + fib(n-2)
    # pop the stack
    lw x1, 0(sp)
    addi sp, sp, 16
    
base_case:
    jalr x0, 0(x1)



output:
    # Output the result
    addi s3, x10, 0
    li a0, 1
    mv a1, s3
    ecall

exit:
    # Exit program(necessary)
    li a0, 10
    ecall
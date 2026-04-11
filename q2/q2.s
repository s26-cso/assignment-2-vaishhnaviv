# q2.s - next greater element (stack)

#registers: 
# s0 = n (no of elements)
#s1 = base address of arr[]
# s2 = base address of result[]
# s3 = base address of stack[]
#s4 = stack top index 
#s5 = loop index i 

.section .text
.globl main

main:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    addi s0, a0, -1      # n
    mv s6, a1            # argv

    # arr
    slli a0, s0, 3
    call malloc
    mv s1, a0

    # result
    slli a0, s0, 3
    call malloc
    mv s2, a0

    # stack
    slli a0, s0, 3
    call malloc
    mv s3, a0

    li s4, -1            # top = -1

    # parse
    li t0, 0

parse:
    bge t0, s0, done_parse #if i>= n, parding done 
    addi t1, t0, 1 #t1 = i+1 
    slli t1, t1, 3 #t1 = (i+1)* 8 (byte offset)
    add t1, s6, t1 # t1 = &argv[i+1]
    ld a0, 0(t1) #a0 = argv[i+1]
    call atoi #a0 = int value of the string 

    slli t2, t0, 3 #t2 = i*8
    add t2, s1, t2 # t2 = &arr[i]
    sd a0, 0(t2) #arr[i] = atoi(argv[i+1])

    addi t0, t0, 1 # i++ 
    j parse

done_parse:

    # init result = -1
    li t0, 0
init:
    bge t0, s0, done_init
    slli t1, t0, 3
    add t1, s2, t1 #t1 = &result[i]
    li t2, -1
    sd t2, 0(t1) # result[i] = -1 
    addi t0, t0, 1
    j init

done_init:

    addi s5, s0, -1 #s5 = n-1 

loop_i:
    blt s5, x0, done_algo 

    # arr[i]
    slli t0, s5, 3
    add t0, s1, t0
    ld t0, 0(t0) #t0 = arr[i]

while1:
    blt s4, x0, out_while #if top <0, stack empty, exit 
    slli t1, s4, 3
    add t1, s3, t1
    ld t1, 0(t1) #t1 = stack[top]

    slli t2, t1, 3
    add t2, s1, t2
    ld t2, 0(t2) #t2 = arr[stack[top]]

    ble t2, t0, pop_it # if arr[stack[top]] <= arr[i], pop 
    j out_while

pop_it:
    addi s4, s4, -1 #top--
    j while1

out_while:
#if stack is not empty, result[i] = stack top 
# stack top is the index of the next greater element 

    blt s4, x0, skip # skip if the stack is empty 

    slli t1, s4, 3
    add t1, s3, t1
    ld t1, 0(t1) #t1 = stack[top]

    slli t2, s5, 3
    add t2, s2, t2 # t2 = &result[i]
    sd t1, 0(t2) #result[i] = index of next greater element 

skip:
    addi s4, s4, 1 #top++ 
    slli t1, s4, 3
    add t1, s3, t1 #t1 = &stack[top]
    sd s5, 0(t1) #stack[top] = i 

    addi s5, s5, -1 # i-- 
    j loop_i

done_algo:

    li s5, 0 #i=0 

print:
    bge s5, s0, done #if i>= n, finish printing 

    slli t0, s5, 3
    add t0, s2, t0
    ld a0, 0(t0) #a0 = result[i]
    call print_int

    addi t1, s5, 1
    bge t1, s0, newline #if its the last element, print newline 
    li a0, ' '
    call putchar #otherwise, print space 
    j cont

newline:
    li a0, '\n'
    call putchar

cont:
    addi s5, s5, 1 #i++; 
    j print

done:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    ld s2, 0(sp)
    addi sp, sp, 32
    li a0, 0 
    ret



print_int:
    addi sp, sp, -32
    sd ra, 24(sp)
    mv t0, a0 #t0 = number to print 
    blt t0, x0, neg
pos:
    li t1, 10 #divisor 
    li t2, 0 #t2 = digit count 
    addi sp, sp, -32
    mv t3, sp #t3 = pointer into digit buffer 
loop1:
    beq t0, x0, print1 #no more digits 
    rem t4, t0, t1 #t4 = t0 % 10 
    div t0, t0, t1 #t0 = t0/10 
    addi t4, t4, '0' #convert digit to ascii 
    sb t4, 0(t3) #store in buffer 
    addi t3, t3, 1 # move buffer pointer 
    addi t2, t2, 1 #digit count++ 
    j loop1
print1:
    beq t2, x0, zero_case #if no digits were extracted, number was 0 
    addi t3, t3, -1 
loop2:
    lb a0, 0(t3) #load digit 
    call putchar # print 
    addi t3, t3, -1
    addi t2, t2, -1
    bnez t2, loop2 #repeat till all digits are printed 
    j done_print
zero_case:
    li a0, '0'
    call putchar #print 0 
done_print:
    addi sp, sp, 32 #free digit buffer 
    j end_print
neg:
    li a0, '-'
    call putchar #print minus sign
    neg t0, t0 #make positive 
    mv a0, t0
    call print_int #recursive to print +ve val 
end_print:
    ld ra, 24(sp)
    addi sp, sp, 32
    ret
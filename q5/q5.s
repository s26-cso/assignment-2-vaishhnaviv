.section .rodata
filename:   .string "input.txt"
msg_yes:    .string "Yes\n"
msg_no:     .string "No\n"

.section .text
.globl main
main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)      # leftfp 
    sd s1, 24(sp)      # rightfp
    sd s2, 16(sp)      # left pos
    sd s3, 8(sp)       # right pos
    sd s4, 0(sp)       # file size

    # open file for left pointer 
    li a0, -100       
    la a1, filename
    li a2, 0           
    li a3, 0
    li a7, 56          
    ecall
    mv s0, a0          # s0 = leftfp 

    # open file for right pointer
    li a0, -100        
    la a1, filename
    li a2, 0           
    li a3, 0
    li a7, 56          
    ecall
    mv s1, a0          # s1 = rightfp

    #file size 
    mv a0, s1
    li a1, 0
    li a2, 2           
    li a7, 62          # lseek
    ecall
    mv s4, a0          # s4 = file size

    # empty file 
    beqz s4, print_yes

    li s2, 0           # left = 0
    addi s3, s4, -1    # right = size - 1

comp:
    # if left >= right, it is a palindrome 
    bge s2, s3, print_yes

    # read byte from the left 
    mv a0, s0
    mv a1, s2
    li a2, 0           
    li a7, 62
    ecall
    mv a0, s0
    addi a1, sp, -1   
    li a2, 1
    li a7, 63
    ecall
    lb s6, -1(sp)      # s6 = left char

    # read byte from the right 
    mv a0, s1
    mv a1, s3
    li a2, 0         
    li a7, 62
    ecall
    mv a0, s1
    addi a1, sp, -2    
    li a2, 1
    li a7, 63
    ecall
    lb s7, -2(sp)      # s7 = right char

    # compare left and right char 
    bne s6, s7, print_no

    # move pointers 
    addi s2, s2, 1     # left++
    addi s3, s3, -1    # right--
    j comp

print_yes:
    li a0, 1           # stdout
    la a1, msg_yes
    li a2, 4           # "Yes\n" = 4 bytes
    li a7, 64          
    ecall
    j cleanup

print_no:
    li a0, 1
    la a1, msg_no
    li a2, 3           # "No\n" = 3 bytes
    li a7, 64
    ecall

cleanup:
    
    mv a0, s0
    li a7, 57          # close
    ecall
    mv a0, s1
    li a7, 57
    ecall

    # exit(0)
    li a0, 0
    li a7, 93          # exit
    ecall

    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    addi sp, sp, 48
    ret

# two-sum
# Given an array of integers nums and an integer target, return indices of the two numbers such that they add
# up to target. You may assume that each input would have exactly one solution, and you may not use the same
# element twice. You can return the answer in any order.

    .data
nums:   .word 2, 7, 11, 7   # Example array [2, 7, 11, 7]
target: .word 9             # Example target
size:   .word 4             # Size of the array

    .text
    .globl main
    .globl two_sum

main:
    la a2, nums             # Load address of nums array into a2
    lw a3, target           # Load target value into a3
    lw a4, size             # Load number of elements in the array into a4
    jal ra, two_sum         # Call the two_sum function
    addi a0, zero, 10       # Set a0 to 10 (exit syscall)
    ecall                   # Make a system call to exit the program

two_sum:
    addi sp, sp, -16        # Allocate stack space
    sw ra, 12(sp)           # Save return address
    sw s0, 8(sp)            # Save s0 (array base address)
    sw s1, 4(sp)            # Save s1 (size of array)

    mv s0, a2               # s0 = nums (preserve array address)
    mv s1, a4               # s1 = size (preserve size of array)

    addi t0, s1, -1         # t0 = size - 1 (starting index)
outer_loop:

    blt t0, zero, end       # If index < 0, exit loop

    slli t1, t0, 2          # t1 = t0 * 4 (byte offset)
    add t2, s0, t1          # t2 = nums + offset
    lw t3, 0(t2)            # Load nums[i] into t3

    addi t4, t0, -1         # t4 = t0 - 1 (inner loop index)

inner_loop:
    blt t4, zero, next_outer # If t4 < 0, go to next outer loop iteration
    slli t5, t4, 2          # t5 = t4 * 4 (byte offset)
    add t6, s0, t5          # t6 = nums + offset
    lw t6, 0(t6)            # Load nums[j] into t6

    add t5, t3, t6          # t5 = nums[i] + nums[j]
    beq t5, a3, found       # If sum == target, found the indices

    addi t4, t4, -1         # Decrement inner loop index
    j inner_loop            # Continue inner loop

next_outer:
    addi t0, t0, -1         # Decrement outer loop index
    j outer_loop            # Repeat outer loop

found:
    mv a0, t0               # Return first index
    mv a1, t4               # Return second index

end:
    lw ra, 12(sp)           # Restore return address
    lw s0, 8(sp)            # Restore s0
    lw s1, 4(sp)            # Restore s1
    addi sp, sp, 16         # Deallocate stack space
    jr ra                   # Return to caller

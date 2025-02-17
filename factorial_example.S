# created by GitHub Copilot
    .data
    .text
    .globl main
    .globl factorial

main:
    li a0, 3                # Load immediate value 3 into a0 (input for factorial)
    jal ra, factorial       # Call the factorial function
    addi a0, x0, 10         # Set a0 to 10 (exit syscall)
    ecall                   # Make a system call to exit the program

factorial:
    addi sp, sp, -16        # Allocate 16 bytes of stack space
    sw ra, 12(sp)           # Save return address (ra) at offset 12 from the stack pointer (sp)
    sw a0, 8(sp)            # Save the argument n (a0) at offset 8 from the stack pointer (sp)
    li t0, 1                # Load immediate value 1 into temporary register t0
    bge a0, t0, recurse     # If n (a0) >= 1, branch to the label 'recurse'
    li a0, 1                # Base case: load immediate value 1 into a0 (return value)
    j end_factorial         # Jump to the label 'end_factorial'

recurse:
    addi a0, a0, -1         # Decrement n (a0) by 1
    jal ra, factorial       # Recursive call to factorial(n-1)
    lw t1, 8(sp)            # Load the original n from the stack into temporary register t1
    mul a0, a0, t1          # Multiply the result of factorial(n-1) by the original n

end_factorial:
    lw ra, 12(sp)           # Restore the return address from the stack
    addi sp, sp, 16         # Deallocate the 16 bytes of stack space
    jr ra                   # Return to the caller
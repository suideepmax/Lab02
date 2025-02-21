 .data
A:      .word 1, 2, 3, 4, 5, 6   # 2x3 matrix
B:      .word 7, 8, 9, 10, 11, 12 # 3x2 matrix
C:      .space 16  # 2x2 result matrix
row_factor: .space 8  
col_factor: .space 8  
rows_A: .word 2
cols_A: .word 3
cols_B: .word 2

 .text
.globl _start

_start:
    la t0, rows_A
    lw t1, 0(t0)       # t1 = rows_A
    la t0, cols_A
    lw t2, 0(t0)       # t2 = cols_A
    la t0, cols_B
    lw t3, 0(t0)       # t3 = cols_B

    # Compute row factors
    la t4, row_factor  
    la t5, A          
    li t6, 0           # Row index i = 0
row_factor_loop:
    bge t6, t1, col_factor_loop  
    li t0, 0           # Column index k = 0
    li t2, 0           # row_factor[i] = 0
row_factor_inner:
    bge t0, t2, row_done
    lw t3, 0(t5)
    lw t5, 4(t5)
    mul t3, t3, t5
    add t2, t2, t3
    addi t5, t5, 8
    addi t0, t0, 2
    j row_factor_inner
row_done:
    sw t2, 0(t4)
    addi t4, t4, 4
    addi t6, t6, 1
    j row_factor_loop

# Compute column factors
col_factor_loop:
    la t4, col_factor  
    la t5, B          
    li t6, 0          
col_factor_inner:
    bge t6, t3, compute_C
    li t0, 0          
    li t2, 0          
col_factor_mul:
    bge t0, t2, col_done
    lw t3, 0(t5)
    lw t5, 4(t5)
    mul t3, t3, t5
    add t2, t2, t3
    addi t5, t5, 8
    addi t0, t0, 2
    j col_factor_mul
col_done:
    sw t2, 0(t4)
    addi t4, t4, 4
    addi t6, t6, 1
    j col_factor_inner

# Compute C = A * B using Winograd's formula
compute_C:
    la t4, C          
    la t5, A          
    la t6, B          
    li t0, 0          

compute_C_loop:
    bge t0, t1, done  
    li t2, 0          
compute_C_inner:
    bge t2, t3, next_row  
    lw t3, 0(t5)      
    lw t5, 0(t6)      
    sub t3, t3, t5    

    li t6, 0          
compute_C_k_loop:
    bge t6, t2, store_C
    lw t4, 0(t5)
    lw t5, 4(t6)
    add t5, t4, t5
    lw t4, 4(t5)
    lw t6, 0(t6)
    add t6, t4, t6
    mul t4, t5, t6
    add t3, t3, t4
    addi t6, t6, 2
    j compute_C_k_loop

store_C:
    sw t3, 0(t4)      
    addi t4, t4, 4    
    addi t2, t2, 1    
    j compute_C_inner

next_row:
    addi t0, t0, 1    
    j compute_C_loop

done:
    li a7, 10
    ecall
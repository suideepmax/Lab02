#merge list
#You are given the heads of two sorted linked lists list1 and list2. Merge the two lists into one sorted list.
#The list should be made by splicing together the nodes of the first two lists. Return the head of the
#merged linked list.

    .data
# Example linked lists: [1, 2, 4] and [1, 3, 4]

list1_1:     .word 1, list1_2   # Node 1 -> 2
list1_2:     .word 2, list1_3   # Node 2 -> 4
list1_3:     .word 4, 0         # Node 4 -> NULL

list2_1:     .word 1, list2_2   # Node 1 -> 3
list2_2:     .word 3, list2_3   # Node 3 -> 4
list2_3:     .word 4, 0         # Node 4 -> NULL

merged_list: .word 0   # Placeholder for merged list head

dummy_node:  .word 0   # Dummy node (unused value)
dummy_next:  .word 0   # Pointer to merged list

    .text
    .globl main, mergeTwoLists

main:
    # Load list heads into function arguments
    la a0, list1_1   # Load list1 head
    la a1, list2_1   # Load list2 head
    jal ra, mergeTwoLists  # Call merge function

    la t0, merged_list  # Load address of merged_list
    sw a0, 0(t0)        # Store a0 (merged list head) at merged_list


end:
    j end  # Infinite loop for inspection

# Function: mergeTwoLists
mergeTwoLists:
    # a0 = list1, a1 = list2
    addi sp, sp, -16   # Allocate stack space
    sw a0, 0(sp)       # Save list1
    sw a1, 4(sp)       # Save list2
    la s0, dummy_node  # Load dummy node address (s0 = dummy)
    sw s0, 8(sp)       # Save dummy node (acts as prev)
    
    mv s1, s0          # curr = &dummy (s1 is curr)

merge_loop:
    beq a0, zero, append_remaining  # If list1 is empty, append list2
    beq a1, zero, append_remaining  # If list2 is empty, append list1

    lw t0, 0(a0)       # Load list1->val
    lw t1, 0(a1)       # Load list2->val
    bgt t0, t1, choose_list2

choose_list1:
    sw a0, 4(s1)       # curr->next = list1
    lw a0, 4(a0)       # list1 = list1->next
    j advance_curr

choose_list2:
    sw a1, 4(s1)       # curr->next = list2
    lw a1, 4(a1)       # list2 = list2->next

advance_curr:
    lw s1, 4(s1)       # Move curr = curr->next
    j merge_loop       # Continue looping

append_remaining:
    or t0, a0, a1      # Select the non-null list
    sw t0, 4(s1)       # curr->next = remaining list

    lw a0, 8(sp)       # Load dummy node
    lw a0, 4(a0)       # Return dummy.next (merged list head)

    addi sp, sp, 16    # Restore stack
    ret


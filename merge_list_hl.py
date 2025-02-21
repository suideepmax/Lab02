from typing import Optional

# Definition for singly-linked list.
from typing import Optional

# Definition for singly-linked list.
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution:
    def mergeTwoLists(
        self, list1: Optional[ListNode], list2: Optional[ListNode]
    ) -> Optional[ListNode]:
        dummy = ListNode()
        curr = dummy
        while list1 and list2:
            if list1.val <= list2.val:
                curr.next = list1
                list1 = list1.next
            else:
                curr.next = list2
                list2 = list2.next
            curr = curr.next
        curr.next = list1 or list2
        return dummy.next

# Helper function to create a linked list from a list
def create_linked_list(lst):
    if not lst:
        return None
    head = ListNode(lst[0])
    curr = head
    for val in lst[1:]:
        curr.next = ListNode(val)
        curr = curr.next
    return head

# Helper function to print a linked list
def print_linked_list(head):
    curr = head
    while curr:
        print(curr.val, end=" -> " if curr.next else "\n")
        curr = curr.next

# Example usage
list1 = create_linked_list([1, 2, 4])
list2 = create_linked_list([1, 3, 4])

print("List 1:")
print_linked_list(list1)

print("List 2:")
print_linked_list(list2)

# Merging the lists
solution = Solution()
merged_list = solution.mergeTwoLists(list1, list2)

print("Merged List:")
print_linked_list(merged_list)
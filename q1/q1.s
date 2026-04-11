# q1.s - BST implementation in RISC-V assembly
# struct Node: val(int)@0, left(ptr)@8, right(ptr)@16, sizeof=24

.section .text

# struct Node* newnode
# a0 = val (int)
# returns: a0 = pointer to new Node

.globl newnode
newnode:
    addi  sp, sp, -16
    sd    ra, 8(sp)
    sd    s0, 0(sp)

    mv    s0, a0           # val

    li    a0, 24           # size of(node) = 24 
    call  malloc

    sw    s0, 0(a0)        # node->val = val
    sd    x0, 8(a0)        # node->left = NULL
    sd    x0, 16(a0)       # node->right = NULL

    ld    ra, 8(sp)
    ld    s0, 0(sp)
    addi  sp, sp, 16
    ret

# struct Node* insert(struct Node* root int val)
# returns: a0 = root

.globl insert
insert:
    addi  sp, sp, -32
    sd    ra, 24(sp)
    sd    s0, 16(sp)       # root
    sd    s1, 8(sp)        # val 

    mv    s0, a0           # s0 = root
    mv    s1, a1           # s1 = val

    # if root == NULL, newnode(val) and return
    bne   s0, x0, insert_notnull
    mv    a0, s1
    call  newnode
    j     insert_done

insert_notnull:
    lw    t0, 0(s0)        # t0 = root->val
    # if val < root->val: insert into left subtree
    bge   s1, t0, insert_right

    ld    a0, 8(s0)        # a0 = root->left
    mv    a1, s1
    call  insert
    sd    a0, 8(s0)        # root->left = result
    mv    a0, s0
    j     insert_done

insert_right:
    # if val > root->val: insert into right subtree
    ble   s1, t0, insert_equal

    ld    a0, 16(s0)       # a0 = root->right
    mv    a1, s1
    call  insert
    sd    a0, 16(s0)       # root->right = result
    mv    a0, s0
    j     insert_done

insert_equal:
    # val == root->val: already exists, just return root
    mv    a0, s0

insert_done:
    ld    ra, 24(sp)
    ld    s0, 16(sp)
    ld    s1, 8(sp)
    addi  sp, sp, 32
    ret

# struct Node* get(struct Node* root, int val)
# a0 = root
# a1 = val
# returns: a0 =pointer to node

.globl get
get:
    
    beq   a0, x0, get_done   # root == NULL, return NULL

    lw    t0, 0(a0)           # t0 = root->val
    beq   a1, t0, get_done    # val = a0, return a0 

    blt   a1, t0, get_left
    # go right
    ld    a0, 16(a0)
    j     get

get_left:
    ld    a0, 8(a0)
    j     get

get_done:
    ret

# int atmost(int val, struct Node* root)
# a0 = val
# a1 = root
# returns: a0 = greatest value <= val

.globl atmost
atmost:
    addi  sp, sp, -32
    sd    ra, 24(sp)
    sd    s0, 16(sp)       # s0 = val
    sd    s1, 8(sp)        # s1 = root
    sd    s2, 0(sp)        # s2 = ans

    mv    s0, a0           # val
    mv    s1, a1           # root
    li    s2, -1           # best = -1

atmost_loop:
    beq   s1, x0, atmost_done   # root == NULL 

    lw    t0, 0(s1)        # t0 = root->val

    blt   t0, s0, atmost_lt     # root->val <val
    beq   t0, s0, atmost_eq     # root->val == val


    ld    s1, 8(s1) #root->val > val (go left)
    j     atmost_loop

atmost_lt:

    mv    s2, t0 # go right 
    ld    s1, 16(s1)
    j     atmost_loop

atmost_eq:
    mv    s2, t0
    j     atmost_done

atmost_done:
    mv    a0, s2
    ld    ra, 24(sp)
    ld    s0, 16(sp)
    ld    s1, 8(sp)
    ld    s2, 0(sp)
    addi  sp, sp, 32
    ret

    
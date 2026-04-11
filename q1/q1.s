
# struct Node layout: val(int)@0, left(ptr)@8, right(ptr)@16, sizeof=24

.section .text

# struct Node* make_node(int val)
# a0 = val
# returns: a0 = pointer to new node

.globl make_node
make_node:
    addi  sp, sp, -16
    sd    ra, 8(sp)
    sd    s0, 0(sp)

    mv    s0, a0           

    li    a0, 24
    call  malloc

    sw    s0, 0(a0)        # node->val = val
    sd    x0, 8(a0)        # node->left = NULL
    sd    x0, 16(a0)       # node->right = NULL

    ld    ra, 8(sp)
    ld    s0, 0(sp)
    addi  sp, sp, 16
    ret


# struct Node* insert(struct Node* root, int val)
# a0 = root
# a1 = val
# returns: a0 = root

.globl insert
insert:
    addi  sp, sp, -32
    sd    ra, 24(sp)
    sd    s0, 16(sp)
    sd    s1, 8(sp)

    mv    s0, a0           # s0 = root
    mv    s1, a1           # s1 = val

    bne   s0, x0, insert_notnull
    mv    a0, s1
    call  make_node        # fixed: newnode
    j     insert_done

insert_notnull:
    lw    t0, 0(s0)        # t0 = root->val
    bge   s1, t0, insert_right

    ld    a0, 8(s0)
    mv    a1, s1
    call  insert
    sd    a0, 8(s0)        # root->left = result
    mv    a0, s0
    j     insert_done

insert_right:
    ble   s1, t0, insert_equal

    ld    a0, 16(s0)
    mv    a1, s1
    call  insert
    sd    a0, 16(s0)       # root->right = result
    mv    a0, s0
    j     insert_done

insert_equal:
    mv    a0, s0           #return root 

insert_done:
    ld    ra, 24(sp)
    ld    s0, 16(sp)
    ld    s1, 8(sp)
    addi  sp, sp, 32
    ret

# struct Node* get(struct Node* root, int val)
# a0 = root, a1 = val
# returns: a0 = pointer to node 

.globl get
get:
    beq   a0, x0, get_done    # NULL → return NULL

    lw    t0, 0(a0)            # t0 = root->val
    beq   a1, t0, get_done     # return a0

    blt   a1, t0, get_left
    ld    a0, 16(a0)           # go right
    j     get

get_left:
    ld    a0, 8(a0)            # go left
    j     get

get_done:
    ret


# int getAtMost(int val, struct Node* root)
# a0 = val
# a1 = root
# returns: a0 = greatest value <= val 

.globl getAtMost
getAtMost:
    addi  sp, sp, -32
    sd    ra, 24(sp)
    sd    s0, 16(sp)
    sd    s1, 8(sp)
    sd    s2, 0(sp)

    mv    s0, a0           # s0 = val
    mv    s1, a1           # s1 = current node
    li    s2, -1           # s2 = best answer

getAtMost_loop:
    beq   s1, x0, getAtMost_done

    lw    t0, 0(s1)        # t0 = node->val

    blt   t0, s0, getAtMost_lt
    beq   t0, s0, getAtMost_eq

    # go left 
    ld    s1, 8(s1)
    j     getAtMost_loop

getAtMost_lt:
    # go right
    mv    s2, t0
    ld    s1, 16(s1)
    j     getAtMost_loop

getAtMost_eq:
    # answer 
    mv    s2, t0
    j     getAtMost_done

getAtMost_done:
    mv    a0, s2
    ld    ra, 24(sp)
    ld    s0, 16(sp)
    ld    s1, 8(sp)
    ld    s2, 0(sp)
    addi  sp, sp, 32
    ret

    
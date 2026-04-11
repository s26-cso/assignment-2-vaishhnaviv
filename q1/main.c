#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

struct Node* make_node(int val);
struct Node* insert(struct Node* root, int val);
struct Node* get(struct Node* root, int val);
int getAtMost(int val, struct Node* root);

int main() {
    struct Node* root = NULL;

    int vals[] = {10, 5, 15, 3, 7, 12, 20};
    for (int i = 0; i < 7; i++)
        root = insert(root, vals[i]);

    // get: existing and missing
    printf("get(10): %s\n", get(root, 10) ? "found" : "NULL"); // found
    printf("get(7):  %s\n", get(root,  7) ? "found" : "NULL"); // found
    printf("get(99): %s\n", get(root, 99) ? "found" : "NULL"); // NULL

    // getAtMost
    printf("atmost(10): %d\n", getAtMost(10, root)); // 10
    printf("atmost(6):  %d\n", getAtMost( 6, root)); // 5
    printf("atmost(11): %d\n", getAtMost(11, root)); // 10
    printf("atmost(2):  %d\n", getAtMost( 2, root)); // -1
    printf("atmost(20): %d\n", getAtMost(20, root)); // 20

    return 0;
}
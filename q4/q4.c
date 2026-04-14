#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[8];      // stores operation name 
    int a, b;        // operands

    while (scanf("%7s %d %d", op, &a, &b) == 3) {
        char lib[32];
        // construct lib name 
        sprintf(lib, "./lib%s.so", op);
        // load the lib 
        void *lib = dlopen(lib, RTLD_LAZY);
        // get pointer to operation 
        int (*func)(int, int) = dlsym(lib, op);
        printf("%d\n", func(a, b));
        // unload the library
        dlclose(lib);
    }
    return 0;
}
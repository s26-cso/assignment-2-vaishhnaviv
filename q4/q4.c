#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[8];
    int a, b;

    while (scanf("%7s %d %d", op, &a, &b) == 3) {
        char libname[32];
        sprintf(libname, "./lib%s.so", op);
        void *handle = dlopen(libname, RTLD_LAZY);
        int (*func)(int, int) = dlsym(handle, op);
        printf("%d\n", func(a, b));
        dlclose(handle);
    }
    return 0;
}

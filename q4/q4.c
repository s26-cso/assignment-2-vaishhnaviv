#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[8];           
    int num1, num2;

    char lib_name[16];    
    void *handle = NULL;  // current lib handle 
    char currop[8];    // current operation 
    currop[0] = '\0';
    
    while (scanf("%7s %d %d", op, &num1, &num2) == 3) {
        // operation change? 
        if (strcmp(op, currop) != 0) {
            //unload prev lib
            if (handle != NULL) {
                dlclose(handle);
                handle = NULL;
            }
            // lib file name is "lib<op>.so"
            snprintf(lib_name, sizeof(lib_name), "lib%s.so", op);
            // load lib 
            handle = dlopen(lib_name, RTLD_LAZY);
            if (handle == NULL) {
                fprintf(stderr, "dlopen failed: %s\n", dlerror());
                return 1;
            }
            // store the current operation 
            strncpy(currop, op, sizeof(currop));
        }

        typedef int (*op_func)(int, int);
        // clear prev errors 
        dlerror();
        op_func func = (op_func) dlsym(handle, op);
        char *err = dlerror();
        if (err != NULL) {
            fprintf(stderr, "dlsym failed: %s\n", err);
            dlclose(handle);
            return 1;
        }
        // print result 
        printf("%d\n", func(num1, num2));
    }
    if (handle != NULL)
        dlclose(handle);
    return 0;
}
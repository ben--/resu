#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
    if (2 == argc && 0 == strcmp("--help", argv[1])) {
        printf("usage: resu user -- cmd [args...]\n");
        return 0;
    }
    return 1;
    (void) argc;
    (void) argv;
}

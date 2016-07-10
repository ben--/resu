#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    if (2 == argc && 0 == strcmp("--help", argv[1])) {
        printf("usage: resu user -- cmd [args...]\n");
        return 0;
    }

    execvp(argv[3], argv+3);
    return 1;
    (void) argc;
    (void) argv;
}

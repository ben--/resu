#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    switch (argc) {
    case 1:
        fprintf(stderr, "usage: resu user -- cmd [args...]\n");
        return 1;
    case 2:
        if (0 == strcmp("--help", argv[1])) {
            printf("usage: resu user -- cmd [args...]\n");
            return 0;
        }
        break;
    }

    if (0 != strcmp("--", argv[2])) {
        fprintf(stderr, "usage: resu user -- cmd [args...]\n");
        return 1;
    }

    execvp(argv[3], argv+3);

    /* Unreachable, except on error */
    perror("resu");
    return 1;
}

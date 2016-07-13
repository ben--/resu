#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void usage(FILE *f)
{
    fprintf(f, "usage: resu user -- cmd [args...]\n");
}

static void usage_error()
{
    usage(stderr);
    exit(1);
}

static void check_args(int argc, char **argv)
{
    switch (argc) {
    case 1:
        usage_error();
    case 2:
        if (0 == strcmp("--help", argv[1])) {
            usage(stdout);
            exit(0);
        }
        usage_error();
    case 3:
        usage_error();
    }

    if (0 != strcmp("--", argv[2])) {
        usage_error();
    }
}

int main(int argc, char **argv)
{
    struct passwd *pw;
    check_args(argc, argv);

    pw = getpwnam(argv[1]);
    setuid(pw->pw_uid);
    execvp(argv[3], argv+3);

    /* Unreachable, except on error */
    perror("resu");
    return 1;
}

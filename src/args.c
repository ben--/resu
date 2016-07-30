#include "resu.h"

void check_args(int argc, char **argv)
{
    if (argc == 1) {
        usage(stderr);
        testable_exit(1);
    } else {
        usage(stdout);
        testable_exit(0);
    }
    (void)argc;
    (void)argv;
}

#include "resu.h"

#include <string.h>

void check_args(int argc, char **argv)
{
    if (argc == 2 && 0 == strcmp(argv[1], "--help")) {
        usage(stdout);
        testable_exit(0);
    } else if (argc < 4 || 0 != strcmp(argv[2], "--")) {
        usage(stderr);
        testable_exit(1);
    }
    (void)argc;
    (void)argv;
}

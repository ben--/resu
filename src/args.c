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

void parse_user(char *user_group, char **out_group)
{
    char *sep = strchr(user_group, ':');
    if (sep == user_group) {
        testable_exit(1);
    }
    *sep = '\0';
    *out_group = sep + 1;
}

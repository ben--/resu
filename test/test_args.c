#include "resu.h"

#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <cmocka.h>

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

void usage(FILE *f)
{
    check_expected(f);
}

void testable_exit(int status)
{
    check_expected(status);
}

static void provides_help_with_full_help_arg(void **state)
{
    static char * args[] = {"resu", "--help", "\0"};

    expect_value(usage, f, stdout);
    expect_value(testable_exit, status, 0);

    check_args(2, args);
    (void)state;
}

static void provides_usage_when_args_are_missing(void **state)
{
    static char * args[] = {"resu", "\0"};

    expect_value(usage, f, stderr);
    expect_value(testable_exit, status, 1);

    check_args(1, args);
    (void)state;
}

int main(void) {
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(provides_help_with_full_help_arg),
        cmocka_unit_test(provides_usage_when_args_are_missing),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}

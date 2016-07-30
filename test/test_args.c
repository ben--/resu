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

    check_args(sizeof(args)/sizeof(*args)-1, args);
    (void)state;
}

static void returns_cleanly_when_good_args_are_given(void **state)
{
    static char * args[] = {"resu", "nobody:nogroup", "--", "true", "\0"};

    // expect no usage
    // expect no exit()

    check_args(sizeof(args)/sizeof(*args)-1, args);
    (void)state;

}

static void provides_usage_when_args_are_missing(void **state)
{
    static char * args[] = {"resu", "\0"};

    expect_value(usage, f, stderr);
    expect_value(testable_exit, status, 1);

    check_args(sizeof(args)/sizeof(*args)-1, args);
    (void)state;
}

static void provides_usage_when_only_one_arg_is_given(void **state)
{
    static char * args[] = {"resu", "nobody:nogroup", "\0"};

    expect_value(usage, f, stderr);
    expect_value(testable_exit, status, 1);

    check_args(sizeof(args)/sizeof(*args)-1, args);
    (void)state;
}

static void provides_usage_when_only_two_args_are_given(void **state)
{
    static char * args[] = {"resu", "nobody:nogroup", "--", "\0"};

    expect_value(usage, f, stderr);
    expect_value(testable_exit, status, 1);

    check_args(sizeof(args)/sizeof(*args)-1, args);
    (void)state;
}

static void results_in_an_error_when_the_double_dash_is_omitted(void **state)
{
    static char * args[] = {"resu", "nobody:nogroup", "whatever", "true", "\0"};

    expect_value(usage, f, stderr);
    expect_value(testable_exit, status, 1);

    check_args(sizeof(args)/sizeof(*args)-1, args);
    (void)state;
}

int main(void) {
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(provides_help_with_full_help_arg),
        cmocka_unit_test(returns_cleanly_when_good_args_are_given),
        cmocka_unit_test(provides_usage_when_args_are_missing),
        cmocka_unit_test(provides_usage_when_only_one_arg_is_given),
        cmocka_unit_test(provides_usage_when_only_two_args_are_given),
        cmocka_unit_test(results_in_an_error_when_the_double_dash_is_omitted),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}

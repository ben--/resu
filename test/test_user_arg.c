#include "resu.h"

#include <setjmp.h>
#include <stdarg.h>
#include <stddef.h>
#include <cmocka.h>

void usage(FILE *f) { (void)f; }

void testable_exit(int status)
{
    check_expected(status);
}

static void returns_group_via_output_parameter(void **state)
{
    char user_group[] = "user:group";

    char *actual_group;
    parse_user(user_group, &actual_group);

    assert_string_equal(actual_group, "group");
    (void)state;
}

static void null_terminates_user(void **state)
{
    char user_group[] = "user:group";

    char *ignored_group;
    parse_user(user_group, &ignored_group);

    assert_string_equal(user_group, "user");
    (void)state;
}

static void exits_when_user_is_blank(void **state)
{
    char user_group[] = ":nogroup";

    expect_value(testable_exit, status, 1);

    char *ignored_group;
    parse_user(user_group, &ignored_group);
    (void)state;
}

int main(void) {
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(returns_group_via_output_parameter),
        cmocka_unit_test(null_terminates_user),
        cmocka_unit_test(exits_when_user_is_blank),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}

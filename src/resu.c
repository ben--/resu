#include "resu.h"

#include <grp.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void _usage(FILE *f)
{
    fprintf(f, "usage: resu user:group -- cmd [args...]\n");
}

static void _usage_error()
{
    _usage(stderr);
    exit(1);
}

static void _check_args(int argc, char **argv)
{
    if (2 == argc && 0 == strcmp(argv[1], "--help")) {
        _usage(stdout);
        exit(0);
    }

    if (argc < 4) {
        _usage_error();
    }
    if (0 != strcmp(argv[2], "--")) {
        _usage_error();
    }
}

static char * _split_group_from_user(char *user_group)
{
    char *group = strchr(user_group, ':');
    if (NULL == group) {
        _usage_error();
    }
    *group++ = '\0';
    return group;
}

static unsigned long _parse_ul(const char *type, const char *str)
{
    char *endptr;
    unsigned long ul = strtoul(str, &endptr, 10);
    if (endptr == str || *endptr != '\0') {
        fprintf(stderr, "resu: Unknown %s `%s'", type, str);
        exit(1);
    }
    return ul;
}

static unsigned long _gid(const char *group)
{
    struct group *gr = getgrnam(group);
    if (gr != NULL) {
        return gr->gr_gid;
    } else {
        return _parse_ul("group", group);
    }
}

static unsigned long _uid(const char *user)
{
    struct passwd *pw = getpwnam(user);
    if (pw != NULL) {
        return pw->pw_uid;
    } else {
        return _parse_ul("user", user);
    }
}

int main(int argc, char **argv)
{
    _check_args(argc, argv);

    char *user = argv[1];
    char *group = _split_group_from_user(user);

    if (0 != setgid(_gid(group))) {
        perror("resu");
        exit(1);
    }

    if (0 != setuid(_uid(user))) {
        perror("resu");
        exit(1);
    }

    execvp(argv[3], argv+3);

    /* Unreachable, except on error */
    perror("resu");
    return 1;
}

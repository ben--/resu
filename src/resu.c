#include "resu.h"

#include <grp.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void usage(FILE *f)
{
    fprintf(f, "usage: resu user:group -- cmd [args...]\n");
}

static void _check_args(int argc, char **argv)
{
    if (argc == 2 && 0 == strcmp(argv[1], "--help")) {
        usage(stdout);
        exit(0);
    }

    if (argc < 4 || NULL == strchr(argv[1], ':') || 0 != strcmp(argv[2], "--")) {
        usage(stderr);
        exit(1);
    }
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
    char *group = strchr(user, ':');
    *group++ = '\0';

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

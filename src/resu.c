#include <grp.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void usage(FILE *f)
{
    fprintf(f, "usage: resu user:group -- cmd [args...]\n");
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
    check_args(argc, argv);

    char *user = argv[1];
    char *group = strchr(user, ':');
    *group++ = '\0'; /* FIXME: set after string on empty group */

    struct group *gr = getgrnam(group);
    setgid(gr->gr_gid);

    struct passwd *pw = getpwnam(user);
    if (pw != NULL) {
        if (0 != setuid(pw->pw_uid)) {
            perror("resu");
            exit(1);
        }
    } else {
        char *endptr;
        unsigned long uid = strtoul(user, &endptr, 10);
        if (endptr == user || *endptr != '\0') {
            fprintf(stderr, "resu: Unknown user `%s'", user);
            exit(1);
        }
        if (0 != setuid(uid)) {
            perror("resu");
            exit(1);
        }
    }

    execvp(argv[3], argv+3);

    /* Unreachable, except on error */
    perror("resu");
    return 1;
}

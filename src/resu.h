#ifndef __RESU_H__
#define __RESU_H__

#include <stdio.h>
#include <stdlib.h>

void check_args(int argc, char **argv);
void parse_user(char *user_group, char **out_group);
void usage(FILE *f);

void testable_exit(int status);

#endif /* !__RESU_H__ */

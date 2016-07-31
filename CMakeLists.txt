cmake_minimum_required (VERSION 2.6)
project (resu)

add_compile_options(
    -std=c99
    -Wall -Werror -Wextra -Wpedantic
    -Dtested_main=main
    -Dtestable_exit=exit
    )

add_executable(resu src/resu.c)

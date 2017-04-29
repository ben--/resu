cmake_minimum_required (VERSION 2.6)
project (resu)

set(RESU_EXECUTABLE resu CACHE STRING "Override name of executable")

add_compile_options(
    -std=c99
    -Wall -Werror -Wextra -Wpedantic
    )

add_executable(${RESU_EXECUTABLE} src/resu.c)

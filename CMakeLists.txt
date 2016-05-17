cmake_minimum_required (VERSION 2.6)
project (resu)

add_compile_options(
  -Wall -Werror -Wextra -Wpedantic
  )

add_executable(resu src/resu.c)

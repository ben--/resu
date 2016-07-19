cmake_minimum_required (VERSION 2.6)

project(resu-test C)
find_package(cmocka REQUIRED)

function (ADD_CMOCKA_TEST _testName)
    add_executable(${_testName} ${ARGN})
    target_link_libraries(${_testName} ${CMOCKA_LIBRARY} -lasan)
    add_test(${_testName} ${_testName})
    set_property(TEST ${_testName} PROPERTY ENVIRONMENT CMOCKA_XML_FILE=${_testName}-results.xml)
endfunction (ADD_CMOCKA_TEST)

add_compile_options(
    --std=c99
    -Wall -Werror -Wextra -Wpedantic
    )

add_cmocka_test(test_args ../test/test_args.c ../src/resu.c)

enable_testing()

cmake_minimum_required(VERSION 2.6)

project(TinyPnR)

INCLUDE_DIRECTORIES(./src/)

SET(EXTRA_CXX_COMPILE_FLAGS "-std=c++11 -I./src -I./test -I/opt/local/include -O2 -Werror -Wall -pedantic")

SET(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${EXTRA_CXX_COMPILE_FLAGS}")

INCLUDE_DIRECTORIES(./src/)

SET(SRC_FILES ./src/bitstream_format.cpp
              ./src/place.cpp)

SET(TEST_FILES ./test/place_tests.cpp
               ./test/bitstream_converter_tests.cpp)

SET(PNR_MAIN_FILES ./src/pnr_main.cpp)

add_executable(all-tests ${SRC_FILES} ${TEST_FILES})
add_executable(tiny-pnr ${SRC_FILES} ${PNR_MAIN_FILES})

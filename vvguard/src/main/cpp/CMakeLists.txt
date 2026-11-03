cmake_minimum_required(VERSION 3.22.1)
project(vvguard C)
add_library(vvguard SHARED vvguard.c)
target_link_libraries(vvguard log)

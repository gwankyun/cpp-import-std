cmake_minimum_required(VERSION 3.30...4.4)

project(check_export_import_header LANGUAGES CXX)

add_executable(check_main src/main.cpp)
target_sources(
  check_main
  PUBLIC
    FILE_SET check_headers
      TYPE HEADERS
      BASE_DIRS src
      FILES src/test_header.h
)
target_compile_features(check_main PRIVATE cxx_std_20)

# cmake版本
cmake_minimum_required(VERSION 4.1.0) # C++20模塊支持

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")

# 項目名
project(std_module LANGUAGES CXX) # 指定C++可以跳過C編譯器檢測

# include(cmake/std.cmake)

add_executable(main)
target_sources(main
  PRIVATE FILE_SET CXX_MODULES FILES
    src/main.ixx
)
#[[
target_link_libraries(main
  PRIVATE
    std
)
#]]
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  set_target_properties(main
    PROPERTIES
      CXX_MODULE_STD ON
      CXX_STANDARD 23
  )
endif()
target_compile_features(main PRIVATE cxx_std_23)

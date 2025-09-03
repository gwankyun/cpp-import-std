# cmake版本
cmake_minimum_required(VERSION 4.1.1) # C++20模塊支持

# CMake對Clang的import std;支持還在試驗階段
# 需要設置此UUID，以下值衹保證在4.1.0 4.1.1有效
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444"
  CACHE STRING "UUID for import std")

# 項目名
project(std_module LANGUAGES CXX) # 指定C++可以跳過C編譯器檢測

# 為目標啟用標準庫模塊
function(target_enable_module_std tgt enable_std)
  # 檢查當前C++編譯器是否為Clang或GNU
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set_target_properties(${tgt}
      PROPERTIES
      CXX_MODULE_STD ${enable_std}
    )
  endif()
endfunction()

# 全局啟用標準庫模塊
function(enable_module_std enable_std)
  # 檢查當前C++編譯器是否為Clang或GNU
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set(CMAKE_CXX_MODULE_STD ${enable_std} PARENT_SCOPE)
  endif()
endfunction()

enable_module_std(ON)

add_executable(main)
target_sources(main
  PRIVATE FILE_SET CXX_MODULES FILES
  src/compiler.ixx
  PRIVATE
  src/main.cpp
  src/compiler.cpp
)
target_compile_features(main PRIVATE cxx_std_23)

# 按目標不啟用標準庫模塊，取消下行注释在Clang下就會報fatal error: module 'std' not found
# target_enable_module_std(main OFF)

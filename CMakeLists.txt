# cmake版本
cmake_minimum_required(VERSION 4.1.0) # C++20模塊支持

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")

# 項目名
project(std_module LANGUAGES CXX) # 指定C++可以跳過C編譯器檢測

find_package(spdlog REQUIRED)

# 啟用標準庫模塊
function(target_enable_module_std tgt)
  # 檢查當前C++編譯器是否為Clang或GNU
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set_target_properties(${tgt}
      PROPERTIES
      CXX_MODULE_STD ON
    )
  endif()
endfunction()

add_executable(main)
target_sources(main
  PRIVATE FILE_SET CXX_MODULES FILES
  src/main.ixx
  PRIVATE
  src/main.cpp
)
target_link_libraries(main
  PRIVATE
  spdlog::spdlog
)
target_enable_module_std(main)
target_compile_features(main PRIVATE cxx_std_23)

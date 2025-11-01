# cmake版本
cmake_minimum_required(VERSION 4.2) # C++20模塊支持

# CMake對Clang的import std;支持還在試驗階段
# 需要設置此UUID，以下值衹保證在[4.1.0, 4.2.0-rc2]有效
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444"
  CACHE STRING "UUID for import std")

# 項目名
project(cpp_import_std
  # 以下屬性皆可選
  LANGUAGES CXX # 指定C++可以跳過C編譯器檢測
  VERSION 0.1.0 # 版本
  DESCRIPTION "在msvc及clang下使用import std;"
)

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

# 添加庫
add_library(compiler)
target_sources(compiler
  PUBLIC FILE_SET CXX_MODULES FILES           # 對外接口單元需要公開
    FILE_SET cxx_modules TYPE CXX_MODULES
    BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}/src # 模塊根目錄，讓編譯器找到模塊接口
    FILES src/compiler.ixx                    # 模塊接口單元
  PRIVATE
    src/compiler.cpp                          # 模塊實現單元
)
target_compile_features(compiler PRIVATE cxx_std_23)

# 添加可執行文件
add_executable(main)
target_sources(main
  PRIVATE
    src/main.cpp
    src/compiler.cpp
)
target_link_libraries(main PRIVATE compiler) # 鏈接compiler庫
target_compile_features(main PRIVATE cxx_std_23)

# 按目標不啟用標準庫模塊，取消下行注释在Clang下就會報fatal error: module 'std' not found
# target_enable_module_std(main OFF)

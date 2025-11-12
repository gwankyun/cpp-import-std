# cmake版本
cmake_minimum_required(VERSION 4.0) # C++20模塊支持

set(uuid "")

# CMake對Clang的import std;支持還在試驗階段
# 需要設置此UUID，以下值衹保證在[4.1.0, 4.2.0-rc2]有效
if(CMAKE_VERSION VERSION_GREATER_EQUAL "4.1.0")
  set(uuid "d0edc3af-4c50-42ea-a356-e2862fe7a444")
else()
  set(uuid "a9e1cf81-9932-4810-974b-6eccaf14e457")
endif()

set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD ${uuid}
  CACHE STRING "UUID for import std")

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(CMAKE_CXX_EXTENSIONS OFF)
endif()

# 項目名
project(cpp_import_std

  # 以下屬性皆可選
  LANGUAGES CXX # 指定C++可以跳過C編譯器檢測
  VERSION 0.1.0 # 版本
  DESCRIPTION "在msvc及clang下使用import std;"
)

# generate_clangd_config enable_module_std target_enable_module_std
include(cmake/clang.cmake)

# 調用函數生成.clangd配置文件
generate_clangd_config(std std.compat compiler)

enable_module_std(ON)

# 添加庫
add_library(compiler)
target_sources(compiler
  PUBLIC                   # 對外接口單元需要公開
    FILE_SET CXX_MODULES
    BASE_DIRS src          # 模塊根目錄，讓編譯器找到模塊接口
    FILES src/compiler.ixx # 模塊接口單元
  PRIVATE
    src/compiler.cpp       # 模塊實現單元
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

# 在main生成後複製.clangd配置文件到項目根目錄
copy_clangd_config(main)

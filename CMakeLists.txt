# cmake版本
cmake_minimum_required(VERSION 3.30) # std模塊支持

include(CMakePrintHelpers)

cmake_print_variables(CMAKE_VERSION)
cmake_print_variables(USE_IMPORT_STD_UUID)

# get_import_std enable_module_std target_enable_module_std
include(cmake/cxx_module.cmake)

# CMake對Clang的import std;支持還在試驗階段
if(USE_IMPORT_STD_UUID STREQUAL "TRUE")
  # 需要設置此UUID
  get_import_std(import_std_uuid)
  cmake_print_variables(import_std_uuid)

  set(
    CMAKE_EXPERIMENTAL_CXX_IMPORT_STD
    ${import_std_uuid}
    CACHE STRING
    "UUID for import std"
  )
endif()

# 項目名
project(
  cpp_import_std
  # 以下屬性皆可選
  LANGUAGES
    CXX # 指定C++可以跳過C編譯器檢測
  VERSION
    0.1.0 # 版本
  DESCRIPTION "在msvc及clang下使用import std;"
)

# 全局启用標準庫模塊
enable_module_std(ON)

# 添加庫
add_subdirectory(compiler)

# 添加可執行文件
add_executable(main)
target_sources(
  main
  PRIVATE #
    src/main.cpp
)
target_link_libraries(main PRIVATE compiler) # 鏈接compiler庫
target_compile_features(main PRIVATE cxx_std_23)

# 按目標不啟用標準庫模塊，取消下行注释在Clang下就會報fatal error: module 'std' not found
# target_enable_module_std(main OFF)

include(cmake/clang.cmake) # clang_copy_dll

# 使用 clang 編譯器
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  # 複製 libc++.dll 和 libunwind.dll 到構建目錄
  clang_copy_dll("$ENV{LLVM_MINGW_ROOT}/bin" main)

  # 生成.clangd配置文件
  clang_generate_clangd(generate_clangd)
endif()

# cmake版本
cmake_minimum_required(VERSION 3.30...4.4) # std模塊支持

include(CMakePrintHelpers)

cmake_print_variables(CMAKE_VERSION)
cmake_print_variables(USE_MODULE)
cmake_print_variables(USE_IMPORT_STD_UUID)
cmake_print_variables(USE_NINJA)

if(DEFINED ENV{USE_TRY_COMPILE})
  set(USE_TRY_COMPILE "$ENV{USE_TRY_COMPILE}")
elseif(NOT DEFINED USE_TRY_COMPILE)
  set(USE_TRY_COMPILE OFF)
endif()

cmake_print_variables(USE_TRY_COMPILE)

# enable_module_std target_enable_module_std
# check_module_support check_import_std_support
# check_export_import_header_support
# precompile_std_gcm
include(cmake/cxx_module.cmake)

# 全局啟用標準庫模塊（enable_module_std內部會判斷MSVC/clang-cl自動設OFF）
enable_module_std(ON)

# 項目名
project(
  cpp_import_std
  LANGUAGES CXX
  VERSION 0.1.0
  DESCRIPTION "在msvc及clang下使用import std;"
)

cmake_print_variables(CMAKE_SYSTEM)
cmake_print_variables(CMAKE_SYSTEM_NAME)
cmake_print_variables(CMAKE_SYSTEM_VERSION)
cmake_print_variables(CMAKE_SYSTEM_PROCESSOR)

cmake_print_variables(CMAKE_CXX_COMPILER_ID)
cmake_print_variables(CMAKE_CXX_COMPILER_FRONTEND_VARIANT)
cmake_print_variables(CMAKE_CXX_COMPILER_VERSION)

cmake_print_variables(CMAKE_GENERATOR)
cmake_print_variables(CMAKE_GENERATOR_INSTANCE)

# GCC需要預編譯std.gcm才能使用import std
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND USE_IMPORT_STD)
  precompile_std_gcm(precompile_ok)
  if(NOT precompile_ok)
    set(USE_IMPORT_STD OFF)
  endif()
endif()

# try_compile檢測編譯器實際支持能力
if(USE_TRY_COMPILE)
  check_module_support(USE_MODULE)
  check_import_std_support(USE_IMPORT_STD)
  check_export_import_header_support(USE_EXPORT_IMPORT_HEADER)
endif()

# 約束邏輯：模塊關→import_std關→export_import_header關
if(NOT USE_MODULE)
  set(USE_IMPORT_STD OFF)
  set(USE_EXPORT_IMPORT_HEADER OFF)
endif()

if(NOT USE_IMPORT_STD)
  set(USE_IMPORT_STD_UUID OFF)
endif()

cmake_print_variables(USE_IMPORT_STD)

add_library(import_std_option INTERFACE)
target_compile_definitions(
  import_std_option
  INTERFACE
    USE_IMPORT_STD=$<BOOL:${USE_IMPORT_STD}>
    USE_MODULE=$<BOOL:${USE_MODULE}>
    USE_EXPORT_IMPORT_HEADER=$<BOOL:${USE_EXPORT_IMPORT_HEADER}>
    USE_NINJA=$<BOOL:${USE_NINJA}>
)

# 添加庫
add_subdirectory(compiler)

# 添加可執行文件
add_executable(main)
target_sources(
  main
  PRIVATE #
    src/main.cpp
)
target_link_libraries(main PRIVATE compiler::compiler import_std_option) # 鏈接compiler庫
target_compile_features(main PRIVATE cxx_std_23)

# 按目標不啟用標準庫模塊，取消下行注释在Clang下就會報fatal error: module 'std' not found
# target_enable_module_std(main OFF)

# 啟用測試
enable_testing()
include(CTest)

# main返回0就是成功
add_test(NAME tests COMMAND main)

# add_bundle_command
include(cmake/bundle.cmake)

# 複製運行時文件
add_bundle_command(TARGET main)

# clang_generate_clangd
include(cmake/clang.cmake)

# 生成.clangd配置文件
clang_generate_clangd(generate_clangd)

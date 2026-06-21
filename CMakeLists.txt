# cmake版本
cmake_minimum_required(VERSION 4.4) # std模塊支持

include(CMakePrintHelpers)

cmake_print_variables(CMAKE_VERSION)
cmake_print_variables(USE_MODULE)
cmake_print_variables(USE_IMPORT_STD_UUID)
cmake_print_variables(USE_NINJA)
cmake_print_variables(USE_TRY_COMPILE)

# get_import_std enable_module_std target_enable_module_std
include(cmake/cxx_module.cmake)

if(USE_MODULE STREQUAL "OFF")
  set(USE_IMPORT_STD "OFF")
  set(USE_EXPORT_IMPORT_HEADER "OFF")
endif()

if(USE_IMPORT_STD STREQUAL "OFF")
  set(USE_IMPORT_STD_UUID "OFF")
endif()

# CMake對Clang的import std;支持還在試驗階段
if(USE_IMPORT_STD_UUID STREQUAL "ON")
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
  LANGUAGES CXX # 指定C++可以跳過C編譯器檢測
  VERSION 0.1.0 # 版本
  DESCRIPTION "在msvc及clang下使用import std;"
)

cmake_print_variables(CMAKE_CXX_COMPILER_ID)
cmake_print_variables(CMAKE_CXX_COMPILER_FRONTEND_VARIANT)
cmake_print_variables(CMAKE_CXX_COMPILER_VERSION)

# 全局启用標準庫模塊
if(USE_IMPORT_STD_UUID STREQUAL "ON")
  enable_module_std(ON)
endif()

cmake_print_variables(USE_IMPORT_STD)

if(USE_TRY_COMPILE STREQUAL "ON")
  try_compile(
    test_module_result
    SOURCES_TYPE CXX_MODULE
    SOURCE_FROM_CONTENT
      test_module.ixx
      [=[
      export module test_module;
      export int test_add(int a, int b)
      {
          return a + b;
      }
      ]=]
    SOURCES_TYPE NORMAL
    SOURCE_FROM_CONTENT
      main.cpp
      [=[
      import test_module;
      int main()
      {
          return test_add(1, 2) - 3;
      }
      ]=]
    CXX_STANDARD 23
  )
  cmake_print_variables(test_module_result)
  if(test_module_result STREQUAL "TRUE")
    set(USE_MODULE "ON")
  else()
    set(USE_MODULE "OFF")
  endif()

  list(
    APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
    CMAKE_EXPERIMENTAL_CXX_IMPORT_STD
    CMAKE_CXX_MODULE_STD
    CMAKE_CXX_COMPILER_CLANG_SCAN_DEPS
  )

  try_compile(
    test_import_std_result
    SOURCE_FROM_CONTENT
      main.cpp
      [=[
      import std;
      int main()
      {
          std::cout << 0 << std::endl;
          return 0;
      }
      ]=]
    CXX_STANDARD 23
  )
  cmake_print_variables(test_import_std_result)
  if(test_import_std_result STREQUAL "TRUE")
    set(USE_IMPORT_STD "ON")
  else()
    set(USE_IMPORT_STD "OFF")
  endif()
endif()

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

include(cmake/target_copy_files.cmake) # target_copy_files
include(cmake/clang.cmake) # clang_generate_clangd

# 啟用測試
enable_testing()
include(CTest)

# main返回0就是成功
add_test(NAME tests COMMAND main)

set(dirs "${COMPILER_BIN}")
cmake_path(NORMAL_PATH dirs)

# 複製運行時文件
if(CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
  add_custom_command(
    TARGET main
    POST_BUILD
    COMMAND
      ${CMAKE_COMMAND}
      # gersemi: off
      -D apps="$<TARGET_FILE:main>"
      -D dirs="${dirs}"
      "$<$<BOOL:${CMAKE_OBJDUMP}>:-D CMAKE_OBJDUMP=${CMAKE_OBJDUMP}>"
      # gersemi: on
      -P "${CMAKE_SOURCE_DIR}/cmake/bundle.cmake"
    COMMENT ""
  )
endif()

if(
  (CMAKE_CXX_COMPILER_ID STREQUAL "Clang") #
  AND (CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "GNU")
)
  # 生成.clangd配置文件
  clang_generate_clangd(generate_clangd)
endif()

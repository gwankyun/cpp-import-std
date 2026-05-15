set(compiler_info_h "${CMAKE_BINARY_DIR}/compiler_info.h")

# gersemi: off
configure_file(
  src/compiler_info.h.in # 輸入模板文件
  "${compiler_info_h}"   # 輸出文件
  @ONLY                  # 衹替換 @VAR@ 形式的變量
)
# gersemi: on

add_library(compiler_base INTERFACE)
target_sources(
  compiler_base
  INTERFACE src/compiler_impl.hpp
  INTERFACE
    FILE_SET compiler_base_h
      TYPE HEADERS
      BASE_DIRS ${CMAKE_BINARY_DIR}
      FILES "${compiler_info_h}"
)
add_library(compiler::base ALIAS compiler_base)

# 添加庫
if(USE_MODULE STREQUAL "ON")
  add_library(compiler_module)
  target_sources(
    compiler_module
    PUBLIC # 對外接口單元需要公開
      FILE_SET CXX_MODULES
        BASE_DIRS
          src # 模塊根目錄，讓編譯器找到模塊接口
        FILES
          src/compiler.ixx # 模塊接口單元
    PRIVATE
      src/compiler.cpp # 模塊實現單元
      src/compiler.h # 模塊接口單元
  )
  target_compile_features(compiler_module PRIVATE cxx_std_23)
  target_link_libraries(
    compiler_module
    PRIVATE #
      import_std_option
      compiler::base
  )
  add_library(compiler::module ALIAS compiler_module)
endif()

if((USE_MODULE STREQUAL "OFF") OR ON)
  add_library(compiler_legacy)
  target_sources(
    compiler_legacy
    PUBLIC
      FILE_SET
        HEADERS #
        BASE_DIRS src
        FILES src/compiler.h
    PRIVATE src/compiler_legacy.cpp
  )
  target_compile_features(compiler_legacy PRIVATE cxx_std_23)
  target_link_libraries(
    compiler_legacy
    PRIVATE #
      import_std_option
      compiler::base
  )
  add_library(compiler::legacy ALIAS compiler_legacy)
endif()

if(USE_MODULE STREQUAL "ON")
  add_library(compiler::compiler ALIAS compiler_module)
else()
  add_library(compiler::compiler ALIAS compiler_legacy)
endif()

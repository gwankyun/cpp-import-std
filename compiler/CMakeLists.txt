set(compiler_info_h "${CMAKE_BINARY_DIR}/compiler_info.h")

# gersemi: off
configure_file(
  src/compiler_info.h.in # 輸入模板文件
  "${compiler_info_h}"   # 輸出文件
  @ONLY                  # 衹替換 @VAR@ 形式的變量
)
# gersemi: on

# 添加庫
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
  PRIVATE
    FILE_SET
      HEADERS #
      BASE_DIRS ${CMAKE_BINARY_DIR}
      FILES "${compiler_info_h}"
)
target_compile_features(compiler_module PRIVATE cxx_std_23)
target_link_libraries(compiler_module PRIVATE import_std_option)

add_library(compiler::compiler ALIAS compiler_module) 

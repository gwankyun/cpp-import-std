# 读取环境变量
set(std_path "$ENV{STD_PATH}")
set(std_module "$ENV{STD_MODULE}")

# std.cppm或者std.cc的路徑
set(src_path "${std_path}/${std_module}")

# 加到工程的標準庫模塊
set(dest_path "${PROJECT_BINARY_DIR}/${std_module}")

# 若编译器为 Clang 或 GNU，执行复制脚本
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -DSRC_PATH=${src_path}
    -DDEST_PATH=${dest_path}
    -P cmake/copy-std-module.cmake
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE copy_result
    ERROR_VARIABLE copy_error
  )

  if(copy_result)
    message(FATAL_ERROR "copy ${std_module} failed: ${copy_error}")
  endif()
endif()

# 若编译器为 Clang，创建 std_clang 库
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  add_library(std_clang)
  target_sources(std_clang
    PUBLIC FILE_SET CXX_MODULES FILES
      ${dest_path}
  )
  target_include_directories(std_clang
    PRIVATE
      ${std_path}
  )
  # 禁用关于保留标识符和保留模块标识符的警告
  target_compile_options(std_clang
    PRIVATE
      -Wno-reserved-identifier
      -Wno-reserved-module-identifier
  )
  target_compile_features(std_clang
    PRIVATE
      cxx_std_23
  )
endif()

# 创建接口库并链接
add_library(std INTERFACE)
target_link_libraries(std
  INTERFACE
    $<$<CXX_COMPILER_ID:Clang>:std_clang>
)

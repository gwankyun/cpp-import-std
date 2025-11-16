message(STATUS "CMAKE_SOURCE_DIR: ${SOURCE_DIR}")
message(STATUS "CMAKE_BINARY_DIR: ${BINARY_DIR}")
message(STATUS "CONFIG: ${CONFIG}")

set(clang_d "")
string(APPEND clang_d "CompileFlags:\n")
string(APPEND clang_d "  CompilationDatabase: build/clang-mingw\n")
string(APPEND clang_d "  Add:\n")
string(APPEND clang_d "    - -xc++\n")
string(APPEND clang_d "    - -std=c++23\n")
string(APPEND clang_d "    - -stdlib=libc++\n")

# 查找${CONFIG}配置下的所有.pcm文件
file(GLOB_RECURSE pcm_file_list
  "${BINARY_DIR}/**/*.pcm"
)

if(pcm_file_list)
  foreach(pcm_file IN LISTS pcm_file_list)
    string(REGEX MATCH "${CONFIG}/([^/]+)\.pcm$" match_result ${pcm_file})
    if(match_result)
      message(STATUS "found ${pcm_file}")
      set(clang_d "${clang_d}    - -fmodule-file=${CMAKE_MATCH_1}=${pcm_file}\n")
    endif()
  endforeach()
endif()

set(clang_config "${SOURCE_DIR}/.clangd")

file(WRITE "${clang_config}" "${clang_d}")

# 生成.clangd配置文件
function(generate_clangd_config)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CLANGD_CONFIG "${CMAKE_SOURCE_DIR}/.clangd")

    set(clang_d
      "CompileFlags:\n"
      "  CompilationDatabase: build/clang-mingw\n"
      "  Add:\n"
      "    - -xc++\n"
      "    - -std=c++23\n"
      "    - -stdlib=libc++\n"
    )

    set(std_lib std std.compat)

    foreach(file IN LISTS ARGN)
      if(${file} IN_LIST std_lib)
        string(APPEND clang_d
          "    - -fmodule-file=${file}=${CMAKE_BINARY_DIR}/CMakeFiles/__cmake_cxx23.dir/Release/${file}.pcm\n"
        )
      else()
        string(APPEND clang_d
          "    - -fmodule-file=${file}=${CMAKE_BINARY_DIR}/CMakeFiles/compiler.dir/Release/${file}.pcm\n"
        )
      endif()
    endforeach()

    # 生成配置文件
    file(WRITE "${CLANGD_CONFIG}" ${clang_d})

    message(STATUS ".clangd config file generated at: ${CLANGD_CONFIG}")
  endif()
endfunction()

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

# 生成.clangd配置文件
function(generate_clangd_config)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CLANGD_CONFIG "${CMAKE_SOURCE_DIR}/.clangd")

    set(clang_d_base
      "CompileFlags:\n"
      "  CompilationDatabase: build/clang-mingw\n"
      "  Add:\n"
      "    - -xc++\n"
      "    - -std=c++23\n"
      "    - -stdlib=libc++\n"
    )

    set(std_lib std std.compat)

    # 判斷是否多配置生成器
    get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

    if(is_multi_config)
      # 多配置生成器：每个配置生成單獨的文件
      foreach(config ${CMAKE_CONFIGURATION_TYPES})
        set(clang_d "${clang_d_base}")

        foreach(file IN LISTS ARGN)
          if(${file} IN_LIST std_lib)
            set(pcm_path "${CMAKE_BINARY_DIR}/CMakeFiles/__cmake_cxx23.dir/${config}/${file}.pcm")
          else()
            set(pcm_path "${CMAKE_BINARY_DIR}/CMakeFiles/${file}.dir/${config}/${file}.pcm")
          endif()

          string(APPEND clang_d "    - -fmodule-file=${file}=${pcm_path}\n")
        endforeach()

        file(WRITE "${CMAKE_BINARY_DIR}/.clangd.${config}" ${clang_d})
      endforeach()

    else()
      # 單配置生成器：直接使用CMAKE_BUILD_TYPE
      set(clang_d "${clang_d_base}")

      if(NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE "Release")
      endif()

      foreach(file IN LISTS ARGN)
        if(${file} IN_LIST std_lib)
          set(pcm_path "${CMAKE_BINARY_DIR}/CMakeFiles/__cmake_cxx23.dir/${CMAKE_BUILD_TYPE}/${file}.pcm")
        else()
          set(pcm_path "${CMAKE_BINARY_DIR}/CMakeFiles/${file}.dir/${CMAKE_BUILD_TYPE}/${file}.pcm")
        endif()

        string(APPEND clang_d "    - -fmodule-file=${file}=${pcm_path}\n")
      endforeach()

      file(WRITE "${CLANGD_CONFIG}" ${clang_d})
    endif()

    message(STATUS ".clangd config file generation configured")
  else()
    message(STATUS "Clang compiler not found, skip generating .clangd config file.")
  endif()
endfunction()

# 複製.clangd配置文件到項目根目錄
function(copy_clangd_config tgt)
  if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)

    if(is_multi_config)
      # 添加構建後命令，複製對應配置的文件到項目根目录
      add_custom_command(
        TARGET ${tgt} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
        "${CMAKE_BINARY_DIR}/.clangd.$<CONFIG>"
        "${CMAKE_SOURCE_DIR}/.clangd"
      )
    endif()
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

# 複製 `path` 路徑下的 `libc++.dll` 和 `libunwind.dll` 到 `target` 生成文件同目錄
function(clang_copy_dll path target)
  # 查找 libc++.dll 和 libunwind.dll
  set(bin_path "${path}")
  find_file(libcpp_dll libc++.dll PATHS "${bin_path}" NO_DEFAULT_PATH)
  find_file(libunwind_dll libunwind.dll PATHS "${bin_path}" NO_DEFAULT_PATH)

  if(libcpp_dll AND libunwind_dll)
    # 複製 DLL 到可執行文件所在目錄
    add_custom_command(
      TARGET ${target}
      POST_BUILD
      COMMAND
        ${CMAKE_COMMAND} -E copy_if_different "${libcpp_dll}" "${libunwind_dll}"
        "$<TARGET_FILE_DIR:${target}>"
      COMMENT "複製制 libc++.dll 和 libunwind.dll 到構建目錄"
    )
  else()
    message(
      WARNING
      "未找到 libc++.dll 或 libunwind.dll，請確保 LLVM_MINGW_ROOT 環境變量已設置"
    )
  endif()
endfunction()

function(clang_generate_clangd target)
  # gersemi: off
  add_custom_target(
    ${target}
    COMMAND
      ${CMAKE_COMMAND}
      -D SOURCE_DIR="${CMAKE_SOURCE_DIR}"
      -D BINARY_DIR="${CMAKE_BINARY_DIR}"
      -D CONFIG="$<CONFIG>"
      -P "${CMAKE_SOURCE_DIR}/cmake/generate_clangd.cmake"
    COMMENT "生成.clangd配置文件"
  )
  # gersemi: on
endfunction()

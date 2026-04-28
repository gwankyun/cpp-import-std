function(target_copy_files)
  cmake_parse_arguments(
    copy_dll_arg # 前綴
    "" # 選項值
    "TARGET" # 單值
    "FILES" # 多值
    ${ARGN}
  )

  set(target ${copy_dll_arg_TARGET})
  set(files ${copy_dll_arg_FILES})

  message(DEBUG "target: ${target}")
  message(DEBUG "files: ${files}")

  # gersemi: off
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND
      ${CMAKE_COMMAND}
      -D src_files=[==[${files}]==]
      -D dest_dir="$<TARGET_FILE_DIR:${target}>"
      -P "${CMAKE_SOURCE_DIR}/cmake/target_copy_files_impl.cmake"
    COMMENT ""
  )
  # gersemi: on
endfunction()

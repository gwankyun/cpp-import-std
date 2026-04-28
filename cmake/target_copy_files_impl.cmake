message(DEBUG "src_files: ${src_files}")
message(DEBUG "dest_dir: ${dest_dir}")

# 去除前後的[==和]==
string(REGEX REPLACE "^\\[==\\[(.*)\\]==\\]$" "\\1" src_files "${src_files}")

foreach(f IN LISTS src_files)
  message(DEBUG "f: ${f}")

  cmake_path(GET f FILENAME app_name)

  cmake_path(SET dest NORMALIZE "${dest_dir}/${app_name}")

  file(COPY_FILE ${f} ${dest} RESULT result ONLY_IF_DIFFERENT)

endforeach()

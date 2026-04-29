message(DEBUG "src_files: ${src_files}")
message(DEBUG "dest_dir: ${dest_dir}")

# 去除前後的[==和]==
string(REGEX REPLACE "^\\[==\\[(.*)\\]==\\]$" "\\1" src_files "${src_files}")

foreach(f IN LISTS src_files)

  cmake_path(GET f PARENT_PATH parent)
  cmake_path(GET f FILENAME file_name)

  cmake_path(SET dest NORMALIZE "${dest_dir}/${file_name}")

  file(COPY_FILE ${f} ${dest} RESULT result ONLY_IF_DIFFERENT)

  message(DEBUG "copy ${file_name} from ${parent} to ${dest_dir}")

endforeach()

# set(src "${STD_PATH}/${STD_MODULE}")
# set(dest "${PROJECT_BINARY_DIR}/${STD_MODULE}")

# 文件复制，仅在文件内容不同时复制
file(COPY_FILE ${SRC_PATH} ${DEST_PATH} RESULT result ONLY_IF_DIFFERENT)

if(NOT result EQUAL 0)
  message(FATAL_ERROR "copy ${SRC_PATH} to ${DEST_PATH} failed")
endif()

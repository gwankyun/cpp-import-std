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

# 獲取當前C++標準庫模塊的UUID
function(get_import_std result)
  set(uuid "")
  set(import_std_330 "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")
  set(import_std_400 "a9e1cf81-9932-4810-974b-6eccaf14e457")
  set(import_std_410 "d0edc3af-4c50-42ea-a356-e2862fe7a444")
  set(ver ${CMAKE_VERSION})
  if(${ver} VERSION_GREATER_EQUAL "4.3.0")                                      # >= 4.3.0
    message(WARNING "CMAKE_VERSION ${ver} not tested")
    set(uuid "${import_std_410}")
  elseif(${ver} VERSION_GREATER_EQUAL "4.1.0" AND ${ver} VERSION_LESS "4.3.0")  # >= 4.1.0  && < 4.3.0
    set(uuid "${import_std_410}") # 衹保證在[4.1.0, 4.2.0]有效
  elseif(${ver} VERSION_GREATER_EQUAL "4.0.0" AND ${ver} VERSION_LESS "4.1.0")  # >= 4.0.0  && < 4.1.0
    set(uuid "${import_std_400}") # [4.0.0, 4.1.0)有效
  elseif(${ver} VERSION_GREATER_EQUAL "3.30.0" AND ${ver} VERSION_LESS "4.0.0") # >= 3.30.0 && < 4.0.0
    set(uuid "${import_std_330}") # [3.30, 4.0.0)有效
  else()
    message(FATAL_ERROR "CMAKE_VERSION ${ver} not supported")
  endif()
  set(${result} "${uuid}" PARENT_SCOPE)
endfunction()

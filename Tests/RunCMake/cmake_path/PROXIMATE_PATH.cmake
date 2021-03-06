
include ("${RunCMake_SOURCE_DIR}/check_errors.cmake")
unset (errors)

if (WIN32)
  set (path "c:/a/d")
  cmake_path(PROXIMATE_PATH path BASE_DIRECTORY "e/d/c")
  if (NOT path STREQUAL "c:/a/d")
    list (APPEND errors "'${path}' instead of 'c:/a/d'")
  endif()
else()
  set (path "/a/d")
  cmake_path(PROXIMATE_PATH path BASE_DIRECTORY "e/d/c")
  if (NOT path STREQUAL "/a/d")
    list (APPEND errors "'${path}' instead of '/a/d'")
  endif()
endif()

set (path "/a/d")
cmake_path(PROXIMATE_PATH path BASE_DIRECTORY "/a/b/c" OUTPUT_VARIABLE output)
if (NOT path STREQUAL "/a/d")
  list (APPEND errors "input changed unexpectedly")
endif()
if (NOT output STREQUAL "../../d")
  list (APPEND errors "'${output}' instead of '../../d'")
endif()

set (path "${CMAKE_CURRENT_SOURCE_DIR}/a/d")
cmake_path(PROXIMATE_PATH path)
if (NOT path STREQUAL "a/d")
  list (APPEND errors "'${path}' instead of 'a/d'")
endif()

set (path "a/b/c")
cmake_path(PROXIMATE_PATH path)
if (NOT path STREQUAL "a/b/c")
  list (APPEND errors "'${path}' instead of 'a/b/c'")
endif()


check_errors (PROXIMATE_PATH ${errors})

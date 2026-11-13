if(APPLE)
  # Homebrew's Qt 6 prefix depends on the host architecture.
  foreach(qt_prefix "/opt/homebrew/opt/qt" "/usr/local/opt/qt")
    if(EXISTS "${qt_prefix}")
      list(APPEND CMAKE_PREFIX_PATH "${qt_prefix}")
    endif()
  endforeach()
endif()

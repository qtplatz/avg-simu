cmake_minimum_required( VERSION 3.5 )
project( pksimu )
cmake_policy(SET CMP0022 NEW)
cmake_policy(SET CMP0020 NEW)
cmake_policy(SET CMP0028 NEW)

set( CMAKE_EXPORT_COMPILE_COMMANDS ON )

set ( CMAKE_INCLUDE_CURRENT_DIR ON)
set ( CMAKE_CXX_STANDARD 14 )

include( "standalone.cmake" )

find_package( Boost 1.57 REQUIRED COMPONENTS
  filesystem
  iostreams
  locale
  program_options
  regex
  system
  )

if ( Boost_FOUND )
  include_directories( ${Boost_INCLUDE_DIRS} )
endif()


add_executable( ${PROJECT_NAME}
  main.cpp
  )

target_link_libraries( ${PROJECT_NAME} PUBLIC ${Boost_LIBRARIES} )


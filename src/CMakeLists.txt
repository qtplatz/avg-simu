cmake_minimum_required( VERSION 3.5 )
project( avgsimu )
cmake_policy(SET CMP0022 NEW)
cmake_policy(SET CMP0020 NEW)
cmake_policy(SET CMP0028 NEW)

set( CMAKE_EXPORT_COMPILE_COMMANDS ON )

set ( CMAKE_INCLUDE_CURRENT_DIR ON)
set ( CMAKE_CXX_STANDARD 20 )

include( "standalone.cmake" )

find_package( Boost 1.57 REQUIRED COMPONENTS
  filesystem
  iostreams
  locale
  program_options
  regex
  system
  chrono
  thread
  )

if ( Boost_FOUND )
  include_directories( ${Boost_INCLUDE_DIRS} )
endif()

include_directories(
  ${CMAKE_SOURCE_DIR}/../../qtplatz/src/libs/adportable/counting
  ${CMAKE_SOURCE_DIR}/../../qtplatz/src/libs
  )

add_executable( ${PROJECT_NAME}
  main.cpp
  )

target_link_libraries( ${PROJECT_NAME} PUBLIC ${Boost_LIBRARIES} )

add_executable( pdf
  pdf.cpp
  )
target_link_libraries( pdf PUBLIC ${Boost_LIBRARIES} )


add_executable( cauchy
  cauchy.cpp
  )

target_link_libraries( cauchy PUBLIC ${Boost_LIBRARIES} )

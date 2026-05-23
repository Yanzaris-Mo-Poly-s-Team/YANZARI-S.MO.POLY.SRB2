cmake_minimum_required(VERSION 3.16)

#--------------------------------------------------------------------------------------------
#---*CMakeLists.txt
#--*A CMake build system so you can compile the Mod
#--*
#--*By ヤンザリ (Yanzari)
#--------------------------------------------------------------------------------------------

project(SMRFCL_Yanzaris_Mo_Poly)

#--$ Project Configuration
set(MOD_NAME "SMRFCL_Yanzaris-Mo-Poly")
set(VERSION "v0.0.1")
set(OUTPUT "${MOD_NAME}_${VERSION}.pk3")

#--$ Directory Structure
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")
set(BUILD_DIR "${CMAKE_BINARY_DIR}/build")
set(TEMP_DIR "${BUILD_DIR}/temp")

#--$ Build Type
if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Release)
endif()

#--------------------------------------------------------------------------------------------
#--*Validation
#--------------------------------------------------------------------------------------------

if(NOT EXISTS "${SRC_DIR}")
	message(FATAL_ERROR "Source directory '${SRC_DIR}' not found!")
endif()

#--------------------------------------------------------------------------------------------
#--*Prepare Build Directories
#--------------------------------------------------------------------------------------------

file(MAKE_DIRECTORY "${BUILD_DIR}")
file(MAKE_DIRECTORY "${TEMP_DIR}")

#--------------------------------------------------------------------------------------------
#--*Copy Source Files
#--------------------------------------------------------------------------------------------

file(COPY "${SRC_DIR}/"
	DESTINATION "${TEMP_DIR}")

#--------------------------------------------------------------------------------------------
#--*Generate Maketype.lua
#--------------------------------------------------------------------------------------------

file(MAKE_DIRECTORY "${TEMP_DIR}/Lua")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")

	file(WRITE "${TEMP_DIR}/Lua/Maketype.lua"
"local YMP = YanzMoPoly
YMP.BuildType = {build=\"Debug\",compmod=\"cmake\"}
")

else()

	file(WRITE "${TEMP_DIR}/Lua/Maketype.lua"
"local YMP = YanzMoPoly
YMP.BuildType = {build=\"Release\",compmod=\"cmake\"}
")

endif()

#--------------------------------------------------------------------------------------------
#--*Create Build Note
#--------------------------------------------------------------------------------------------

file(WRITE "${TEMP_DIR}/.build-note"
"Thank you for building the mod via cmake, yanzari appreciates it.

—Yanzari
")

#--------------------------------------------------------------------------------------------
#--*LAUX Compilation
#--------------------------------------------------------------------------------------------

message(STATUS "Compiling recursive .laux files...")

execute_process(
	COMMAND lauxc workspace
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
	RESULT_VARIABLE LAUX_RESULT
)

if(NOT LAUX_RESULT EQUAL 0)
	message(FATAL_ERROR "LAUX compilation failed!")
endif()

#--------------------------------------------------------------------------------------------
#--*Remove .laux Files Recursively
#--------------------------------------------------------------------------------------------

file(GLOB_RECURSE LAUX_FILES
	"${TEMP_DIR}/*.laux")

foreach(FILE ${LAUX_FILES})
	file(REMOVE "${FILE}")
endforeach()

#--------------------------------------------------------------------------------------------
#--*Create PK3
#--------------------------------------------------------------------------------------------

find_program(ZIP_EXECUTABLE zip)

if(NOT ZIP_EXECUTABLE)
	message(FATAL_ERROR "zip executable not found!")
endif()

add_custom_target(build_pk3 ALL

	COMMAND ${CMAKE_COMMAND} -E echo "Creating PK3 archive..."

	COMMAND
	${ZIP_EXECUTABLE}
	-qr
	"${CMAKE_BINARY_DIR}/${OUTPUT}"
	.

	WORKING_DIRECTORY "${TEMP_DIR}"

	COMMAND ${CMAKE_COMMAND} -E echo "✓ Created ${OUTPUT}"

)

#--------------------------------------------------------------------------------------------
#--*Clean Extra Files
#--------------------------------------------------------------------------------------------

set_property(
	DIRECTORY
	APPEND PROPERTY
	ADDITIONAL_MAKE_CLEAN_FILES
	"${CMAKE_BINARY_DIR}/${OUTPUT}"
)

#--------------------------------------------------------------------------------------------
#--*Info
#--------------------------------------------------------------------------------------------

message(STATUS "========================================")
message(STATUS "${MOD_NAME} Build System")
message(STATUS "========================================")
message(STATUS "Version: ${VERSION}")
message(STATUS "Output: ${OUTPUT}")
message(STATUS "Source Directory: ${SRC_DIR}")
message(STATUS "Build Directory: ${BUILD_DIR}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")

#--------------------------------------------------------------------------------------------
#--*End*--*CMakeLists.txt
#--------------------------------------------------------------------------------------------
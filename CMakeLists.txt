#--------------------------------------------------------------------------------------------
#---*CMakeLists.txt
#--*A CMakeLists.txt file is available for you to compile in CMake.
#--*
#--*By Yanzari
#--------------------------------------------------------------------------------------------
#--*Start*--*CMakeLists.txt*--

#--*Comment*--*Requires CMake 3.10*
cmake_minimum_required(VERSION 3.10)
project(YanzarisMoPolyByYanzari)

#--*Category*-- 
#--*Settings
#--*Category*-- 

set(MOD_NAME "SMRFCL_Yanzaris-Mo-Poly")
set(VERSION "v0.0.1")
set(OUTPUT_FILE "${MOD_NAME}_${VERSION}.pk3")

#--*Comment*--*If you don't have a build type*
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

#--*Comment*--*Directories*
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(LUA_DIR ${SRC_DIR}/Lua)
set(BUILD_TEMP_DIR ${CMAKE_CURRENT_BINARY_DIR}/temp_pk3)

#--*Comment*--*A Note from Build*
set(BUILD_NOTE_CONTENT "Thank you for building the mod via cmake, yanzari appreciates it.

—Yanzari")

#--*Comment*--*Create a MakeType.lua file in the Lua folder of the mod*
function(create_maketype_lua build_type)
    if(${build_type} STREQUAL "Debug")
        file(WRITE ${BUILD_TEMP_DIR}/Lua/Maketype.lua 
            "local YMP = YanzMoPoly\n"
            "YMP.BuildType = {build=\"Debug\",compmod=\"cmake\"}"
        )
    else()
        file(WRITE ${BUILD_TEMP_DIR}/Lua/Maketype.lua 
            "local YMP = YanzMoPoly\n"
            "YMP.BuildType = {build=\"Release\",compmod=\"cmake\"}"
        )
    endif()
endfunction()

#--*Comment*--*Custom target to create a custom .pk3 file*
add_custom_target(pk3 ALL
    COMMENT "Building ${OUTPUT_FILE} in ${CMAKE_BUILD_TYPE} mode"
    DEPENDS ${SRC_DIR}
)

#--*Comment*--*Creating the command to make the .pk3 file*
add_custom_command(
    TARGET pk3
    PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${BUILD_TEMP_DIR}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${BUILD_TEMP_DIR}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${BUILD_TEMP_DIR}/Lua
    COMMENT "Preparing build directories"
)

add_custom_command(
    TARGET pk3
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${SRC_DIR} ${BUILD_TEMP_DIR}
    COMMENT "Copying source files"
)

add_custom_command(
    TARGET pk3
    COMMAND ${CMAKE_COMMAND} -E echo "${BUILD_NOTE_CONTENT}" > ${BUILD_TEMP_DIR}/.build-note
    COMMENT "Creating .build-note"
)

add_custom_command(
    TARGET pk3
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_FILE}.maketype.cmake
    COMMENT "Creating Maketype.lua"
)

add_custom_command(
    TARGET pk3
    COMMAND ${CMAKE_COMMAND} -E tar cf ${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_FILE} --format=zip .
    WORKING_DIRECTORY ${BUILD_TEMP_DIR}
    COMMENT "Creating PK3 archive"
)

add_custom_command(
    TARGET pk3
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${BUILD_TEMP_DIR}
    COMMENT "Cleaning temporary files"
)

#--*Comment*--*Write to the file to determine if the file is from cmake or make, and if it is debug or release*
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/CMakeLists.txt.maketype.cmake
    "if(\"\${CMAKE_BUILD_TYPE}\" STREQUAL \"Debug\")\n"
    "    file(WRITE \${BUILD_TEMP_DIR}/Lua/Maketype.lua \n"
    "        \"local YMP = YanzMoPoly\\n\"\n"
    "        \"YMP.BuildType = {build=\\\"Debug\\\",compmod=\\\"cmake\\\"}\"\n"
    "    )\n"
    "else()\n"
    "    file(WRITE \${BUILD_TEMP_DIR}/Lua/Maketype.lua \n"
    "        \"local YMP = YanzMoPoly\\n\"\n"
    "        \"YMP.BuildType = {build=\\\"Release\\\",compmod=\\\"cmake\\\"}\"\n"
    "    )\n"
    "endif()\n"
)

#--*Category*-- 
#--*Utility Targets
#--*Category*-- 
add_custom_target(clean
    COMMENT "Cleaning build artifacts"
    COMMAND ${CMAKE_COMMAND} -E remove -f ${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_FILE}
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${BUILD_TEMP_DIR}
)

add_custom_target(info
    COMMENT "Project Information:\n"
            "  Name: ${MOD_NAME}\n"
            "  Version: ${VERSION}\n"
            "  Output: ${OUTPUT_FILE}\n"
            "  Build Type: ${CMAKE_BUILD_TYPE}\n"
            "  Source Dir: ${SRC_DIR}"
)

add_custom_target(help
    COMMENT "Available targets:\n"
            "  make pk3 (or just make) - Build the PK3 file\n"
            "  make clean - Remove build artifacts\n"
            "  make info - Show project information\n"
            "  make help - Show this help message\n\n"
            "Build types:\n"
            "  Debug: cmake -DCMAKE_BUILD_TYPE=Debug ..\n"
            "  Release: cmake -DCMAKE_BUILD_TYPE=Release .."
)

#--*Comment*--*Print the Success Message!!*
add_custom_command(
    TARGET pk3
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "The compilation was completed successfully."
    COMMAND ${CMAKE_COMMAND} -E echo "Output: ${OUTPUT_FILE}"
    COMMAND ${CMAKE_COMMAND} -E echo "File Made By Yanzari"
)


#--*End*--*CMakeLists.txt*--
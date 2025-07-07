cmake_minimum_required(VERSION 3.28)

project(nexus_addon)
set(CMAKE_CXX_STANDARD 20)

# Set output name via parameter, default to clion_demo
set(ADDON_OUTPUT_NAME "clion_demo" CACHE STRING "Name of the output DLL/library (without extension)")

# Gather all sources and headers automatically
file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS src/*.cpp src/*.h resources/resources.h)

# Only include ImGui headers, do not add ImGui sources
set(MODULES_HEADERS
    "modules/imgui/imgui.h"
    "modules/nexus/Nexus.h"
    "modules/mumble/Mumble.h"
)

set(IMGUI_SOURCES
        "modules/imgui/imgui.cpp"
        "modules/imgui/imgui_demo.cpp"
        "modules/imgui/imgui_draw.cpp"
        "modules/imgui/imgui_tables.cpp"
        "modules/imgui/imgui_widgets.cpp"
        src/Globals.cpp
)

# Resources
set(RC_FILE
        resources/resources.rc
)
enable_language(RC)

add_library(${ADDON_OUTPUT_NAME} SHARED
    ${SRC_FILES}
    ${MODULES_HEADERS}
    ${IMGUI_SOURCES}
    ${RC_FILE}
)

# Set output properties for Windows DLL
set_target_properties(${ADDON_OUTPUT_NAME} PROPERTIES
    OUTPUT_NAME "${ADDON_OUTPUT_NAME}"
    PREFIX "lib"
    SUFFIX ".dll"
)

# Build types and output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR})

#
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static -g")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static -g")
else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static -O2")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static -O2")
endif()

target_link_libraries(
    ${ADDON_OUTPUT_NAME}
    ntdll
)

# Export DLL for Dockerfile (copy to predictable name)
add_custom_command(TARGET ${ADDON_OUTPUT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        $<TARGET_FILE:${ADDON_OUTPUT_NAME}>
        ${CMAKE_BINARY_DIR}/lib${ADDON_OUTPUT_NAME}.dll
)

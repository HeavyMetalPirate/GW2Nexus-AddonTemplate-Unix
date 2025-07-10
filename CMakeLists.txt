cmake_minimum_required(VERSION 3.28)

project(nexus_addon)
set(CMAKE_CXX_STANDARD 20)

find_package(rcgg-nexus-api)
find_package(rcgg-mumble-api)
find_package(imgui)

# Set output name via parameter, default to clion_demo
set(ADDON_OUTPUT_NAME "clion_demo" CACHE STRING "Name of the output DLL/library (without extension)")

# Gather all sources and headers automatically
file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS src/*.cpp src/*.h resources/resources.h)

# Resources
set(RC_FILE
        resources/resources.rc
)
enable_language(RC)

add_library(${ADDON_OUTPUT_NAME} SHARED
        ${SRC_FILES}
        ${RC_FILE}
)

# Set output properties for Windows DLL
set_target_properties(${ADDON_OUTPUT_NAME} PROPERTIES
    OUTPUT_NAME "${ADDON_OUTPUT_NAME}"
    SUFFIX ".dll"
)

# Build types and output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR})

target_link_libraries(${ADDON_OUTPUT_NAME}
        PRIVATE
            rcgg-nexus-api::rcgg-nexus-api
            rcgg-mumble-api::rcgg-mumble-api
            imgui::imgui
)

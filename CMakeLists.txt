cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# Search for a toolchain in environment if not explicitly set
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE AND DEFINED ENV{CMAKE_TOOLCHAIN_FILE})
    message("CMAKE_TOOLCHAIN_FILE found in environment: " $ENV{CMAKE_TOOLCHAIN_FILE})
    set(CMAKE_TOOLCHAIN_FILE $ENV{CMAKE_TOOLCHAIN_FILE})
endif()

project(Kube)

if(NOT DEFINED KF_EXAMPLES)
    set(KF_EXAMPLES FALSE)
endif()

get_filename_component(KubeRootDir ${CMAKE_CURRENT_LIST_FILE} PATH)

# Add compiler specific flags
if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(
        -Wall
        -fdiagnostics-color=always
    )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    add_compile_options(
        /Zc:preprocessor
    )
endif()

include(${KubeRootDir}/External/External.cmake)

include(${KubeRootDir}/Kube/Kube.cmake)

if(${KF_EXAMPLES})
    include(${KubeRootDir}/Examples/Examples.cmake)
endif()
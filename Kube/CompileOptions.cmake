cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(Kube)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED 20)

include_directories(${KubeSourcesDir}/..)

if (UNIX OR APPLE)
    add_compile_options(
        -Wall
    )
elseif(WIN32)
    add_compile_options(
        /Zc:preprocessor
    )
endif()
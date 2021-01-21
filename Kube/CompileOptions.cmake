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

# Enable unit testing
option(KF_TESTS "Build tests" OFF)

# Enable coverage over unit tests
option(KF_COVERAGE "Build benchmarks" OFF)

# Enable benchmarking
option(KF_BENCHMARKS "Build benchmarks" OFF)

cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
get_filename_component(KubeRootDir ${CMAKE_CURRENT_LIST_FILE} PATH)

# Include toolchain options
include(${KubeRootDir}/CompileOptions/ToolchainOptions.cmake)

# Declare Kube project after toolchain options
project(Kube)

# Include compile options
include(${KubeRootDir}/CompileOptions/CompileOptions.cmake)

# Enable Werror
option(KF_WERROR "Enable -Werror flag with GCC / Clang")

# Enable examples
option(KF_EXAMPLES "Build examples" OFF)

# Enable unit testing
option(KF_TESTS "Build tests" OFF)

# Enable coverage over unit tests
option(KF_COVERAGE "Enable coverage" OFF)

# Enable benchmarking
option(KF_BENCHMARKS "Build benchmarks" OFF)

include_directories(${KubeRootDir})

# Include external libraries
include(${KubeRootDir}/External/External.cmake)

# Include Kube framework
include(${KubeRootDir}/Kube/Kube.cmake)

# Build examples
if(${KF_EXAMPLES})
    include(${KubeRootDir}/Examples/Examples.cmake)
endif()
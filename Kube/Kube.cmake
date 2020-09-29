cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(Kube)

get_filename_component(KubeSourcesDir ${CMAKE_CURRENT_LIST_FILE} PATH)

include_directories(${KubeSourcesDir}/..)

if(NOT DEFINED KF_TESTS)
    set(KF_TESTS FALSE)
elseif(${KF_TESTS})
    find_package(GTest REQUIRED)
    enable_testing()
endif()

if(NOT DEFINED KF_BENCHMARKS)
    set(KF_BENCHMARKS FALSE)
elseif(${KF_BENCHMARKS})
    find_package(benchmark REQUIRED)
endif()

if(NOT DEFINED KF_APP)
    set(KF_APP FALSE)
endif()

if(NOT DEFINED KF_CORE)
    set(KF_CORE FALSE)
endif()

if(NOT DEFINED KF_ECS)
    set(KF_ECS FALSE)
endif()

if(NOT DEFINED KF_GRAPHICS)
    set(KF_GRAPHICS FALSE)
endif()

if(NOT DEFINED KF_INTERPRETER)
    set(KF_INTERPRETER FALSE)
endif()

if(NOT DEFINED KF_META)
    set(KF_META FALSE)
endif()

if(NOT DEFINED KF_FLOW)
    set(KF_FLOW FALSE)
endif()

if(NOT DEFINED KF_ALL
    AND NOT ${KF_APP} AND NOT ${KF_CORE}
    AND NOT ${KF_ECS} AND NOT ${KF_GRAPHICS} AND NOT ${KF_INTERPRETER}
    AND NOT ${KF_META} AND NOT ${KF_FLOW})
    set(KF_ALL TRUE)
else()
    set(KF_ALL FALSE)
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED 20)

if(${KF_ALL} OR ${KF_CORE})
    include(${KubeSourcesDir}/Core/Core.cmake)
endif()

if(${KF_ALL} OR ${KF_META})
    include(${KubeSourcesDir}/Meta/Meta.cmake)
endif()

# if(${KF_ALL} OR ${KF_FLOW})
#     include(${KubeSourcesDir}/Flow/Flow.cmake)
# endif()

if(${KF_ALL} OR ${KF_ECS})
    include(${KubeSourcesDir}/ECS/ECS.cmake)
endif()

if(${KF_ALL} OR ${KF_INTERPRETER})
    include(${KubeSourcesDir}/Interpreter/Interpreter.cmake)
endif()

if(${KF_ALL} OR ${KF_GRAPHICS})
    include(${KubeSourcesDir}/Graphics/Graphics.cmake)
endif()

if(${KF_ALL} OR ${KF_APP})
    include(${KubeSourcesDir}/App/App.cmake)
endif()
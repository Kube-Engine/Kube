cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(Kube)

get_filename_component(KubeSourcesDir ${CMAKE_CURRENT_LIST_FILE} PATH)

include(${KubeSourcesDir}/CompileOptions.cmake)

set(AtLeastOneManualTag FALSE)

function(kube_setup_module Tag Hint)
    set(${Tag}_PATH "${KubeSourcesDir}/${Hint}/${Hint}.cmake" PARENT_SCOPE)
    set(${Tag}_COMPILED FALSE PARENT_SCOPE)
    if(NOT DEFINED ${Tag})
        message("${Tag} is not manually specified")
        set(${Tag} FALSE PARENT_SCOPE)
    else()
        message("${Tag} is manually specified to ${${Tag}}")
        set(AtLeastOneManualTag TRUE PARENT_SCOPE)
    endif()
endfunction()

function(kube_include_module Tag)
    if(${Tag}_COMPILED) # Already compiled
        return()
    elseif(NOT ${AtLeastOneManualTag}) ## All modules must be compiled
        set(${Tag}_COMPILED TRUE PARENT_SCOPE)
        message("-> Including module ${Tag}")
        include(${${Tag}_PATH})
    elseif(${Tag}) # If module is manually specified to be compiled
        set(${Tag}_COMPILED TRUE PARENT_SCOPE)
        message("-> Including module ${Tag}")
        foreach(Dependency ${ARGN})
            set(${Dependency} TRUE)
            kube_include_module(${Dependency})
        endforeach()
        include(${${Tag}_PATH})
    endif()
endfunction()

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

kube_setup_module(KF_APP App)
kube_setup_module(KF_CORE Core)
kube_setup_module(KF_ECS ECS)
kube_setup_module(KF_GRAPHICS Graphics)
kube_setup_module(KF_INTERPRETER Interpreter)
kube_setup_module(KF_META Meta)
kube_setup_module(KF_FLOW Flow)

kube_include_module(KF_CORE)

kube_include_module(KF_META
# Dependencies
    KF_CORE
)

kube_include_module(KF_FLOW
# Dependencies
    KF_CORE
)

kube_include_module(KF_GRAPHICS
# Dependencies
    KF_CORE
)

kube_include_module(KF_ECS
# Dependencies
    KF_CORE KF_FLOW
)

kube_include_module(KF_INTERPRETER
# Dependencies
    KF_CORE KF_META KF_FLOW KF_ECS
)

kube_include_module(KF_APP
# Dependencies
    KF_CORE KF_META KF_INTERPRETER KF_GRAPHICS KF_FLOW KF_ECS
)
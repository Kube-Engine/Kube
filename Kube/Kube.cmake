cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(Kube)

get_filename_component(KubeSourcesDir ${CMAKE_CURRENT_LIST_FILE} PATH)

include(${KubeSourcesDir}/CompileOptions.cmake)

set(AtLeastOneManualTag FALSE)

# Used to setup a kube module and its dependencies (VARGS)
function(kube_setup_module Tag Hint)
    set(${Tag}_PATH "${KubeSourcesDir}/${Hint}/${Hint}.cmake" PARENT_SCOPE)
    set_property(GLOBAL PROPERTY ${Tag}_COMPILED FALSE)
    if(NOT DEFINED ${Tag})
        message("* ${Tag} is not manually specified")
        set(${Tag} OFF PARENT_SCOPE)
        set(${Tag}_MANUAL FALSE PARENT_SCOPE)
        set(${Tag}_TESTS OFF PARENT_SCOPE)
        set(${Tag}_BENCHMARKS OFF PARENT_SCOPE)
    else()
        message("* ${Tag} is manually specified to ${${Tag}}")
        set(AtLeastOneManualTag TRUE PARENT_SCOPE)
        set(${Tag}_MANUAL TRUE PARENT_SCOPE)
        set(${Tag}_TESTS ${KF_TESTS} PARENT_SCOPE)
        set(${Tag}_BENCHMARKS ${KF_BENCHMARKS} PARENT_SCOPE)
    endif()
    set(${Tag}_DEPENDENCIES ${ARGN} PARENT_SCOPE)
endfunction()

# Used to include a module and recurse over dependencies
function(kube_include_module Tag)
    set(IsCompiled FALSE)
    get_property(IsCompiled GLOBAL PROPERTY ${Tag}_COMPILED)
    if(IsCompiled) # Already compiled
        return()
    elseif(NOT ${AtLeastOneManualTag}) ## All modules must be compiled
        set_property(GLOBAL PROPERTY ${Tag}_COMPILED TRUE)
    elseif(${Tag}) # If module is specified to be compiled
        set_property(GLOBAL PROPERTY ${Tag}_COMPILED TRUE)
        if(${Tag}_DEPENDENCIES)
            foreach(Dependency ${${Tag}_DEPENDENCIES})
                set(${Dependency} TRUE)
                kube_include_module(${Dependency})
            endforeach()
        endif()
        set(KF_TESTS ${${Tag}_TESTS})
        set(KF_BENCHMARKS ${${Tag}_BENCHMARKS})
    else()
        return()
    endif()
    message("-> Including module " ${Tag} " | Tests=" ${KF_TESTS} " Benchmarks=" ${KF_BENCHMARKS})
    include(${${Tag}_PATH})
endfunction()

if(NOT DEFINED KF_TESTS)
    set(KF_TESTS OFF)
    message("* KF_TESTS is not manually specified")
elseif(${KF_TESTS})
    find_package(GTest REQUIRED)
    enable_testing()
    message("* KF_TESTS is manually specified to " ${KF_TESTS})
endif()

if(NOT DEFINED KF_BENCHMARKS)
    set(KF_BENCHMARKS OFF)
    message("* KF_BENCHMARKS is not manually specified")
elseif(${KF_BENCHMARKS})
    find_package(benchmark REQUIRED)
    message("* KF_BENCHMARKS is manually specified to " ${KF_BENCHMARKS})
endif()

# Level 0: Foundations, C++ guideline and rules
kube_setup_module(KF_CORE Core)

# Level 1: Low level high performance backends
kube_setup_module(KF_AUDIO          Audio       KF_CORE)
kube_setup_module(KF_GRAPHICS       Graphics    KF_CORE)
kube_setup_module(KF_META           Meta        KF_CORE)
kube_setup_module(KF_FLOW           Flow        KF_CORE)

# Level 2: Higher level objects and concepts
kube_setup_module(KF_ECS            ECS         KF_FLOW)
kube_setup_module(KF_OBJECT         Object      KF_META)

# Level 3: Implementation of general utiliies using L2 concepts
kube_setup_module(KF_INTERPRETER    Interpreter KF_OBJECT KF_FLOW)
kube_setup_module(KF_VOXEL          Voxel       KF_GRAPHICS KF_ECS)
kube_setup_module(KF_UI             UI          KF_GRAPHICS KF_ECS)

# Level 4: Implementation of specific utilities using L3 concepts
kube_setup_module(KF_WIDGETS        Widgets     KF_OBJECT KF_UI)

# Level 5: Application level
kube_setup_module(KF_APP            App         KF_WIDGETS KF_INTERPRETER)

# Level 6: Specialized applications
# kube_setup_module(KF_APP VoxelApp               KF_APP KF_VOXEL)

# Include each module and check if they should be compiled (will recurse on dependencies)
kube_include_module(KF_CORE)
kube_include_module(KF_AUDIO)
kube_include_module(KF_GRAPHICS)
kube_include_module(KF_META)
kube_include_module(KF_FLOW)
kube_include_module(KF_ECS)
kube_include_module(KF_OBJECT)
kube_include_module(KF_INTERPRETER)
kube_include_module(KF_UI)
kube_include_module(KF_VOXEL)
kube_include_module(KF_WIDGETS)
kube_include_module(KF_APP)
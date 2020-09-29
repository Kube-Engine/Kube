cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(Kube)

if (NOT DEFINED KF_EXAMPLES)
    set(KF_EXAMPLES FALSE)
endif ()

get_filename_component(KubeRootDir ${CMAKE_CURRENT_LIST_FILE} PATH)

add_compile_options(-fdiagnostics-color=always)

include(${KubeRootDir}/External/External.cmake)

include(${KubeRootDir}/Kube/Kube.cmake)

if (${KF_EXAMPLES})
    include(${KubeRootDir}/Examples/Examples.cmake)
endif ()
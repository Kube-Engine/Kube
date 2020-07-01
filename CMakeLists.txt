cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(Kube)

get_filename_component(KubeRootDir ${CMAKE_CURRENT_LIST_FILE} PATH)

include(${KubeRootDir}/External/External.cmake)

include(${KubeRootDir}/Kube/Kube.cmake)